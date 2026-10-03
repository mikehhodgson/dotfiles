#!/usr/bin/env python3
"""Run with python3 tests/test_stowdiff.py; requires installed GNU Stow and diff."""
import os
import pty
from pathlib import Path
import subprocess
import tempfile

SCRIPT = Path(__file__).resolve().parents[1] / "bin/.local/bin/stowdiff"


with tempfile.TemporaryDirectory(prefix="stowdiff-") as tmp:
    root = Path(tmp)
    home, repo, cwd = (root / name for name in ("home", "repo", "elsewhere"))
    for directory in (home, repo, cwd):
        directory.mkdir()
    (home / ".stowrc").write_text(
        '--dir="$HOME/../repo"\n--target=~/\n--ignore=ignored\n--verbose=1\n--no-folding\n'
    )
    alpha, beta = repo / "alpha", repo / "beta"
    alpha.mkdir()
    beta.mkdir()
    (alpha / ".stow-local-ignore").write_text("^/local-ignore$\n")
    for name in ("changed file", "identical", "missing", "linked", "wrong", "dangling", "blocked", "ignored", "local-ignore"):
        (alpha / name).write_text("personal\n")
    (home / "changed file").write_text("omarchy\n")
    (home / "identical").write_text("personal\n")
    (home / "linked").symlink_to(alpha / "linked")
    (home / "other").write_text("other\n")
    (home / "wrong").symlink_to(home / "other")
    (home / "dangling").symlink_to(home / "absent")
    (home / "blocked").mkdir()
    (alpha / "blocked-dir").mkdir()
    (alpha / "blocked-dir/child").write_text("personal\n")
    (home / "blocked-dir").write_text("blocker\n")
    (beta / "folded").mkdir()
    (beta / "folded/file").write_text("personal\n")
    (home / "folded").symlink_to(beta / "folded", target_is_directory=True)
    (beta / "dot-config").mkdir()
    (beta / "dot-config/dot-settings").write_text("personal\n")
    (home / ".config").mkdir()
    (home / ".config/.settings").write_text("omarchy\n")
    (cwd / ".stowrc").write_text("--dotfiles\n")
    env = dict(os.environ, HOME=str(home))

    def snapshot():
        return sorted(
            (str(p.relative_to(root)), "link", os.readlink(p)) if p.is_symlink()
            else (str(p.relative_to(root)), "file", p.read_bytes()) if p.is_file()
            else (str(p.relative_to(root)), "dir", None)
            for p in root.rglob("*")
        )

    def run(*packages):
        return subprocess.run(
            [str(SCRIPT), *packages], cwd=cwd, env=env, text=True, capture_output=True
        )

    before = snapshot()
    result = run("alpha", "beta")
    assert result.returncode == 1, result
    output = result.stdout
    assert "-omarchy\n+personal" in output, output
    assert f'--- "{home / "changed file"}"' in output, output
    assert "Identical contents" in output, output
    assert "Missing target:" in output and str(home / "missing") in output, output
    assert "Wrong link:" in output and str(home / "wrong") in output, output
    assert str(home / "dangling") in output, output
    assert "Blocked file:" in output and "Blocked directory:" in output, output
    assert str(home / ".config/.settings") in output, output
    for name in ("linked", "folded", "ignored", "local-ignore"):
        assert str(home / name) not in output, output
    assert run("nonexistent", "alpha").returncode == 2
    assert "-omarchy\n+personal" in run("nonexistent", "alpha").stdout
    assert run("../alpha").returncode == 2
    assert run().returncode == 2
    assert run("--help").returncode == 0
    assert snapshot() == before, "stowdiff changed files"

    clean = repo / "clean"
    clean.mkdir()
    (clean / "correct").write_text("personal\n")
    (home / "correct").symlink_to(clean / "correct")
    result = run("clean")
    assert result.returncode == 0 and not result.stdout and not result.stderr, result

    # A fake pager checks automatic selection without opening an interactive UI.
    tools = root / "tools"
    tools.mkdir()
    hunk = tools / "hunk"
    hunk.write_text(
        '#!/usr/bin/env python3\nimport sys\n'
        'assert sys.argv[1:] == ["pager"]\n'
        'print("HUNK PAGER")\nprint(sys.stdin.read(), end="")\n'
    )
    hunk.chmod(0o755)
    env["PATH"] = str(tools) + os.pathsep + env["PATH"]
    assert "HUNK PAGER" not in run("alpha").stdout, "Piped output used the pager"

    def run_terminal(*packages):
        master, slave = pty.openpty()
        try:
            process = subprocess.Popen(
                [str(SCRIPT), *packages], cwd=cwd, env=env,
                stdin=subprocess.DEVNULL, stdout=slave, stderr=subprocess.PIPE,
            )
            os.close(slave)
            slave = None
            chunks = []
            while True:
                try:
                    chunk = os.read(master, 65536)
                except OSError as error:
                    if error.errno != 5:  # PTYs signal EOF with EIO on Linux.
                        raise
                    break
                if not chunk:
                    break
                chunks.append(chunk)
            _, errors = process.communicate(timeout=10)
            return process.returncode, b"".join(chunks).decode(), errors.decode()
        finally:
            os.close(master)
            if slave is not None:
                os.close(slave)

    code, output, errors = run_terminal("alpha")
    assert code == 1 and "HUNK PAGER" in output and not errors, (code, output, errors)
    assert "-omarchy\r\n+personal" in output, output
    assert run_terminal("clean") == (0, "", ""), "Empty output opened the pager"
    hunk.write_text("#!/bin/sh\nexit 1\n")
    code, output, errors = run_terminal("alpha")
    assert code == 1 and "-omarchy\r\n+personal" in output and "Hunk failed" in errors
    hunk.unlink()
    # Restrict PATH to known base utilities so an installed Hunk cannot be found.
    env["PATH"] = "/usr/bin:/bin"
    code, output, errors = run_terminal("alpha")
    assert code == 1 and "-omarchy\r\n+personal" in output and not errors

    (cwd / ".stowrc").write_text("--target=/nonexistent-stowdiff-target\n")
    assert run("clean").returncode == 2

print("stowdiff checks passed")

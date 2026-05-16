# dotfiles

This is a personal dotfiles repository.

Some configuration is intentionally machine-specific and may require local overrides or adaptation for other systems.

Makes use of GNU Stow. Currently expects to be placed in `~/src/personal/dotfiles`.

```bash
git clone https://github.com/mikehhodgson/dotfiles.git ~/src/personal/dotfiles
cd ~/src/personal/dotfiles
```

Init with stow.

```bash
stow stow
```

The `.stowrc` in the `stow` folder should place itself into `~`. This will default stow to operating on this directory and placing symlinks in home. The `.stowrc` in the root of this repo is also a symlink to `stow/.stowrc` for the initial `stow stow` to target `~/`.

The `.stowrc` contains `--no-folding`. If `~/.emacs.d` doesn't yet exist, stow by default will "tree fold" and symlink the whole `.emacs.d` directory, instead of it contents. `--no-folding` prevents this.

See https://www.gnu.org/software/stow/manual/html_node/Resource-Files.html for more.

```bash
stow git emacs ghostty x11 omarchy ...
```

### Hyprland

If hyprland config reloads improperly during git operations, try `hyprctl reload`.

Note that `~/.config/hypr/local.conf` needs to exist.

```bash
touch ~/.config/hypr/local.conf
```

## Gitleaks

https://github.com/gitleaks/gitleaks

```bash
sudo pacman -S gitleaks pre-commit
```

Install the git hooks in `.pre-commit-config.yaml`:

```bash
pre-commit install
```

### Manual Scanning

Scan the current working tree:

```bash
gitleaks detect --source .
```

Scan the full git history:

```bash
gitleaks git .
```

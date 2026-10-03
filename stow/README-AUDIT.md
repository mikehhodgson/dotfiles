# Stow audit

Run `~/.local/bin/audit-stow` to report whether the selected packages are
correctly linked. Omarchy also runs it through
`~/.config/omarchy/hooks/post-update.d/stow-audit` after packages and migrations.

Edit `~/.config/stow-audit/packages` to select packages: one name per line,
with `#` for comments. The initial list includes packages with existing Stow
links and Ghostty, which was previously Stow-managed. Unlisted packages are
not checked.

The script resolves its repository from its own Stow link, reads Stow's home
and repository `.stowrc` files with GNU Stow's CLI parser, and uses Stow's
ignore matcher. Package ignore files take precedence over the global ignore
file and built-in defaults, exactly as in Stow. The target comes from those
options; the update hook's working directory does not affect it.

Warnings are grouped by package and identify missing links, replacement
files, and links pointing elsewhere. Replacement files are compared byte
for byte with the package file, reporting identical, different, or unreadable
contents. Correct links through folded directory links are accepted.

The audit prints only to the terminal, never sends notifications or changes
files, and always exits successfully, including when it cannot complete.
It reports current state, not whether an update caused that state.

The script uses the installed GNU Stow executable's parsing helpers and
`Stow` Perl module; incompatible future changes produce an audit warning.
Install all three pieces with `stow bin stow omarchy` from the repository.

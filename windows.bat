mkdir %userprofile%\Documents\WindowsPowerShell
:: echo . %appdata%\dotfiles\profile.ps1 >> %userprofile%\Documents\WindowsPowerShell\profile.ps1
mklink %userprofile%\Documents\WindowsPowerShell\profile.ps1 %cd%\profile.ps1

mklink %userprofile%\.gitconfig %cd%\gitconfig

mklink %appdata%\.emacs %cd%\emacs

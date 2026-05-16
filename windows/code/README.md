# Visual Studio Code Settings

## Installation

    del %appdata%\Code\User\settings.json
    del %appdata%\Code\User\keybindings.json
    mklink %appdata%\Code\User\settings.json %appdata%\dotfiles\code\settings.json
    mklink %appdata%\Code\User\keybindings.json %appdata%\dotfiles\code\keybindings.json

## Extensions In Use

- [Emacs Friendly Keymap](https://marketplace.visualstudio.com/items?itemName=lfs.vscode-emacs-friendly)
- [SIMPLE DARK MODE](https://marketplace.visualstudio.com/items?itemName=in-the-box.simple-dark-mode)
- [seti-icons](https://marketplace.visualstudio.com/items?itemName=qinjia.seti-icons)
- [Highlight Trailing White Spaces](https://marketplace.visualstudio.com/items?itemName=ybaumes.highlight-trailing-white-spaces)
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

## Todo

- Complete color theme:
  - https://code.visualstudio.com/docs/getstarted/theme-color-reference
  - https://code.visualstudio.com/docs/extensions/themes-snippets-colorizers#_adding-a-new-theme
  - https://github.com/mikehhodgson/dotfiles/blob/master/elisp/minimal-theme.el
- More Emacs functions...

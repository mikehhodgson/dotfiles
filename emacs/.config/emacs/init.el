;; -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))

(add-to-list 'load-path
             (expand-file-name "lisp/init"
                               user-emacs-directory))

(require 'init-core)
(require 'init-packages)
(require 'init-ui)
(require 'init-editing)
(require 'init-keybinds)
(require 'init-backups)
(require 'init-theme)
(require 'init-fonts)

(require 'init-markdown)
(require 'init-dashboard)

(require 'init-completion)
(require 'init-lsp)
(require 'init-dev)

(require 'init-treemacs)
(require 'init-minimap)
(require 'init-git)

(require 'init-ai)

(load custom-file :no-error-if-file-is-missing)

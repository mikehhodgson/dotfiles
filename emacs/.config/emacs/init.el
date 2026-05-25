;; -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))

(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

(require 'init-packages)
(require 'init-ui)
;; (require 'init-editing)
;; (require 'init-keybinds)
;; (require 'init-backups)
;; (require 'init-theme)

;; (require 'init-markdown)
;; (require 'init-dashboard)

;; (require 'init-completion)
;; (require 'init-lsp)
;; (require 'init-treesit)
;; (require 'init-js)

;; (require 'init-treemacs)
;; (require 'init-minimap)
;; (require 'init-diff)
;; (require 'init-git)

;; (require 'init-ai)

(require 'init-old)

(load custom-file :no-error-if-file-is-missing)

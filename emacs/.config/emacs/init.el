;; -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))

(add-to-list 'load-path
             (expand-file-name "lisp/init"
                               user-emacs-directory))

(require 'core)
(require 'packages)
(require 'ui)
;; (require 'editing)
;; (require 'keybinds)
;; (require 'backups)
(require 'theme)
(require 'fonts)

(require 'markdown)
;; (require 'dashboard)

;; (require 'completion)
;; (require 'lsp)
;; (require 'treesit)
;; (require 'js)

;; (require 'treemacs)
;; (require 'minimap)
;; (require 'diff)
;; (require 'git)

;; (require 'ai)

(require 'original)

(load custom-file :no-error-if-file-is-missing)

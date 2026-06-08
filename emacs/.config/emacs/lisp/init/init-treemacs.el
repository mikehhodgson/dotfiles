;; -*- lexical-binding: t; -*-

;; https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-sorting 'alphabetic-case-insensitive-asc)

    (treemacs-resize-icons 16)
    (treemacs-indent-guide-mode)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil)

    ;; node_modules dimmed
    (treemacs-create-icon
     :icon (propertize "󰏗 "
                       'face 'shadow)
     :extensions (dir-closed dir-open))

    ;; special face for src
    (defface my-treemacs-src-face
      '((t (:foreground "#61afef" :weight bold)))
      "")

    ;; override display
    (font-lock-add-keywords
     'treemacs-mode
     '(("/src$" . 'my-treemacs-src-face)))

    (treemacs-define-custom-icon
     "󰉋 "
     "src")

    (treemacs-define-custom-icon
     "󰏗 "
     "node_modules"))

  :bind
  (("C-M-z"     . treemacs)
   ("M-0"       . treemacs-select-window)
   ("C-x t 1"   . treemacs-delete-other-windows)
   ("C-x t t"   . treemacs)
   ("C-x t d"   . treemacs-select-directory)
   ("C-x t B"   . treemacs-bookmark)
   ("C-x t C-t" . treemacs-find-file)
   ("C-x t M-t" . treemacs-find-tag)

   :map treemacs-mode-map
   ([mouse-1]   . treemacs-single-click-expand-action)))

(use-package treemacs-nerd-icons
  :ensure t
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

(provide 'init-treemacs)

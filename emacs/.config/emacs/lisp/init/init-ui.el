;; -*- lexical-binding: t; -*-

(blink-cursor-mode -1)
(column-number-mode 1)
(global-visual-line-mode 1)
(global-hl-line-mode t) ; highlight the whole cursor line
(setq project-mode-line t)
(setq-default show-trailing-whitespace t)

;; Line numbers
(setq display-line-numbers-type 'absolute)
(dolist (hook '(prog-mode-hook
                ;;text-mode-hook
                conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; enable mouse in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(use-package nerd-icons :ensure t)

(use-package tab-line-nerd-icons
  :ensure t
  :after nerd-icons
  :config
  (setq tab-line-nerd-icons-space-width 1.0)
  (tab-line-nerd-icons-global-mode 1))

(use-package nerd-icons-dired
  :vc (:url "https://github.com/rainstormstudio/nerd-icons-dired"
       :rev :newest)
  :after nerd-icons
  :hook
  (dired-mode . nerd-icons-dired-mode))

(provide 'init-ui)

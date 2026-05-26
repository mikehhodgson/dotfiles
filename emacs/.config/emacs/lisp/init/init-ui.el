;; -*- lexical-binding: t; -*-

(blink-cursor-mode -1)
(column-number-mode 1)
(global-visual-line-mode)
(global-hl-line-mode t) ; highlight the whole cursor line

;; Line numbers
(setq display-line-numbers-type 'absolute)
(dolist (hook '(prog-mode-hook
                ;;text-mode-hook
                conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; enable mouse in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(provide 'init-ui)

;; -*- lexical-binding: t; -*-

(keymap-global-set "M-n" 'scroll-up-line)
(keymap-global-set "M-p" 'scroll-down-line)

(keymap-global-set "M-o" 'other-window)
(keymap-global-set "M-O" '(lambda () (interactive) (other-window -1))) ; M-S-o is regonised as M-O

;; TODO next-buffer if no tab-line
(keymap-global-set "C-<tab>" 'tab-line-switch-to-next-tab)
(keymap-global-set "C-S-<tab>" 'tab-line-switch-to-prev-tab)
(keymap-global-set "C-<iso-lefttab>" 'tab-line-switch-to-prev-tab) ; laptop registered this keypress for C-S-<tab>

(keymap-global-set "M-D" 'isearch-forward-thing-at-point)

(with-eval-after-load 'elisp-mode
  (keymap-set emacs-lisp-mode-map "C-c e" #'eval-buffer))

(with-eval-after-load 'info
  (keymap-set Info-mode-map "M-n" #'scroll-up-line)
  (keymap-set Info-mode-map "M-p" #'scroll-down-line)
  (define-key Info-mode-map [mouse-8] #'Info-history-back)
  (define-key Info-mode-map [mouse-9] #'Info-history-forward))

(with-eval-after-load 'dired
  (keymap-set dired-mode-map "<mouse-1>" #'dired-find-file))


(with-eval-after-load 'help-mode
  (define-key help-mode-map [mouse-8] #'help-go-back)
  (define-key help-mode-map [mouse-9] #'help-go-forward))

(with-eval-after-load 'eww
  (define-key eww-mode-map [mouse-8] #'eww-back-url)
  (define-key eww-mode-map [mouse-9] #'eww-forward-url))

(provide 'init-keybinds)

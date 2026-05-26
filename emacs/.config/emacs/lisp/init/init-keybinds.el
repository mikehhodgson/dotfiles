;; -*- lexical-binding: t; -*-

(keymap-global-set "M-n" 'scroll-up-line)
(keymap-global-set "M-p" 'scroll-down-line)

(add-hook 'Info-mode-hook
          (lambda ()
	          (keymap-set Info-mode-map "M-n" 'scroll-up-line)
	          (keymap-set Info-mode-map "M-p" 'scroll-down-line)))

(add-hook 'slime-lisp-mode-hook
          (lambda ()
	          (keymap-set slime-mode-map "M-n" 'scroll-up-line)
	          (keymap-set slime-mode-map "M-p" 'scroll-down-line)))

(add-hook 'dired-mode-hook
	        (lambda ()
	          (keymap-set dired-mode-map "<mouse-1>" 'dired-find-file)))

(add-hook 'emacs-lisp-mode-hook
	        (lambda ()
	          (keymap-global-set "C-c e" #'eval-buffer)))

(keymap-global-set "M-o" 'other-window)
(keymap-global-set "M-O" '(lambda () (interactive) (other-window -1))) ; M-S-o is regonised as M-O

;; TODO next-buffer if no tab-line
(keymap-global-set "C-<tab>" 'tab-line-switch-to-next-tab)
(keymap-global-set "C-S-<tab>" 'tab-line-switch-to-prev-tab)
(keymap-global-set "C-<iso-lefttab>" 'tab-line-switch-to-prev-tab) ; laptop registered this keypress for C-S-<tab>

(keymap-global-set "M-D" 'isearch-forward-symbol-at-point)

(with-eval-after-load 'help-mode
  (define-key help-mode-map [mouse-8] #'help-go-back)
  (define-key help-mode-map [mouse-9] #'help-go-forward))

(with-eval-after-load 'info
  (define-key Info-mode-map [mouse-8] #'Info-history-back)
  (define-key Info-mode-map [mouse-9] #'Info-history-forward))

(with-eval-after-load 'eww
  (define-key eww-mode-map [mouse-8] #'eww-back-url)
  (define-key eww-mode-map [mouse-9] #'eww-forward-url))

(provide 'init-keybinds)

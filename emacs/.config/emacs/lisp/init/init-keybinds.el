;; -*- lexical-binding: t; -*-

(keymap-global-set "M-n" 'scroll-up-line)
(keymap-global-set "M-p" 'scroll-down-line)

(keymap-global-set "M-o" 'other-window)
;; M-S-o is regonised as M-O
(keymap-global-set "M-O" '(lambda () (interactive) (other-window -1)))

(defun my/next-tab-or-buffer ()
  "Switch to the next tab if tab-line is active, otherwise next buffer."
  (interactive)
  (if (bound-and-true-p tab-line-mode)
      (tab-line-switch-to-next-tab)
    (next-buffer)))

(defun my/prev-tab-or-buffer ()
  "Switch to the previous tab if tab-line is active, otherwise previous buffer."
  (interactive)
  (if (bound-and-true-p tab-line-mode)
      (tab-line-switch-to-prev-tab)
    (previous-buffer)))

(keymap-global-set "C-<tab>" #'my/next-tab-or-buffer)
(keymap-global-set "C-S-<tab>" #'my/prev-tab-or-buffer)
;; laptop registered this keypress for C-S-<tab>
(keymap-global-set "C-<iso-lefttab>" #'my/prev-tab-or-buffer)

(keymap-global-set "M-D" 'isearch-forward-thing-at-point)

;; have found different mouse events on different machines
(defconst my/mouse-back-buttons
  '("<mouse-4>" "<mouse-8>")
  "Mouse events treated as back navigation.")

(defconst my/mouse-forward-buttons
  '("<mouse-5>" "<mouse-9>")
  "Mouse events treated as forward navigation.")

(defun my/keymap-set (keymap keys command)
  "Bind KEYS to COMMAND in KEYMAP.
KEYS may be a single key string or a list of key strings."
  (dolist (key (if (listp keys) keys (list keys)))
    (keymap-set keymap key command)))

(with-eval-after-load 'elisp-mode
  (keymap-set emacs-lisp-mode-map "C-c e" #'eval-buffer))

(with-eval-after-load 'info
  (keymap-set Info-mode-map "M-n" #'scroll-up-line)
  (keymap-set Info-mode-map "M-p" #'scroll-down-line)
  (my/keymap-set Info-mode-map my/mouse-back-buttons #'Info-history-back)
  (my/keymap-set Info-mode-map my/mouse-forward-buttons #'Info-history-forward))

(with-eval-after-load 'dired
  ;; <mouse-2> provides correct behaviour, it's an emacs thing left.
  ;; Click to navigate in same window, while long press places cursor
  ;; without navigating.
  (my/keymap-set dired-mode-map "<mouse-2>" #'dired-mouse-find-file))

(with-eval-after-load 'help-mode
  (my/keymap-set help-mode-map my/mouse-back-buttons #'help-go-back)
  (my/keymap-set help-mode-map my/mouse-forward-buttons #'help-go-forward))

(with-eval-after-load 'eww
  (my/keymap-set eww-mode-map my/mouse-back-buttons #'eww-back-url)
  (my/keymap-set eww-mode-map my/mouse-forward-buttons #'eww-forward-url))

(provide 'init-keybinds)

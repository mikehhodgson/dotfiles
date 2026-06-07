;; Minimal startup for git commit editing

;; Keep startup fast/quiet
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Basic usability
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(column-number-mode 1)
(global-font-lock-mode 1)
(visual-line-mode 1)
(global-hl-line-mode 1)
(set-face-attribute 'hl-line nil
                    :underline nil)

;; Minimal keymap
(keymap-global-set "M-n" 'scroll-up-line)
(keymap-global-set "M-p" 'scroll-down-line)
(keymap-global-set "M-o" 'other-window)
;; M-S-o is regonised as M-O
(keymap-global-set "M-O" '(lambda () (interactive) (other-window -1)))


;; Enable mouse in terminal
(xterm-mouse-mode 1)

;; External hunspell needs a dictionary installed
;; sudo pacman -S hunspell-en_au
(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'diff-mode-hook #'flyspell-mode)

;; diff-mode remaps M-DEL by default (Alt-Backspace)
(with-eval-after-load 'diff-mode
  (define-key diff-mode-map
              (kbd "M-DEL")
              #'backward-kill-word)
    (define-key diff-mode-map
              (kbd "M-o")
              #'other-window))

;;(load-theme 'modus-vivendi t)
(load-theme 'wombat t)
;;(load-theme 'tsdh-dark t)

;; Treat git commit buffers as diff
(add-to-list 'auto-mode-alist
             '("COMMIT_EDITMSG\\'" . diff-mode))

;; Fast exit
;;(global-set-key (kbd "C-x C-c")
;;                #'save-buffers-kill-terminal)

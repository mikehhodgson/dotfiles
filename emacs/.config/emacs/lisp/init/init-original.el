;; -*- lexical-binding: t; -*-

;; Dired
(setq dired-kill-when-opening-new-dired-buffer t)

;; Project mode-line
(setq project-mode-line t)

;; Dashboard
(setq dashboard-items
      '((projects . 10)
        (recents . 5)
        (bookmarks . 5)
        (agenda . 5)))

(setq dashboard-projects-backend 'project-el)

(setq js-indent-level 2)

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

;; (defun zen ()
;;   (interactive)
;;   (let* ((margins (window-margins))
;;          (left (or (car margins) 0))
;;          (right (or (cdr margins) 0)))
;;     (if (and (= left 0) (= right 0))
;;         ;; Turn ON centering
;;         (let* ((total-width (window-total-width))
;;                (text-width 80)
;;                (margin (max 0 (/ (- total-width text-width) 2))))
;;           (set-window-margins (selected-window) margin margin))
;;       ;; Turn OFF centering
;;       (set-window-margins (selected-window) 0 0))))

;; (defun zen-on-resize ()
;;   (let* ((margins (window-margins))
;;          (left (or (car margins) 0))
;;          (right (or (cdr margins) 0)))
;;     (if (not (and (= left 0) (= right 0))) (zen))))

;; (add-hook 'window-size-change-functions #'zen-on-resize)

;; https://stackoverflow.com/a/18330742
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

(use-package slime)
(use-package visual-fill-column)
(use-package writeroom-mode)

;; After installation, simply use M-x minimap-mode to toggle
;; activation of the minimap. Use 'M-x customize-group RET minimap
;; RET' to adapt minimap to your needs.
(use-package minimap)
;; Minimap
(setq minimap-hide-fringes t
      minimap-major-modes '(prog-mode text-mode Info-mode)
      minimap-minimum-width 10
      minimap-width-fraction 0.05
      minimap-window-location 'right
      minimap-recreate-window t)

;; hide fringe indicators - doesn't work either?
;; https://stackoverflow.com/a/61417854
(define-advice minimap-new-minimap (:after () hide-truncation-indicators)
  "Hide truncation fringe indicators in the minimap buffer."
  (with-current-buffer minimap-buffer-name
    (push '(truncation nil nil) ;; no truncation indicators
          ;; '(truncation nil right-arrow) ;; right indicator only
          ;; '(truncation left-arrow nil) ;; left indicator only
          ;; '(truncation left-arrow right-arrow) ;; default
          fringe-indicator-alist)))

(defun my-enable-minimap-if-gui (frame)
  (when (display-graphic-p frame)
    (with-selected-frame frame
      (minimap-mode 1))))

;; run for initial frame
(my-enable-minimap-if-gui (selected-frame))

;; run for any new frames (important for daemon / emacsclient)
(add-hook 'after-make-frame-functions #'my-enable-minimap-if-gui)

;; explicity disable minimap in terminal
(unless (display-graphic-p)
  (minimap-mode -1))

(defun my-minimap-refresh-on-resize (_frame)
  (when (and (bound-and-true-p minimap-mode)
             (display-graphic-p))
    (minimap-update)))

(add-hook 'window-size-change-functions #'my-minimap-refresh-on-resize)

;; defaults to ChatGPT, using ~/.authinfo
(use-package gptel)

(setq my-llama
      (gptel-make-ollama "Llama"
        :host "localhost:11434"
	      :stream t
        :models '(llama3)))

(setq my-gemma
      (gptel-make-ollama "Gemma"
        :host "localhost:11434"
	      :stream t
        :models '(gemma:7b)))

;; OPTIONAL configuration
;; (setq gptel-model 'mistral:latest
;;       gptel-backend my-llama)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-projects-backend 'project-el))

;; https://company-mode.github.io/
;;(use-package company)
;;(add-hook 'after-init-hook 'global-company-mode)
;;(keymap-global-set "C-;" 'company-complete)
(use-package company
  :hook (after-init . global-company-mode)
  :bind ("C-;" . company-complete))

(with-eval-after-load 'help-mode
  (define-key help-mode-map [mouse-8] #'help-go-back)
  (define-key help-mode-map [mouse-9] #'help-go-forward))

(with-eval-after-load 'info
  (define-key Info-mode-map [mouse-8] #'Info-history-back)
  (define-key Info-mode-map [mouse-9] #'Info-history-forward))

(with-eval-after-load 'eww
  (define-key eww-mode-map [mouse-8] #'eww-back-url)
  (define-key eww-mode-map [mouse-9] #'eww-forward-url))

(provide 'init-original)

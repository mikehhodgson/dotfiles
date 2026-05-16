;; -*- lexical-binding: t -*-

(global-visual-line-mode)
(setq markdown-header-scaling t)

;; font height any smaller and the welcome screen changes to fixed-pitch
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-enabled-themes '(modus-vivendi))
 '(dashboard-items
   '((projects . 10) (recents . 5) (bookmarks . 5) (agenda . 5)))
 '(dashboard-projects-backend 'project-el)
 '(dired-kill-when-opening-new-dired-buffer t)
 '(display-line-numbers-type 'absolute)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(minimap-hide-fringes t)
 '(minimap-major-modes '(prog-mode text-mode Info-mode))
 '(minimap-minimum-width 10)
 '(minimap-width-fraction 0.05)
 '(minimap-window-location 'right)
 '(package-selected-packages nil)
 '(project-mode-line t)
 '(standard-indent 2)
 '(tool-bar-mode nil)
 '(vc-handled-backends '(Git)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack Nerd Font Mono" :foundry "SRC" :slant normal :weight regular :height 113 :width normal))))
 '(fixed-pitch ((t (:family "Hack Nerd Font Mono"))))
 '(variable-pitch ((t (:family "Arial")))))

;; '(show-trailing-whitespace t)

(add-hook 'markdown-mode-hook #'variable-pitch-mode)

(with-eval-after-load 'markdown-mode
  (set-face-attribute 'markdown-header-face-1 nil :height 1.8)
  (set-face-attribute 'markdown-header-face-2 nil :height 1.6)
  (set-face-attribute 'markdown-header-face-3 nil :height 1.4)
  (set-face-attribute 'markdown-header-face-4 nil :height 1.2)
  (set-face-attribute 'markdown-header-face-5 nil :height 1.1)
  (set-face-attribute 'markdown-header-face-6 nil :height 1.0))

;; (add-hook 'js-json-mode-hook
;;           (lambda ()
;;             (setq-local js-indent-level 2)))

(setq js-indent-level 2)

(defun my/global-settings ()
  (global-tab-line-mode t)
  (global-hl-line-mode t) ; highlight the whole cursor line
  (setq tab-always-indent 'complete) ; tab indents then autocompletes
  ;;  (setq display-line-numbers-type 'absolute)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode) ;; Line numbers for all programming modes 
  ;;(global-display-line-numbers-mode)

  (recentf-mode t) ; remember and open recent files with M-x recentf
  (save-place-mode t) ; remember cursor location for previously opened files

  (setq global-auto-revert-non-file-buffers t)
  (global-auto-revert-mode t)
  )

(my/global-settings)

(defun my/keymap ()
  (keymap-global-set "M-n" 'scroll-up-line)
  (keymap-global-set "M-p" 'scroll-down-line)

  (add-hook 'Info-mode-hook
            (lambda ()
	      (keymap-set Info-mode-map "M-n" 'scroll-up-line)
	      (keymap-set Info-mode-map "M-p" 'scroll-down-line)))

  (add-hook 'markdown-mode-hook
            (lambda ()
	      (keymap-set markdown-mode-map "M-n" 'scroll-up-line)
	      (keymap-set markdown-mode-map "M-p" 'scroll-down-line)))

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
  )

(my/keymap)

;; minimap setup

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

;; (defun my/transpose ()
;;   (interactive)
;;   (if (region-active-p)
;;       (transpose-regions)
;;     (transpose-lines 0)))
;; (keymap-global-set "M-<down>" 'my/transpose)

;; enable mouse in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(defun zen ()
  (interactive)
  (let* ((margins (window-margins))
         (left (or (car margins) 0))
         (right (or (cdr margins) 0)))
    (if (and (= left 0) (= right 0))
        ;; Turn ON centering
        (let* ((total-width (window-total-width))
               (text-width 80)
               (margin (max 0 (/ (- total-width text-width) 2))))
          (set-window-margins (selected-window) margin margin))
      ;; Turn OFF centering
      (set-window-margins (selected-window) 0 0))))

(defun zen-on-resize ()
   (let* ((margins (window-margins))
         (left (or (car margins) 0))
         (right (or (cdr margins) 0)))
  (if (not (and (= left 0) (= right 0))) (zen))))

(add-hook 'window-size-change-functions #'zen-on-resize)

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

(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package slime)

(use-package magit)

;; After installation, simply use M-x minimap-mode to toggle
;; activation of the minimap. Use 'M-x customize-group RET minimap
;; RET' to adapt minimap to your needs.
(use-package minimap)
(setq minimap-recreate-window t)

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

;; gutter diff highlights
(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (vc-dir-mode . diff-hl-dir-mode))
  :config
  (diff-hl-flydiff-mode) ;; live updates as you type
)

;;(add-hook 'emacs-startup-hook
;;	  (lambda () (delete-other-windows)) t)

(use-package markdown-mode)
 ;; markdown-mode code block syntax highlighting
(setq markdown-fontify-code-blocks-natively t)

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

;; https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html
;;(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;;(add-hook 'c-mode-hook 'eglot-ensure)
;;(add-hook 'c++-mode-hook 'eglot-ensure)
(use-package eglot
  :ensure t
  :hook ((c++-mode . eglot-ensure)
         (c-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"))))

;; https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)
    (treemacs-resize-icons 16)

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

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("C-M-z"     . treemacs)
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(with-eval-after-load 'treemacs
   (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
;;   (treemacs-follow-mode)
   ;;   (treemacs-git-mode)
   ;; (treemacs-git-commit-diff-mode)
   )

(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

;; https://github.com/emacsfodder/move-text#indent-after-moving
(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(defun my/duplicate-below ()
  "Duplicate region or line downward."
  (interactive)
  (if (use-region-p)
      ;; Region case
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (buffer-substring beg end))
             (len (- end beg)))
        (goto-char end)
        (insert text)

        ;; Reselect lower copy
        (setq deactivate-mark nil)
        (set-mark end)
        (goto-char (+ end len))
        (activate-mark))
    ;; Line case
    (let ((col (current-column)))
      (save-excursion
        (let ((line (buffer-substring
                     (line-beginning-position)
                     (line-beginning-position 2))))
          (goto-char (line-beginning-position 2))
          (insert line)))
      (forward-line 1)
      (move-to-column col))))

(defun my/duplicate-above ()
  "Duplicate region or line upward."
  (interactive)
  (if (use-region-p)
      ;; Region case
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (buffer-substring beg end))
             (len (- end beg)))
        (goto-char beg)
        (insert text)

        ;; Reselect upper copy
        (setq deactivate-mark nil)
        (set-mark beg)
        (goto-char (+ beg len))
        (activate-mark))
    ;; Line case
    (let ((col (current-column)))
      (save-excursion
        (beginning-of-line)
        (let ((line (buffer-substring
                     (line-beginning-position)
                     (line-beginning-position 2))))
          (insert line)))
      (move-to-column col))))

(global-set-key (kbd "M-S-<down>") #'my/duplicate-below)
(global-set-key (kbd "M-S-<up>")   #'my/duplicate-above)

(with-eval-after-load 'help-mode
  (define-key help-mode-map [mouse-8] #'help-go-back)
  (define-key help-mode-map [mouse-9] #'help-go-forward))

(with-eval-after-load 'info
  (define-key Info-mode-map [mouse-8] #'Info-history-back)
  (define-key Info-mode-map [mouse-9] #'Info-history-forward))

(with-eval-after-load 'eww
  (define-key eww-mode-map [mouse-8] #'eww-back-url)
  (define-key eww-mode-map [mouse-9] #'eww-forward-url))


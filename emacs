(add-to-list 'custom-theme-load-path "~/.elisp")

;; gui and terminal specifics
(if (display-graphic-p)
    (progn
      ;; if graphical
;;      (custom-set-variables
;;       '(custom-enabled-themes (quote (evenhold)))
       ;; toolbar not required
;;       '(tool-bar-mode nil))
      )
    ;; else
    ;; only show menu in gui mode
    (progn
      (menu-bar-mode -1)
      ;;(load-theme 'evenhold t)
      ))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (evenhold)))
 '(custom-safe-themes
   (quote
    ("4486c1c29f022216ce050ababe284c05bcb24096a280f0615e28d27c31f31b24" default)))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/notes.org")))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))

;; whitespace
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default show-trailing-whitespace t)

(defun hide-trailing-whitespace ()
  "Sets show-trailing-whitespace to nil"
  (setq show-trailing-whitespace nil))

(mapc
 (lambda (emacs-mode-hook)
   (add-hook emacs-mode-hook 'hide-trailing-whitespace))
 '(buffer-menu-mode-hook
   info-mode-hook
   help-mode-hook
   eww-mode-hook))


;; highlight selected region
(transient-mark-mode 1)

;; quiet!
(setq initial-scratch-message "")
(setq inhibit-startup-message t)

;; http://yann.hodique.info/blog/rant-obfuscation-in-emacs/
;; portable way to disable that silly message
(put 'inhibit-startup-echo-area-message 'saved-value
     (setq inhibit-startup-echo-area-message (user-login-name)))
(setq inhibit-startup-screen t)

;; show matching parenthesis
(show-paren-mode 1)

;;(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-notes-file "~/notes.org")
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

;; additional modes and file extensions
(add-to-list 'load-path "~/.elisp")
;;(require 'php-mode)
;;(require 'visual-basic-mode)

(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic mode." t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\|vbs\\)$" .
                                visual-basic-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\(\\.emacs\\|emacs\\)$" .
                                 emacs-lisp-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\(\\.pac\\)$" .
                                 javascript-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\(\\.pyw\\)$" .
                                 python-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\(Vagrantfile\\)$" .
                                 ruby-mode)) auto-mode-alist))
(autoload 'powershell-mode "powershell-mode" "Powershell mode." t)
(setq auto-mode-alist (append '(("\\(\\.ps1\\)$" .
                                powershell-mode)) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

(autoload 'dos-mode "dos" "Windows Batch File mode." t)
(setq auto-mode-alist (append '(("\\(\\.bat\\)$" .
                                 dos-mode)) auto-mode-alist))

(autoload 'php-mode "php-mode" "PHP mode." t)
(setq auto-mode-alist (append '(("\\(\\.php\\)$" .
                                 php-mode)) auto-mode-alist))

(autoload 'graphviz-dot-mode "graphviz-dot-mode" "Graphviz dot mode." t)
(setq auto-mode-alist (append '(("\\(\\.dot\\|\\.gv\\)$" .
                                 graphviz-dot-mode)) auto-mode-alist))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist (append '(("\\(\\.md\\|\\.markdown\\)$" .
                                 markdown-mode)) auto-mode-alist))

(autoload 'puppet-mode "puppet-mode" "Puppet mode." t)
(setq auto-mode-alist (append '(("\\(\\.pp\\)$" .
                                 puppet-mode)) auto-mode-alist))

;; http://www.emacswiki.org/emacs/BackupDirectory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; easy spell check
;; http://www.emacswiki.org/emacs/FlySpell
;;(global-set-key (kbd "<f8>") 'ispell-word)
;;(global-set-key (kbd "<f8>") 'flyspell-mode)
(global-set-key (kbd "<f8>") 'flyspell-buffer)
;;(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
;;(defun flyspell-check-next-highlighted-word ()
;;  "Custom function to spell check next highlighted word"
;;  (interactive)
;;  (flyspell-goto-next-error)
;;  (ispell-word)
;;  )
;;(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)

;; scroll buffer by line
;; http://stackoverflow.com/a/16229080
(global-set-key "\M-n" 'scroll-up-line)
(global-set-key "\M-p" 'scroll-down-line)

;; http://emacs-fu.blogspot.co.uk/2009/02/transparent-emacs.html
(defun djcb-opacity-modify (&optional dec)
    "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
    (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
           (oldalpha (if alpha-or-nil alpha-or-nil 100))
           (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
      (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
        (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

;; C-8 will increase opacity (== decrease transparency)
;; C-9 will decrease opacity (== increase transparency
;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

;; uni c++
;; http://emacswiki.org/emacs/IndentingC
;; http://en.wikipedia.org/wiki/Indent_style
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq-default c-basic-offset 3 c-default-style "Stroustrup")
(put 'downcase-region 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

;; allow number pad enter in addition to return key
;; useful for M-enter when making a list of numbers
(add-hook 'org-mode-hook
          (lambda ()
            (org-defkey org-mode-map [M-enter] 'org-meta-return)))

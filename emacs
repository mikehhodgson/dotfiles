
;; quiet!
(setq inhibit-startup-screen t
      initial-scratch-message ""
      inhibit-startup-message t)

;; http://yann.hodique.info/blog/rant-obfuscation-in-emacs/
;; portable way to disable that silly message
(put 'inhibit-startup-echo-area-message 'saved-value
     (setq inhibit-startup-echo-area-message (user-login-name)))
(setq inhibit-startup-screen t)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(show-paren-mode)
(defalias 'yes-or-no-p 'y-or-n-p)

(setq column-number-mode t
      size-indication-mode t
      require-final-newline nil
      mode-require-final-newline nil
      transient-mark-mode t ;; highlight selected region
      )

(global-set-key (kbd "M-o") 'other-window)

(add-to-list 'custom-theme-load-path "~/.elisp")
(load-theme 'cyberpunk t)

;; whitespace
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default show-trailing-whitespace t)

(defun hide-trailing-whitespace ()
  "Sets show-trailing-whitespace to nil"
  (interactive)
  (setq show-trailing-whitespace nil))

(defun show-trailing-whitespace ()
  "Sets show-trailing-whitespace to t"
  (interactive)
  (setq show-trailing-whitespace t))

(mapc
 (lambda (emacs-mode-hook)
   (add-hook emacs-mode-hook 'hide-trailing-whitespace))
 '(buffer-menu-mode-hook
   info-mode-hook
   help-mode-hook
   eww-mode-hook))

;;(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-notes-file "~/notes.org"
      org-agenda-files '("~/notes.org"))
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

;; additional modes and file extensions
(add-to-list 'load-path "~/.elisp")

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

(autoload 'draft-mode "draft-mode" "Draft mode." t)
(autoload 'writeroom-mode "writeroom-mode" "Writeroom mode." t)

;; http://www.emacswiki.org/emacs/BackupDirectory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)

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

;; had trouble with the lua-mode lua-electric-match
(add-hook 'lua-mode-hook (lambda () (local-set-key ")" 'self-insert-command)))

;; active Bable languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (calc . t)
   (ditaa . t)
   (python . t)
   )) ; this line activates ditaa
(setq org-export-allow-BIND t)

;; emacs gui on osx does not receive the same exec path as when run
;; from terminal
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell
      (replace-regexp-in-string "[[:space:]\n]*$" ""
        (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))

    ;; exec-path help notes that this should be the last item
    (add-to-list 'exec-path exec-directory t)))
(when (equal system-type 'darwin) (set-exec-path-from-shell-PATH))

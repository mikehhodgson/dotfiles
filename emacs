(custom-set-variables
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59"
    "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(column-number-mode t)
 '(desktop-save t)
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/notes.org")))
 '(size-indication-mode t))
(custom-set-faces
 '(default ((t (:family "Inconsolata-dz" :foundry "outline" :slant normal
                        :weight normal :height 98 :width normal)))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(transient-mark-mode 1)

(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message "mike")

;; only show menu in gui mode
(if (display-graphic-p)
    (progn
      ;; if graphical
      (custom-set-variables
       '(custom-enabled-themes (quote (tsdh-dark)))
       '(tool-bar-mode nil)))
  ;; else
  (menu-bar-mode -1))

;;(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-notes-file "~/notes.org")
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)

;; additional modes and file extensions
(add-to-list 'load-path "~/.elisp")
(require 'php-mode)
(require 'visual-basic-mode)

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

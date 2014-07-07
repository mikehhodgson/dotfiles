(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(desktop-save t)
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/notes.org")))
 '(size-indication-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata-dz" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

(add-to-list 'load-path "~/.elisp")
(require 'php-mode)
(require 'visual-basic-mode)

;;(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-default-notes-file "~/notes.org")

     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cb" 'org-iswitchb)


(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


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

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;; http://www.emacswiki.org/emacs/BackupDirectory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; this one's for osx
(setq inhibit-startup-message t)

(transient-mark-mode 1)

(menu-bar-mode -1)


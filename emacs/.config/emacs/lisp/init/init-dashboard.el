;; -*- lexical-binding: t; -*-

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-items
        '((projects . 5)
          (recents . 20)
          (bookmarks . 5)
          (agenda . 5)))

  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (setq dashboard-set-file-icons t)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t))

;; remember and open recent files with M-x recentf
(use-package recentf
  :hook (after-init . recentf-mode)
  ;; https://www.polyomica.com/weekly-emacs-tip-26-recentf-keep-track-of-recently-edited-files/
  :config
  (dolist (itm '("^/ssh:"
                 "^/sudo:"
                 "~/.config/emacs/.cache/*"
                 "~/.config/emacs/places"
                 "~/.config/emacs/projects"
                 "~/.config/emacs/recentf"
                 "~/.config/emacs/tramp"
                 "recentf$"))
    (add-to-list 'recentf-exclude itm))
  (add-to-list 'recentf-keep 'file-remote-p))

(provide 'init-dashboard)

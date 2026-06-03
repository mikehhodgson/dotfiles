;; -*- lexical-binding: t; -*-

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-items
        '((projects . 5)
          (recents . 10)
          (bookmarks . 5)
          (agenda . 5)))

  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (setq dashboard-set-file-icons t)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t))

(provide 'init-dashboard)

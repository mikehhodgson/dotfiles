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
        (agenda . 5))))

(provide 'init-dashboard)

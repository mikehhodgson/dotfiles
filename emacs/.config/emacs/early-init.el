;; -*- lexical-binding: t; -*-

(menu-bar-mode 1)
(scroll-bar-mode 1)
(tool-bar-mode -1)

(setq inhibit-startup-screen t)

;; Prevent Emacs from automatically enabling packages at startup.
;; We initialize packages manually in init-packages.el.
(setq package-enable-at-startup nil)

;; Prevent white flash on startup
(setq default-frame-alist
      '((background-color . "#000000")
        (foreground-color . "#ffffff")))

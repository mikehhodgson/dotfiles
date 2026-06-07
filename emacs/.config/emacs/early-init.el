;; -*- lexical-binding: t; -*-

;; https://news.ycombinator.com/item?id=31398738
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

;; https://news.ycombinator.com/item?id=31399060
;; I like to do this to ensure GC happens occasionally, when I focus
;; away from Emacs:
(add-function :after after-focus-change-function
              (lambda () (unless (frame-focus-state)
                           (garbage-collect))))

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

;; Prevent bright default mode-line before theme loads
(set-face-attribute 'mode-line nil
                    :background "#222222"
                    :foreground "#cccccc"
                    :box nil)

(set-face-attribute 'mode-line-inactive nil
                    :background "#000000"
                    :foreground "#666666"
                    :box nil)

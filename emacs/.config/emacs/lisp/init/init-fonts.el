;; -*- lexical-binding: t; -*-

(let ((mono "Hack Nerd Font Mono")
      (proportional "Liberation Sans"))
  (if (eq system-type 'windows-nt)
      (set-face-attribute 'default nil :family mono :height 98 :antialias natural)
    (set-face-attribute 'default nil :family mono :height 113))
  (set-face-attribute 'fixed-pitch nil :family mono :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportional :height 1.1))

(provide 'init-fonts)

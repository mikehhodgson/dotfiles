;; -*- lexical-binding: t; -*-

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi :no-confirm-loading))

;; Don't show tab line until theme is set
(global-tab-line-mode t)
(setq tab-line-new-button-show nil)
(setq tab-line-close-button-show nil)
(setq tab-line-separator " ")

(set-face-attribute 'tab-line nil
                    :family "Nasalization"
                    :height 1.1)
(set-face-attribute 'tab-line-tab-modified nil
                    :foreground "#E4002B")

 (provide 'theme)

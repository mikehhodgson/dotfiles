;; -*- lexical-binding: t; -*-

;; https://company-mode.github.io/
(use-package company
  :hook (after-init . global-company-mode)
  :bind ("C-;" . company-complete)
  :config
  (setq company-dabbrev-downcase nil))


(provide 'init-completion)


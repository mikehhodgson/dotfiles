;; -*- lexical-binding: t; -*-

;; https://company-mode.github.io/
(use-package company
  :hook (after-init . global-company-mode)
  :bind ("C-;" . company-complete))

(provide 'init-completion)


;; -*- lexical-binding: t; -*-

;; https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html
;;(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;;(add-hook 'c-mode-hook 'eglot-ensure)
;;(add-hook 'c++-mode-hook 'eglot-ensure)
(use-package eglot
  :ensure t
  :hook ((c++-mode . eglot-ensure)
         (c-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"))))

;; Eglot
(add-hook 'js-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)

(provide 'init-lsp)

;; -*- lexical-binding: t; -*-

;; https://www.gnu.org/software/emacs/manual/html_node/eglot/Quick-Start.html
(use-package eglot
  :ensure t
  :hook ((c++-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"))
               '((python-mode) . ("pylsp")))) ; sudo pacman -S python-lsp-server

(provide 'init-lsp)

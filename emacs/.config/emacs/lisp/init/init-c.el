;;; init-c.el --- C language configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; C-specific editing and language-server configuration.
;;
;; Clangd advertises LSP on-type formatting for newline characters.
;; When Eglot applies those formatting edits after Electric Pair mode
;; splits a pair of braces, point moves from the indented blank line to
;; the closing brace. Ignore that capability in `c-mode' buffers only.
;;
;; Explicit formatting commands such as `eglot-format' and
;; `eglot-format-buffer' remain available.

;;; Code:

(defun my/c-eglot-disable-on-type-formatting ()
  "Disable Eglot on-type formatting in `c-mode' buffers."
  (when (eq major-mode 'c-mode)
    (setq-local eglot-ignored-server-capabilities
                (cons :documentOnTypeFormattingProvider
                      (delq :documentOnTypeFormattingProvider
                            (copy-sequence
                             eglot-ignored-server-capabilities))))))

(add-hook 'eglot-managed-mode-hook
          #'my/c-eglot-disable-on-type-formatting)

(provide 'init-c)

;;; init-c.el ends here

;; -*- lexical-binding: t; -*-

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-hide-markup nil
        markdown-gfm-uppercase-checkbox t
        ;; markdown-mode code block syntax highlighting  
        markdown-fontify-code-blocks-natively t))

(setq markdown-header-scaling t)

(add-hook 'markdown-mode-hook #'variable-pitch-mode)
(add-hook 'markdown-mode-hook #'visual-fill-column-mode)

;; Keep code/table regions fixed-pitch
(setq-local face-remapping-alist
            '((markdown-code-face fixed-pitch)
              (markdown-inline-code-face fixed-pitch)
              (markdown-pre-face fixed-pitch)
              (markdown-table-face fixed-pitch)
              (markdown-language-keyword-face fixed-pitch)))

(with-eval-after-load 'markdown-mode
  (set-face-attribute 'markdown-header-face-1 nil :height 1.8 :family "Nasalization")
  (set-face-attribute 'markdown-header-face-2 nil :height 1.6 :family "Nasalization")
  (set-face-attribute 'markdown-header-face-3 nil :height 1.4 :family "Nasalization")
  (set-face-attribute 'markdown-header-face-4 nil :height 1.2 :family "Nasalization")
  (set-face-attribute 'markdown-header-face-5 nil :height 1.1 :family "Nasalization")
  (set-face-attribute 'markdown-header-face-6 nil :height 1.0 :family "Nasalization")

  (set-face-attribute 'markdown-code-face        nil :inherit 'fixed-pitch)
  (set-face-attribute 'markdown-inline-code-face nil :inherit 'fixed-pitch)
  (set-face-attribute 'markdown-pre-face         nil :inherit 'fixed-pitch)
  (set-face-attribute 'markdown-table-face       nil :inherit 'fixed-pitch))

(add-hook 'markdown-mode-hook
          (lambda ()
	          (keymap-set markdown-mode-map "M-n" 'scroll-up-line)
	          (keymap-set markdown-mode-map "M-p" 'scroll-down-line)))

(provide 'init-markdown)

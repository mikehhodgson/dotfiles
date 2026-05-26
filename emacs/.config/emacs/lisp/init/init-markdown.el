;; -*- lexical-binding: t; -*-

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-hide-markup nil
        markdown-gfm-uppercase-checkbox t
        markdown-header-scaling t
        ;; markdown-mode code block syntax highlighting
        markdown-fontify-code-blocks-natively t)
  :hook ((markdown-mode . variable-pitch-mode)
         (markdown-mode . visual-fill-column-mode)
         (markdown-mode . (lambda ()
                            "Keep Markdown code and table regions fixed-pitch."
                            (dolist (face '(markdown-code-face
                                            markdown-inline-code-face
                                            markdown-pre-face
                                            markdown-table-face
                                            markdown-language-keyword-face))
                              (face-remap-add-relative face 'fixed-pitch))))
         (markdown-mode . (lambda ()
                            (keymap-set markdown-mode-map "M-n" #'scroll-up-line)
                            (keymap-set markdown-mode-map "M-p" #'scroll-down-line))))
  :config
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

(provide 'init-markdown)

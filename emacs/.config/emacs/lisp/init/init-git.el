;; -*- lexical-binding: t; -*-

(use-package magit
  :ensure t
  :defer t)

;; gutter diff highlights
(use-package diff-hl
  :ensure t
  ;;  :hook ((prog-mode . diff-hl-mode)
  ;;         (vc-dir-mode . diff-hl-dir-mode))
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode) ;; live updates as you type
  (diff-hl-show-hunk-mouse-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(provide 'init-git)

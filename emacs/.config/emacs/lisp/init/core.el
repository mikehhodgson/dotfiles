;; -*- lexical-binding: t; -*-

;; Use only Git for VC
(setq vc-handled-backends '(Git))

;; Default indentation
(setq-default standard-indent 2)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; tab indents then autocompletes
(setq tab-always-indent 'complete)

;; VC follows the link and visits the real file, telling you about it
;; in the echo area.
(setq vc-follow-symlinks t)

;; remember and open recent files with M-x recentf
(recentf-mode t)

;; remember cursor location for previously opened files
(save-place-mode t)

(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode t)

(provide 'core)

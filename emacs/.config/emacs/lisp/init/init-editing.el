;; -*- lexical-binding: t; -*-

(use-package visual-fill-column)
(use-package writeroom-mode)

(add-hook 'text-mode-hook #'flyspell-mode)

(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings))

;; https://github.com/emacsfodder/move-text#indent-after-moving
(defun indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'indent-region-advice)
(advice-add 'move-text-down :after 'indent-region-advice)

(defun my/duplicate-below ()
  "Duplicate region or line downward."
  (interactive)
  (if (use-region-p)
      ;; Region case
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (buffer-substring beg end))
             (len (- end beg)))
        (goto-char end)
        (insert text)

        ;; Reselect lower copy
        (setq deactivate-mark nil)
        (set-mark end)
        (goto-char (+ end len))
        (activate-mark))
    ;; Line case
    (let ((col (current-column)))
      (save-excursion
        (let ((line (buffer-substring
                     (line-beginning-position)
                     (line-beginning-position 2))))
          (goto-char (line-beginning-position 2))
          (insert line)))
      (forward-line 1)
      (move-to-column col))))

(defun my/duplicate-above ()
  "Duplicate region or line upward."
  (interactive)
  (if (use-region-p)
      ;; Region case
      (let* ((beg (region-beginning))
             (end (region-end))
             (text (buffer-substring beg end))
             (len (- end beg)))
        (goto-char beg)
        (insert text)

        ;; Reselect upper copy
        (setq deactivate-mark nil)
        (set-mark beg)
        (goto-char (+ beg len))
        (activate-mark))
    ;; Line case
    (let ((col (current-column)))
      (save-excursion
        (beginning-of-line)
        (let ((line (buffer-substring
                     (line-beginning-position)
                     (line-beginning-position 2))))
          (insert line)))
      (move-to-column col))))

(global-set-key (kbd "M-S-<down>") #'my/duplicate-below)
(global-set-key (kbd "M-S-<up>")   #'my/duplicate-above)

(use-package expand-region
  :ensure t
  :bind ("M-S" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :bind ("M-D" . mc/mark-next-like-this-word))

;; TODO run mc/mark-next-like-this if already a selection?
;;(global-set-key (kbd "M-D") 'mc/mark-all-dwim) ; do what I mean
;;(global-set-key (kbd "M-D") 'mc/mark-next-like-this-word)

;; (Global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
;; (global-set-key (kbd "M-D") 'mc/mark-next-like-this)n
;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; formerly
;;(keymap-global-set "M-D" 'isearch-forward-thing-at-point)

(provide 'init-editing)

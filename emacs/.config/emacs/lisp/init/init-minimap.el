;; -*- lexical-binding: t;-*-

;; After installation, simply use M-x minimap-mode to toggle
;; activation of the minimap. Use 'M-x customize-group RET minimap
;; RET' to adapt minimap to your needs.
(use-package minimap)
;; Minimap
(setq minimap-hide-fringes t
      minimap-major-modes '(prog-mode text-mode Info-mode)
      minimap-minimum-width 10
      minimap-width-fraction 0.05
      minimap-window-location 'right
      minimap-recreate-window t)

;; hide fringe indicators - doesn't work either?
;; https://stackoverflow.com/a/61417854
(define-advice minimap-new-minimap (:after () hide-truncation-indicators)
  "Hide truncation fringe indicators in the minimap buffer."
  (with-current-buffer minimap-buffer-name
    (push '(truncation nil nil) ;; no truncation indicators
          ;; '(truncation nil right-arrow) ;; right indicator only
          ;; '(truncation left-arrow nil) ;; left indicator only
          ;; '(truncation left-arrow right-arrow) ;; default
          fringe-indicator-alist)))

(defun my-enable-minimap-if-gui (frame)
  (when (display-graphic-p frame)
    (with-selected-frame frame
      (minimap-mode 1))))

;; run for initial frame
(my-enable-minimap-if-gui (selected-frame))

;; run for any new frames (important for daemon / emacsclient)
(add-hook 'after-make-frame-functions #'my-enable-minimap-if-gui)

;; explicity disable minimap in terminal
(unless (display-graphic-p)
  (minimap-mode -1))

(defun my-minimap-refresh-on-resize (_frame)
  (when (and (bound-and-true-p minimap-mode)
             (display-graphic-p))
    (minimap-update)))

(add-hook 'window-size-change-functions #'my-minimap-refresh-on-resize)

(provide 'init-minimap)

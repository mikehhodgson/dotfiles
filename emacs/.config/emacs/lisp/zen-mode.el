;; -*- lexical-binding: t; -*-

(defun zen ()
  (interactive)
  (let* ((margins (window-margins))
         (left (or (car margins) 0))
         (right (or (cdr margins) 0)))
    (if (and (= left 0) (= right 0))
        ;; Turn ON centering
        (let* ((total-width (window-total-width))
               (text-width 80)
               (margin (max 0 (/ (- total-width text-width) 2))))
          (set-window-margins (selected-window) margin margin))
      ;; Turn OFF centering
      (set-window-margins (selected-window) 0 0))))

(defun zen-on-resize ()
  (let* ((margins (window-margins))
         (left (or (car margins) 0))
         (right (or (cdr margins) 0)))
    (if (not (and (= left 0) (= right 0))) (zen))))

(add-hook 'window-size-change-functions #'zen-on-resize)

(provide 'zen-mode)

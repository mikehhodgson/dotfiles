(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)

(package-initialize)

(require 'use-package)

(setq use-package-always-ensure t)

;; Emacs will show a buffer that contains any byte compiler warnings
;; from installing a new package. This will prevent those from
;; showing. They are still available in the buffer list.
(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(provide 'init-packages)

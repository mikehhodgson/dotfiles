(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/")
             t)

(package-initialize)

(require 'use-package)

(setq use-package-always-ensure t)

(provide 'packages)

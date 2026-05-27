;;; init-dev.el --- dev tools
;; -*- lexical-binding: t; -*-

;;; Commentary:
;; Provides general dev tools, mostly web dev.
;;
;; Initial setup:
;;
;; npm install -g typescript typescript-language-server
;;
;; For Tree-sitter language install on Windows:
;; winget install --id=MSYS2.MSYS2 -e
;;
;; Then in MSYS2 UCRT64
;; pacman -S --needed git mingw-w64-ucrt-x86_64-gcc
;;
;; Then in Emacs:
;; (my/install-treesit-languages)

;;; Code:

(setq js-indent-level 2)

(use-package slime
  :bind (:map slime-mode-map
              ("M-n" . scroll-up-line)
              ("M-p" . scroll-down-line)))

;; Emacs needs the shell path to find the typescript-language-server install
(use-package exec-path-from-shell
  ;; Windows already inherits the system path as required
  :if (not (eq system-type 'windows-nt))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Tree-sitter modes
(setq major-mode-remap-alist
 '((javascript-mode . js-ts-mode)
   (js-mode . js-ts-mode)
   (typescript-mode . tsx-ts-mode)
   (tsx-mode . tsx-ts-mode)))

;; Mouse support
(setq xref-search-program 'ripgrep)

;; Ctrl+click
(keymap-set prog-mode-map "C-<down-mouse-1>" #'ignore)
(keymap-set prog-mode-map "C-<mouse-1>" #'xref-find-definitions-at-mouse)

;; Manual treesit grammer installer
(setq treesit-language-source-alist
      '((javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (json . ("https://github.com/tree-sitter/tree-sitter-json"))
        (css . ("https://github.com/tree-sitter/tree-sitter-css"))
        (html . ("https://github.com/tree-sitter/tree-sitter-html"))
        (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))))

;; Run once to install everything
(defun my/install-treesit-languages ()
  (interactive)
  (mapc
   (lambda (lang)
     (unless (treesit-language-available-p lang)
       (treesit-install-language-grammar lang)))
   '(javascript typescript tsx json css html bash)))

(provide 'init-dev)

;;; init-dev.el ends here

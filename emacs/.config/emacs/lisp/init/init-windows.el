;;; init-windows.el --- Windows-specific configuration -*- lexical-binding: t; -*-

;;; Commentary:

;; Prefer native GPG over Git-for-Windows GPG.
;;
;; First-time setup:
;;
;;   winget install --id=GnuPG.Gpg4win -e
;;
;; This file will automatically import the required
;; package signing key if it is missing.

;;; Code:

(let ((gpg-path "C:/Program Files/GnuPG/bin"))

  (setenv
   "PATH"
   (concat gpg-path ";" (getenv "PATH")))

  (add-to-list 'exec-path gpg-path)

  (setq epg-gpg-program
        "C:/Program Files/GnuPG/bin/gpg.exe")

  (setq gpg-program
        "C:/Program Files/GnuPG/bin/gpg.exe"))

;; Ensure the GNU ELPA signing key exists in Emacs' isolated package
;; verification GPG home (avoids relying on system GPG state).
(let* ((key-id "645357D2883A0966")
       (gpg-home
        (expand-file-name
         "elpa/gnupg"
         user-emacs-directory))
       (key-present
        (eq 0
            (call-process
             gpg-program
             nil nil nil
             "--homedir" gpg-home
             "--list-keys"
             key-id))))

  (unless key-present
    (make-directory gpg-home t)

    (message "Importing package signing key %s..." key-id)

    (call-process
     gpg-program
     nil "*gpg-import*" t
     "--homedir" gpg-home
     "--keyserver" "keyserver.ubuntu.com"
     "--recv-keys" key-id)))

(provide 'init-windows)

;;; init-windows.el ends here


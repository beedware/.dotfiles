;;; commands.el --- General commands and helpers -*- lexical-binding: t; -*-

(defun beed/update-packages ()
  "Refresh package archives and upgrade installed packages."
  (interactive)
  (package-refresh-contents)
  (package-upgrade-all)
  (when package-quickstart
    (package-quickstart-refresh)))

(defun beed/empty-hl-line-range ()
  "Return an empty range for line highlighting."
  (cons (point) (point)))

(defun beed/disable-hl-line ()
  "Disable line highlighting in the current buffer."
  (setq-local hl-line-range-function #'beed/empty-hl-line-range)
  (hl-line-mode -1)
  (global-hl-line-unhighlight))

(defun beed/arabic-input-method-title ()
  "Use a short title for the Arabic input method."
  (when (string= current-input-method "arabic")
    (setq current-input-method-title "ARA")))

(provide 'commands)
;;; commands.el ends here

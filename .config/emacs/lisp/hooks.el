;;; hooks.el --- General buffer hooks -*- lexical-binding: t; -*-

(require 'commands)

(defun beed/when-editing (function)
  "Run FUNCTION now, or on first interaction with the scratch buffer."
  (if (and (equal (buffer-name) "*scratch*") (not buffer-file-name))
      (let (setup)
        (setq setup
              (lambda ()
                (remove-hook 'pre-command-hook setup t)
                (funcall function)))
        (add-hook 'pre-command-hook setup nil t))
    (funcall function)))

(dolist (mode '(shell-mode-hook
                eshell-mode-hook
                comint-mode-hook
                term-mode-hook
                vterm-mode-hook
                eat-mode-hook
                treemacs-mode-hook
                minibuffer-setup-hook))
  (add-hook mode (lambda ()
                   (beed/disable-hl-line)
                   (display-line-numbers-mode 0))))

(add-hook 'input-method-activate-hook #'beed/arabic-input-method-title)
(add-hook 'isearch-mode-hook #'beed/arabic-input-method-title)

(provide 'hooks)
;;; hooks.el ends here

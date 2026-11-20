;;; hooks.el --- General buffer hooks -*- lexical-binding: t; -*-

(require 'commands)

(defun conf/when-editing (function)
  "Run FUNCTION in an editing buffer, deferring setup during startup.
Do not initialize editing packages in batch jobs or byte compilation."
  (unless (or noninteractive (bound-and-true-p byte-compile-current-file))
    (if (or (not after-init-time)
            (and (equal (buffer-name) "*scratch*") (not buffer-file-name)))
        (let (setup)
          (setq setup
                (lambda ()
                  (remove-hook 'pre-command-hook setup t)
                  (funcall function)))
          (add-hook 'pre-command-hook setup nil t))
      (funcall function))))

(dolist (mode '(shell-mode-hook
                eshell-mode-hook
                comint-mode-hook
                term-mode-hook
                vterm-mode-hook
                eat-mode-hook
                treemacs-mode-hook
                minibuffer-setup-hook))
  (add-hook mode (lambda ()
                   (conf/disable-hl-line)
                   (display-line-numbers-mode 0))))

(add-hook 'input-method-activate-hook #'conf/arabic-input-method-title)
(add-hook 'isearch-mode-hook #'conf/arabic-input-method-title)

(provide 'hooks)
;;; hooks.el ends here

;;; hooks.el --- General buffer hooks -*- lexical-binding: t; -*-

(require 'commands)

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

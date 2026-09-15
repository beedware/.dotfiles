;;; lsp-rc.el --- LSP configuration -*- lexical-binding: t; -*-

(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :hook
  (eglot-managed-mode . (lambda ()
                          (setq-local eldoc-display-functions
                                      '(eldoc-display-in-buffer)))))

(defun beed/lsp-enable (hook server)
  "Enable Eglot on HOOK using SERVER."
  (add-hook hook #'eglot-ensure)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs server)))

(provide 'lsp-rc)
;;; lsp-rc.el ends here

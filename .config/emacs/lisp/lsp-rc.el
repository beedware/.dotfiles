;;; lsp-rc.el --- LSP configuration -*- lexical-binding: t; -*-

(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :custom
  (eglot-ignored-server-capabilities '(:inlayHintProvider))
  :hook
  (eglot-managed-mode . (lambda ()
                          (setq-local eldoc-display-functions
                                      '(eldoc-display-in-buffer)))))

(use-package flymake
  :ensure nil
  :defer nil
  :custom
  (flymake-no-changes-timeout 2.0)
  (flymake-start-on-flymake-mode nil)
  (flymake-start-on-save-buffer t))

(add-to-list 'display-buffer-alist
             '("\\*eldoc"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.2)))

(defun beed/lsp-enable (hook server)
  "Enable Eglot on HOOK using SERVER."
  (add-hook hook #'eglot-ensure)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs server)))

(provide 'lsp-rc)
;;; lsp-rc.el ends here

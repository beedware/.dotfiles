;;; snippets-rc.el --- Snippet configuration -*- lexical-binding: t; -*-

(use-package yasnippet
  :defer nil
  :init
  (setq yas-snippet-dirs
        (list (expand-file-name "snippets" beed/emacs-config-directory)))
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet
  :config
  (add-to-list 'yas-snippet-dirs yasnippet-snippets-dir t)
  (yas-reload-all))

(provide 'snippets-rc)
;;; snippets-rc.el ends here

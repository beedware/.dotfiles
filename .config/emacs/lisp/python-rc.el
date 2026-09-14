;;; python-rc.el --- Python configuration -*- lexical-binding: t; -*-

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python" . python-ts-mode))

(beed/lsp-enable 'python-ts-mode-hook
                 '(python-ts-mode . ("ty" "server")))

(beed/formatter-add 'python-ts-mode '(ruff-isort ruff))

(provide 'python-rc)
;;; python-rc.el ends here

;;; python-rc.el --- Python configuration -*- lexical-binding: t; -*-

(require 'project)
(require 'seq)

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python" . python-ts-mode))

(beed/lsp-enable 'python-ts-mode-hook
                 '(python-ts-mode . ("ty" "server")))

(defun beed/python-use-project-venv ()
  "Use a project-local Python virtual environment when present."
  (when-let* ((project (project-current))
              (root (project-root project))
              (venv (seq-find #'file-directory-p
                              (mapcar (lambda (directory)
                                        (expand-file-name directory root))
                                      '(".venv" "venv")))))
    (setq-local python-shell-virtualenv-root venv)
    (setq-local exec-path (cons (expand-file-name "bin" venv) exec-path))
    (setq-local process-environment
                (cons (concat "VIRTUAL_ENV=" venv)
                      (cons (concat "PATH="
                                    (expand-file-name "bin" venv)
                                    path-separator
                                    (getenv "PATH"))
                            process-environment)))))

(add-hook 'python-ts-mode-hook #'beed/python-use-project-venv)

(beed/formatter-add 'python-ts-mode '(ruff-isort ruff))

(provide 'python-rc)
;;; python-rc.el ends here

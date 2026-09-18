;;; python-rc.el --- Python configuration -*- lexical-binding: t; -*-

(require 'project)
(require 'seq)
(require 'subr-x)

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python" . python-ts-mode))

(beed/lsp-enable 'python-ts-mode-hook
                 '(python-ts-mode . ("ty" "server")))

(defun beed/python-set-venv (venv)
  "Use VENV for Python tools in the current buffer."
  (interactive "DVirtualenv: ")
  (let* ((venv (file-name-as-directory (expand-file-name venv)))
         (bin (expand-file-name "bin" venv))
         (old-bin (when (bound-and-true-p python-shell-virtualenv-root)
                    (expand-file-name "bin" python-shell-virtualenv-root))))
    (unless (file-directory-p bin)
      (user-error "%s does not look like a Python virtualenv" venv))
    (setq-local python-shell-virtualenv-root venv)
    (setq-local exec-path
                (cons bin
                      (seq-remove (lambda (path)
                                    (member path (list bin old-bin)))
                                  exec-path)))
    (setq-local process-environment (copy-sequence process-environment))
    (setenv "VIRTUAL_ENV" venv)
    (setenv "PATH"
            (string-join (cons bin
                               (seq-remove (lambda (path)
                                             (member path (list bin old-bin "")))
                                           (split-string (or (getenv "PATH") "")
                                                         path-separator)))
                         path-separator))))

(defun beed/python-set-venv-restart-lsp (venv)
  "Use VENV for Python tools and restart Eglot in the current buffer."
  (interactive
   (list (read-directory-name
          "Virtualenv: "
          (or (when-let* ((project (project-current))
                          (root (project-root project)))
                (seq-find #'file-directory-p
                          (mapcar (lambda (directory)
                                    (expand-file-name directory root))
                                  '(".venv" "venv"))))
              default-directory))))
  (beed/python-set-venv venv)
  (require 'eglot)
  (when (eglot-current-server)
    (eglot-shutdown (eglot-current-server)))
  (eglot-ensure))

(defun beed/python-use-project-venv ()
  "Use a project-local Python virtual environment when present."
  (when-let* ((project (project-current))
              (root (project-root project))
              (venv (seq-find #'file-directory-p
                              (mapcar (lambda (directory)
                                        (expand-file-name directory root))
                                      '(".venv" "venv")))))
    (beed/python-set-venv venv)))

(add-hook 'python-ts-mode-hook #'beed/python-use-project-venv)

(beed/formatter-add 'python-ts-mode '(ruff-isort ruff))

(provide 'python-rc)
;;; python-rc.el ends here

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

(defun beed/yasnippet-capf ()
  "Complete Yasnippet snippets at point."
  (when (bound-and-true-p yas-minor-mode)
    (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
                (templates (yas--all-templates (yas--get-snippet-tables))))
      (list (car bounds)
            (cdr bounds)
            (delete-dups (mapcar #'yas--template-key templates))
            :annotation-function (lambda (_) " Snippet")
            :exclusive 'no
            :exit-function (lambda (_ status)
                             (when (eq status 'finished)
                               (yas-expand)))))))

(provide 'snippets-rc)
;;; snippets-rc.el ends here

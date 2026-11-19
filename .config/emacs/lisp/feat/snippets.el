;;; snippets.el --- Snippet configuration -*- lexical-binding: t; -*-

(use-package yasnippet
  :commands yas-minor-mode
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook (lambda ()
                     (beed/when-editing (lambda () (yas-minor-mode 1))))))
  (setq yas-snippet-dirs
        (list (expand-file-name "snippets" beed/emacs-config-directory))))

(use-package yasnippet-snippets
  :after yasnippet
  :demand t)

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

(provide 'feat/snippets)
;;; snippets.el ends here

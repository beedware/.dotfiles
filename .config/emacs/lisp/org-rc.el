;;; org-rc.el --- Org configuration -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :config
  (setq org-ellipsis "..."
        org-startup-folded 'overview
        org-startup-indented t
        org-hide-leading-stars t
        org-adapt-indentation nil
        org-return-follows-link t
        org-log-done 'time
        org-log-into-drawer t
        org-use-speed-commands t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-tags-column 0)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|"
                    "DONE(d)" "CANCELLED(c)"))))

(provide 'org-rc)
;;; org-rc.el ends here

;;; git-rc.el --- Git configuration -*- lexical-binding: t; -*-

(use-package magit
  :bind ("C-c g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package vundo
  :bind ("C-c u" . vundo))

(use-package diff-hl
  :defer nil
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :custom
  (diff-hl-autohide-margin t)
  :config
  (global-diff-hl-mode 1)
  (require 'diff-hl-margin)
  (dolist (face '(diff-hl-margin-insert
                  diff-hl-margin-delete
                  diff-hl-margin-change
                  diff-hl-margin-ignored
                  diff-hl-margin-unknown
                  diff-hl-margin-reference-insert
                  diff-hl-margin-reference-delete
                  diff-hl-margin-reference-change))
    (set-face-attribute face nil :background (face-background 'fringe nil t)))
  (diff-hl-flydiff-mode 1))

(provide 'git-rc)
;;; git-rc.el ends here

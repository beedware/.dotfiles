;;; git.el --- Git configuration -*- lexical-binding: t; -*-

(use-package magit
  :bind ("C-c g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package vundo
  :bind ("C-c u" . vundo))

(use-package diff-hl
  :commands diff-hl-mode
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook (lambda ()
                     (beed/when-editing (lambda () (diff-hl-mode 1))))))
  :hook ((dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :custom
  (diff-hl-autohide-margin t)
  :config
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

(provide 'plugins/git)
;;; git.el ends here

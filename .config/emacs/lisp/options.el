;;; options.el --- General settings -*- lexical-binding: t; -*-

(defconst beed/emacs-data-directory
  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share/")))

(dolist (directory '("auto-save/" "backups/"))
  (make-directory (expand-file-name directory beed/emacs-data-directory) t))

(setq inhibit-startup-message t
      initial-scratch-message nil
      auto-save-default t
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" beed/emacs-data-directory) t))
      make-backup-files t
      backup-directory-alist
      `(("." . ,(expand-file-name "backups/" beed/emacs-data-directory)))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      ring-bell-function 'ignore
      set-mark-command-repeat-pop t
      large-file-warning-threshold nil
      require-final-newline t
      vc-follow-symlinks t
      ad-redefinition-action 'accept
      global-auto-revert-non-file-buffers t
      global-hl-line-sticky-flag 'window
      bookmark-save-flag 1
      default-input-method "arabic"
      display-line-numbers-width-start t
      display-time-format "%H:%M"
      split-height-threshold 0
      split-width-threshold nil
      native-comp-async-report-warnings-errors nil)

(repeat-mode 1)
(blink-cursor-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(savehist-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
(scroll-bar-mode 0)
(xterm-mouse-mode 1)
(display-time-mode 1)
(column-number-mode 1)
(tab-bar-history-mode 1)
(auto-save-visited-mode 0)
(global-visual-line-mode 1)
(global-auto-revert-mode 1)

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80
              bidi-paragraph-direction nil
              display-line-numbers-type 'relative)

(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)

(use-package project
  :ensure nil
  :config
  (add-to-list 'project-vc-extra-root-markers ".project"))

(with-eval-after-load 'whitespace
  (setq whitespace-style
        (remove 'newline-mark (remove 'newline whitespace-style))))

(provide 'options)
;;; options.el ends here

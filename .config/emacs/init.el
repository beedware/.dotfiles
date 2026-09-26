;; -*- lexical-binding: t; -*-

(defconst beed/emacs-config-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(add-to-list 'load-path (expand-file-name "lisp" beed/emacs-config-directory))

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

(package-initialize)

(defun beed/update-packages ()
  "Refresh package archives and upgrade installed packages."
  (interactive)
  (package-refresh-contents)
  (package-upgrade-all))

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t
      use-package-always-defer t)

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
      bookmark-save-flag 1
      default-input-method "arabic"
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

(use-package project
  :ensure nil
  :config
  (add-to-list 'project-vc-extra-root-markers ".project"))

(dolist (mode '(shell-mode-hook
                eshell-mode-hook
                term-mode-hook
                vterm-mode-hook
                treemacs-mode-hook
                minibuffer-setup-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(defun beed/arabic-input-method-title ()
  (when (string= current-input-method "arabic")
    (setq current-input-method-title "ARA")))

(add-hook 'input-method-activate-hook #'beed/arabic-input-method-title)
(add-hook 'isearch-mode-hook #'beed/arabic-input-method-title)

(setq custom-file (expand-file-name "custom.el" beed/emacs-config-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

;; Modules

(require 'ui-rc)
(require 'completion-rc)
(require 'snippets-rc)
(require 'inbuffer-completion-rc)
(require 'filebrowser-rc)
(require 'git-rc)

(require 'treesitter-rc)
(require 'formatter-rc)
(require 'lsp-rc)
(require 'debugging-rc)

(require 'orgmode-rc)

;; Languages

(require 'typst-rc)
(require 'tex-rc)
(require 'markdown-rc)
; (require 'python-rc)
; (require 'c-rc)
; (require 'haskell-rc)

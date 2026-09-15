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

(require 'defaults-rc)

(require 'ui-rc)
(require 'completion-rc)
(require 'inbuffer-completion-rc)
(require 'filebrowser-rc)
(require 'snippets-rc)
(require 'git-rc)

(require 'treesitter-rc)
(require 'formatter-rc)
(require 'lsp-rc)

;; Languages
; (require 'python-rc)
(require 'typst-rc)
(require 'tex-rc)
(require 'markdown-rc)
(require 'org-rc)
(require 'journal-rc)

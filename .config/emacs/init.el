;; -*- lexical-binding: t; -*-

(defconst beed/emacs-config-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(add-to-list 'load-path (expand-file-name "lisp" beed/emacs-config-directory))

(require 'bootstrap)
(require 'options)
(require 'commands)
(require 'hooks)
(require 'keymaps)

(setq custom-file (expand-file-name "custom.el" beed/emacs-config-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

(require 'plugins/theme)
(require 'plugins/completion)
(require 'plugins/snippets)
(require 'plugins/filebrowser)
(require 'plugins/pdf)
(require 'plugins/git)

(require 'plugins/treesitter)
(require 'plugins/formatting)
(require 'plugins/lsp)
(require 'plugins/debugging)

(require 'features/org)
(require 'features/calendar)

;; Languages
(require 'languages/markdown)
(require 'languages/typst)
;; (require 'languages/tex)
;; (require 'languages/python)
;; (require 'languages/c)
;; (require 'languages/haskell)

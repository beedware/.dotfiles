;; -*- lexical-binding: t; -*-

(defconst conf/emacs-config-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(add-to-list 'load-path (expand-file-name "lisp" conf/emacs-config-directory))

(require 'bootstrap)
(require 'options)
(require 'commands)
(require 'hooks)
(require 'keymaps)

(setq custom-file (expand-file-name "custom.el" conf/emacs-config-directory))
(when (file-exists-p custom-file)
  (load custom-file t))

(require 'feat/theme)
(require 'feat/completion)
(require 'feat/snippets)
(require 'feat/filebrowser)
(require 'feat/pdf)
(require 'feat/git)

(require 'feat/treesitter)
(require 'feat/formatting)
(require 'feat/lsp)
(require 'feat/debugging)

(require 'feat/org)
(require 'feat/calendar)

;; Languages
(require 'lang/markdown)
(require 'lang/typst)
;; (require 'lang/tex)
;; (require 'lang/python)
;; (require 'lang/cpp)
;; (require 'lang/haskell)

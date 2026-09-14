;;; treesitter-rc.el --- Tree-sitter configuration -*- lexical-binding: t; -*-

(use-package treesit-auto
  :demand t
  :custom
  (c-ts-indent-offset 4)
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(provide 'treesitter-rc)
;;; treesitter-rc.el ends here

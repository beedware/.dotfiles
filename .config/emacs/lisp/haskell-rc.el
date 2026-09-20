;;; haskell-rc.el --- Haskell configuration -*- lexical-binding: t; -*-

(use-package haskell-mode
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . haskell-literate-mode)))

(beed/lsp-enable 'haskell-mode-hook
                 '((haskell-mode haskell-literate-mode) .
                   ("haskell-language-server-wrapper" "--lsp")))
(add-hook 'haskell-literate-mode-hook #'eglot-ensure)

(beed/formatter-add 'haskell-mode '(fourmolu))
(beed/formatter-add 'haskell-literate-mode '(fourmolu))

(provide 'haskell-rc)
;;; haskell-rc.el ends here

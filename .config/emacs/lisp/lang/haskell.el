;;; haskell.el --- Haskell configuration -*- lexical-binding: t; -*-

(use-package haskell-mode
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . haskell-literate-mode)))

(conf/lsp-enable 'haskell-mode-hook
                 '((haskell-mode haskell-literate-mode) .
                   ("haskell-language-server-wrapper" "--lsp")))
(add-hook 'haskell-literate-mode-hook #'eglot-ensure)

(conf/formatter-add 'haskell-mode '(fourmolu))
(conf/formatter-add 'haskell-literate-mode '(fourmolu))

(provide 'lang/haskell)
;;; haskell.el ends here

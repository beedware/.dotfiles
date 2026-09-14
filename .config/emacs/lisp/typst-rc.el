;;; typst-rc.el --- Typst configuration -*- lexical-binding: t; -*-

(use-package typst-ts-mode
  :mode ("\\.typ\\'" . typst-ts-mode)
  :init
  (with-eval-after-load 'treesit
    (add-to-list 'treesit-language-source-alist
                 '(typst "https://github.com/uben0/tree-sitter-typst"))))

(beed/lsp-enable 'typst-ts-mode-hook
                 '(typst-ts-mode . ("tinymist")))

(beed/formatter-add 'typst-ts-mode '(prettypst))

(provide 'typst-rc)
;;; typst-rc.el ends here

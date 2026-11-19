;;; typst.el --- Typst configuration -*- lexical-binding: t; -*-

(use-package typst-ts-mode
  :mode ("\\.typ\\'" . typst-ts-mode)
  :init
  (with-eval-after-load 'treesit
    (add-to-list 'treesit-language-source-alist
                 '(typst "https://github.com/uben0/tree-sitter-typst"))))

(conf/lsp-enable 'typst-ts-mode-hook
                 '(typst-ts-mode . ("tinymist")))

(conf/formatter-define 'prettypst
                       '("prettypst" "--use-std-in" "--use-std-out"))

(conf/formatter-add 'typst-ts-mode '(prettypst))

(provide 'lang/typst)
;;; typst.el ends here

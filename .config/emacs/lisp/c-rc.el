;;; c-rc.el --- C and C++ configuration -*- lexical-binding: t; -*-

(use-package c-ts-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.h\\'" . c-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.cc\\'" . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.hh\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode)))

(beed/lsp-enable 'c-ts-mode-hook
                 '((c-ts-mode c++-ts-mode) . ("clangd")))
(add-hook 'c++-ts-mode-hook #'eglot-ensure)

(beed/formatter-add 'c-ts-mode '(clang-format))
(beed/formatter-add 'c++-ts-mode '(clang-format))

(provide 'c-rc)
;;; c-rc.el ends here

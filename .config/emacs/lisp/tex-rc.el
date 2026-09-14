;;; tex-rc.el --- TeX configuration -*- lexical-binding: t; -*-

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . flyspell-mode)
         (LaTeX-mode . LaTeX-math-mode)
         (LaTeX-mode . turn-on-reftex))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-save-query nil)
  (TeX-PDF-mode t)
  (TeX-source-correlate-mode t)
  (TeX-source-correlate-start-server t)
  :config
  (add-to-list 'TeX-command-list
               '("LatexMk"
                 "latexmk -pdf -interaction=nonstopmode -synctex=1 %s"
                 TeX-run-TeX nil t
                 :help "Run LatexMk"))
  (setq TeX-command-default "LatexMk"))

(use-package reftex
  :ensure nil
  :hook (LaTeX-mode . reftex-mode)
  :custom
  (reftex-plug-into-AUCTeX t))

(beed/lsp-enable 'LaTeX-mode-hook
                 '(LaTeX-mode . ("texlab")))

(beed/formatter-add 'LaTeX-mode '(tex-fmt expand-tab-width))

(provide 'tex-rc)
;;; tex-rc.el ends here

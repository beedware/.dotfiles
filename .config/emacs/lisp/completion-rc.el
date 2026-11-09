;;; completion-rc.el --- Completion configuration -*- lexical-binding: t; -*-

(use-package vertico
  :custom
  (vertico-count 12)
  :init
  (vertico-mode 1))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package consult
  :custom
  (xref-show-definitions-function #'consult-xref)
  (xref-show-xrefs-function #'consult-xref)
  :bind (("C-c s l" . consult-line)
         ("C-c s b" . consult-buffer)
         ("C-c s y" . consult-yank-pop)
         ("C-c s g" . consult-goto-line)
         ("C-c s i" . consult-imenu)
         ("C-c r" . consult-ripgrep)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(provide 'completion-rc)
;;; completion-rc.el ends here

;;; completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

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
         ("C-c s r" . consult-ripgrep)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Snippet completion must be available before Cape combines the CAPFs.
(require 'plugins/snippets)

(use-package corfu
  :custom
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay '(0.0 . 0.0))
  :init
  (global-corfu-mode)
  :config
  (corfu-popupinfo-mode 1))

(defvar-local beed/eglot-capf-has-yasnippet nil)

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :defer nil
  :config
  (setq completion-at-point-functions
        (list (cape-capf-super #'beed/yasnippet-capf
                               #'cape-file
                               #'cape-dabbrev
                               #'cape-keyword)))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (unless beed/eglot-capf-has-yasnippet
                (setq-local completion-at-point-functions
                            (mapcar (lambda (capf)
                                      (cape-capf-super #'beed/yasnippet-capf capf))
                                    completion-at-point-functions))
                (setq-local beed/eglot-capf-has-yasnippet t)))))

(provide 'plugins/completion)
;;; completion.el ends here

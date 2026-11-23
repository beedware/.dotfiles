;;; completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-count 12))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion)))))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

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

;; Snippet completion must be available before Cape combines the CAPFs.
(require 'feat/snippets)

(use-package corfu
  :commands corfu-mode
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook (lambda ()
                     (conf/when-editing (lambda () (corfu-mode 1))))))
  :custom
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay '(0.0 . 0.0))
  :config
  (corfu-popupinfo-mode 1))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook
              (lambda ()
                (conf/when-editing
                 (lambda ()
                   (require 'cape)
                   (setq-local completion-at-point-functions
                               (append completion-at-point-functions
                                       (list (cape-capf-super #'conf/yasnippet-capf
                                                              #'cape-file
                                                              #'cape-dabbrev
                                                              #'cape-keyword)))))))))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              ;; The general Cape CAPF already includes snippets.
              (setq-local completion-at-point-functions
                          (mapcar (lambda (capf)
                                    (if (eq capf 'eglot-completion-at-point)
                                        (cape-capf-super #'conf/yasnippet-capf capf)
                                      capf))
                                  completion-at-point-functions)))))

(provide 'feat/completion)
;;; completion.el ends here

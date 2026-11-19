;;; completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

(use-package vertico
  :commands vertico-mode
  :custom
  (vertico-count 12))

(use-package marginalia
  :commands marginalia-mode)

(defun beed/enable-minibuffer-completion (&rest _)
  "Initialize completion before the first minibuffer is set up."
  (vertico-mode 1)
  (marginalia-mode 1)
  (remove-hook 'pre-command-hook #'beed/enable-minibuffer-completion)
  (advice-remove 'completing-read #'beed/enable-minibuffer-completion)
  (advice-remove 'read-from-minibuffer #'beed/enable-minibuffer-completion))

(add-hook 'pre-command-hook #'beed/enable-minibuffer-completion)
(advice-add 'completing-read :before #'beed/enable-minibuffer-completion)

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
(require 'feat/snippets)

(use-package corfu
  :commands corfu-mode
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook (lambda ()
                     (beed/when-editing (lambda () (corfu-mode 1))))))
  :custom
  (corfu-preselect 'prompt)
  (corfu-popupinfo-delay '(0.0 . 0.0))
  :config
  (corfu-popupinfo-mode 1))

(defvar-local beed/eglot-capf-has-yasnippet nil)

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook
              (lambda ()
                (beed/when-editing
                 (lambda ()
                   (require 'cape)
                   (setq-local completion-at-point-functions
                               (append completion-at-point-functions
                                       (list (cape-capf-super #'beed/yasnippet-capf
                                                              #'cape-file
                                                              #'cape-dabbrev
                                                              #'cape-keyword)))))))))
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (unless beed/eglot-capf-has-yasnippet
                (setq-local completion-at-point-functions
                            (mapcar (lambda (capf)
                                      (if (eq capf t)
                                          t
                                        (cape-capf-super #'beed/yasnippet-capf capf)))
                                    completion-at-point-functions))
                (setq-local beed/eglot-capf-has-yasnippet t)))))

(provide 'feat/completion)
;;; completion.el ends here

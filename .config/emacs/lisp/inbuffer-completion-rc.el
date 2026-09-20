;;; inbuffer-completion-rc.el --- In-buffer completion configuration -*- lexical-binding: t; -*-

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

(provide 'inbuffer-completion-rc)
;;; inbuffer-completion-rc.el ends here

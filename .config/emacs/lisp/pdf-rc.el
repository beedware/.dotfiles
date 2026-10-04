;;; pdf-rc.el --- PDF viewing configuration -*- lexical-binding: t; -*-

(defun beed/pdf-view-setup ()
  "Configure `pdf-view-mode' buffers."
  (beed/disable-hl-line)
  (display-line-numbers-mode 0)
  (pdf-view-fit-page-to-window))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :hook ((pdf-view-mode . beed/pdf-view-setup)
         (pdf-view-mode . pdf-isearch-minor-mode))
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("J" . pdf-view-next-page)
              ("K" . pdf-view-previous-page)
              ("+" . pdf-view-enlarge)
              ("-" . pdf-view-shrink)
              ("=" . pdf-view-fit-page-to-window)
              ("w" . pdf-view-fit-width-to-window))
  :custom
  (pdf-view-display-size 'fit-page)
  (pdf-view-midnight-colors '("#ffffff" . "#000000"))
  (pdf-view-resize-factor 1.1)
  :config
  (pdf-tools-install :no-query))

(provide 'pdf-rc)
;;; pdf-rc.el ends here

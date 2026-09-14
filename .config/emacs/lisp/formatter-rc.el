;;; formatter-rc.el --- Formatter configuration -*- lexical-binding: t; -*-

(use-package apheleia
  :bind (("C-c f" . apheleia-format-buffer))
  :config
  (setf (alist-get 'prettypst apheleia-formatters)
        '("prettypst" "--use-std-in" "--use-std-out"))
  (setf (alist-get 'tex-fmt apheleia-formatters)
        '("tex-fmt" "--stdin" "--tabsize" (number-to-string tab-width)))
  (setf (alist-get 'expand-tab-width apheleia-formatters)
        '("expand" "-t" (number-to-string tab-width))))

(defun beed/formatter-add (mode formatters)
  "Use FORMATTERS for MODE in Apheleia."
  (with-eval-after-load 'apheleia
    (setf (alist-get mode apheleia-mode-alist) formatters)))

(provide 'formatter-rc)
;;; formatter-rc.el ends here

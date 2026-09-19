;;; debugging-rc.el --- Debugging configuration -*- lexical-binding: t; -*-

(use-package dape
  :bind (("C-c d d" . dape)
         ("C-c d b" . dape-breakpoint-toggle)
         ("C-c d r" . dape-continue)
         ("C-c d R" . dape-restart)
         ("C-c d l" . dape)
         ("C-c d t" . dape-kill)
         ("C-c d w" . dape-watch-dwim)
         ("C-c d k" . dape-info)
         ("C-c d v" . dape-repl)
         ("C-c d i" . dape-step-in)
         ("C-c d o" . dape-step-out)
         ("C-c d n" . dape-next)
         ("C-c d p" . dape-pause)
         ("C-c d q" . dape-quit))
  :custom
  (dape-buffer-window-arrangement 'right)
  :config
  (setq window-sides-vertical t)
  (add-hook 'dape-start-hook (lambda () (save-some-buffers t t))))

(provide 'debugging-rc)
;;; debugging-rc.el ends here

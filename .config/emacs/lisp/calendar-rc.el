;;; calendar-rc.el --- Calfw calendar configuration -*- lexical-binding: t; -*-

(defun beed/calendar-setup ()
  "Keep the calendar grid free of line numbers and line highlighting."
  (beed/disable-hl-line)
  (display-line-numbers-mode 0)
  (visual-line-mode -1)
  (setq-local truncate-lines t))

(use-package calfw
  :commands calfw-open-calendar-buffer
  :hook (calfw-calendar-mode . beed/calendar-setup)
  :custom
  (calfw-fchar-vertical-line ?|)
  (calfw-fchar-horizontal-line ?-)
  (calfw-fchar-junction ?+)
  (calfw-fchar-top-left-corner ?+)
  (calfw-fchar-top-right-corner ?+)
  (calfw-fchar-left-junction ?+)
  (calfw-fchar-right-junction ?+)
  (calfw-fchar-top-junction ?+))

(use-package calfw-org
  :commands calfw-org-open-calendar
  :bind ("C-c o c" . calfw-org-open-calendar)
  :custom
  (calfw-read-date-command #'calfw-org-read-date-command))

(provide 'calendar-rc)
;;; calendar-rc.el ends here

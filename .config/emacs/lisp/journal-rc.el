;;; journal-rc.el --- Journal configuration -*- lexical-binding: t; -*-

(defconst beed/journal-directory
  (file-truename (expand-file-name "~/Compendium/Journal/")))

(defun beed/journal-file (file)
  "Return FILE inside `beed/journal-directory'."
  (expand-file-name file beed/journal-directory))

(defconst beed/journal-capture-file
  (beed/journal-file "repo.org"))

(defconst beed/journal-inbox-file
  (beed/journal-file "inbox.org"))

(defconst beed/journal-agenda-file-names
  '("inbox.org"
    "marks.org"
    "wants.org"
    "repo.org"
    "kcl.org"
    "hijri.org"
    "planner.org"
    "done.org"))

(defun beed/org-journal-capture-target ()
  "Capture under today's heading in `beed/journal-capture-file'."
  (set-buffer (org-capture-target-buffer beed/journal-capture-file))
  (widen)
  (let ((heading (format "* %s" (format-time-string "%Y%m%d"))))
    (goto-char (point-max))
    (if (re-search-backward (format "^%s$" (regexp-quote heading)) nil t)
        (beginning-of-line)
      (goto-char (point-max))
      (unless (bolp)
        (insert "\n"))
      (insert heading "\n")
      (forward-line -1))
    (point)))

(use-package org
  :ensure nil
  :after org
  :config
  (setq org-directory beed/journal-directory)

  (setq org-agenda-files
        (mapcar #'beed/journal-file beed/journal-agenda-file-names))

  (setq org-default-notes-file beed/journal-capture-file)

  (setq org-capture-templates
        `(("n" "Note" entry
            (function beed/org-journal-capture-target)
            "** %<%H%M%S> - %?")
           ("i" "Inbox" entry
            (file ,beed/journal-inbox-file)
            "* %?")
           ("m" "Mark" entry
            (file ,(beed/journal-file "marks.org"))
            "* %^{Title} %^{Tags}\n:PROPERTIES:\n:URL: %^{URL}\n:END:\n\n%?")
           ("t" "Task" entry
            (file ,(beed/journal-file "planner.org"))
            "* TODO %^{Title} %^{Tags}\n%?")
           ("e" "Event" entry
            (file ,(beed/journal-file "planner.org"))
            "* %^{Title} %^{Tags}\n%?")))

  (setq org-refile-targets '((org-agenda-files :maxlevel . 2))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-agenda-window-setup 'current-window
        org-agenda-start-with-log-mode t))

(provide 'journal-rc)
;;; journal-rc.el ends here

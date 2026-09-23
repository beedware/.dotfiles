;;; journal-rc.el --- Journal configuration -*- lexical-binding: t; -*-

(defconst beed/journal-directory
  (file-truename (expand-file-name "~/Compendium/Journal/")))

(defun beed/journal-file (file)
  "Return FILE inside `beed/journal-directory'."
  (expand-file-name file beed/journal-directory))

(defconst beed/journal-agenda-file-names
  '("inbox.org"
    "kcl.org"
    "hijri.org"
    "planner.org"
    "done.org"))

(defconst beed/journal-refile-file-names
  '("inbox.org"
    "planner.org"
    "done.org"))

(defun beed/org-journal-capture-target ()
  "Capture under today's heading in repo.org."
  (set-buffer (org-capture-target-buffer (beed/journal-file "repo.org")))
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

  (setq org-default-notes-file (beed/journal-file "repo.org"))

  (setq org-capture-templates
        `(("n" "Note" entry
            (function beed/org-journal-capture-target)
            "** %<%H%M%S> - %?"
            :empty-lines-before 1)
           ("i" "Inbox" entry
            (file ,(beed/journal-file "inbox.org"))
            "* %?"
            :empty-lines-before 1)
           ("m" "Mark" entry
            (file ,(beed/journal-file "marks.org"))
            "* %^{Title} %^g\n:PROPERTIES:\n:URL: %^{URL}\n:END:\n\n%?"
            :empty-lines-before 1)
           ("t" "Task" entry
            (file ,(beed/journal-file "planner.org"))
            "* TODO %^{Title} %^g\n%?"
            :empty-lines-before 1)
           ("e" "Event" entry
            (file ,(beed/journal-file "planner.org"))
            "* %^{Title} %^g\n%?"
            :empty-lines-before 1)))

  (setq org-refile-targets `((,(mapcar #'beed/journal-file beed/journal-refile-file-names)
                              :maxlevel . 2))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-agenda-window-setup 'current-window
        org-agenda-start-with-log-mode t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-custom-commands
        '(("u" "Unscheduled TODOs"
           ((todo ""
                  ((org-agenda-overriding-header "Unscheduled TODOs")
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'regexp "\\[#C\\]"))))
            (todo ""
                  ((org-agenda-overriding-header "Low Priority [#C]")
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'notregexp "\\[#C\\]"))))))
          ("d" "TODOs with Deadlines"
           todo ""
           ((org-agenda-overriding-header "TODOs with Deadlines")
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notdeadline)))))))

(provide 'journal-rc)
;;; journal-rc.el ends here

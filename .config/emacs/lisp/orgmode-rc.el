;;; orgmode-rc.el --- Org configuration -*- lexical-binding: t; -*-

(defconst beed/journal-directory
  (file-truename (expand-file-name "~/Compendium/Journal/")))

(defun beed/journal-file (file)
  "Return FILE inside `beed/journal-directory'."
  (expand-file-name file beed/journal-directory))

(defconst beed/journal-agenda-file-names
  '("inbox.org"
    "kings.org"
    "hijri.org"
    "sched.org"))

(defconst beed/journal-refile-file-names
  '("inbox.org"
    "sched.org"
    "trail.org"))

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :config
  (setq org-ellipsis "..."
        org-startup-folded 'content
        org-startup-indented t
        org-hide-leading-stars t
        org-adapt-indentation nil
        org-return-follows-link t
        org-log-done 'time
        org-log-into-drawer t
        org-use-speed-commands t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-tags-column 0)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROG(p)" "WAIT(w)" "|"
                    "DONE(d)" "KILL(k)")))

  (setq org-directory beed/journal-directory)

  (setq org-agenda-files
        (mapcar #'beed/journal-file beed/journal-agenda-file-names))

  (setq org-default-notes-file (beed/journal-file "folio.org"))

  (setq org-capture-templates
        `(("f" "Folio" entry
           (file ,(beed/journal-file "folio.org"))
           "* %<%Y%m%d/%H%M%S> - %?"
           :prepend t
           :empty-lines-before 0)
          ("i" "Inbox" entry
           (file ,(beed/journal-file "inbox.org"))
           "* %?"
           :prepend t
           :empty-lines-before 0)
          ("m" "Mark" entry
           (file ,(beed/journal-file "marks.org"))
           "* %^{Title} %^g\n:PROPERTIES:\n:URL: %^{URL}\n:END:\n\n%?")
          ("n" "Name" entry
           (file ,(beed/journal-file "names.org"))
           "* %^{Name}\n:PROPERTIES:\n:PHONE: %^{Phone}\n:EMAIL: %^{Email}\n:ADDRESS: %^{Address}\n:END:\n\n%?\n\n** %\\1's birthday\n%^{Birthday}t")
          ("t" "Task" entry
           (file ,(beed/journal-file "sched.org"))
           "* TODO %^{Title} %^g\n%?")
          ("e" "Event" entry
           (file ,(beed/journal-file "sched.org"))
           "* %^{Title} %^g\n%?")))

  (setq org-refile-targets `((,(mapcar #'beed/journal-file beed/journal-refile-file-names)
                              :maxlevel . 2))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-agenda-window-setup 'current-window
        org-agenda-span 3
        org-agenda-scheduled-leaders '("" "")
        org-agenda-deadline-leaders '("" "" "")
        org-agenda-start-with-log-mode nil
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-deadline-warning-days 0
        org-agenda-inhibit-startup t
        org-agenda-skip-deadline-prewarning-if-scheduled t
        org-agenda-custom-commands
        '(("u" "Unscheduled Tasks"
           ((todo ""
                  ((org-agenda-overriding-header "Unscheduled Tasks")
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'regexp "\\[#C\\]"))))
            (todo ""
                  ((org-agenda-overriding-header "Low Priority [#C]")
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'scheduled 'notregexp "\\[#C\\]"))))))
          ("d" "TODOs with Deadlines"
           todo ""
           ((org-agenda-overriding-header "Tasks with Deadlines")
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'notdeadline)))))))

(provide 'orgmode-rc)
;;; orgmode-rc.el ends here

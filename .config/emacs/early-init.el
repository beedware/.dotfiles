;; -*- lexical-binding: t; -*-

;; Work around distro site-start files that expect this variable.
(defvar flavor 'emacs)

(defun conf/startup-log-buffer-p (buffer-name _action)
  "Return non-nil for installation log BUFFER-NAME during startup."
  (and (not after-init-time)
       (member buffer-name '("*Compile-Log*" "*Warnings*" "*compilation*"))))

(add-to-list 'display-buffer-alist
             '(conf/startup-log-buffer-p
               (display-buffer-no-window)
               (allow-no-window . t)))

(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

(setq package-quickstart nil
      package-quickstart-file
      (expand-file-name "emacs/package-quickstart.el"
                        (or (getenv "XDG_DATA_HOME") "~/.local/share/")))

(dolist (file (list package-quickstart-file
                    (concat package-quickstart-file "c")))
  (when (file-exists-p file)
    (delete-file file)))

(setq frame-inhibit-implied-resize t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(font . "CommitMono Nerd Font-12") default-frame-alist)

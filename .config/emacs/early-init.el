;; -*- lexical-binding: t; -*-

;; Work around distro site-start files that expect this variable.
(defvar flavor 'emacs)

(defvar beed/normal-gc-cons-threshold (* 16 1024 1024))
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold beed/normal-gc-cons-threshold)))

(setq package-quickstart t
      package-quickstart-file
      (expand-file-name "emacs/package-quickstart.el"
                        (or (getenv "XDG_DATA_HOME") "~/.local/share/")))

(setq frame-inhibit-implied-resize t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(font . "CommitMono Nerd Font-12") default-frame-alist)

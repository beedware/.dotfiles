;;; theme.el --- Theme and UI configuration -*- lexical-binding: t; -*-

(set-face-attribute 'default nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(set-fontset-font t 'arabic
                  (font-spec :family "Noto Sans Arabic"))

(set-face-attribute 'variable-pitch nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(use-package modus-themes
  :demand t
  :config
  (setq modus-themes-bold-constructs t
         modus-themes-italic-constructs nil)
  (set-face-attribute 'line-number nil :slant 'normal)
  (set-face-attribute 'line-number-current-line nil :slant 'normal)
  (require 'subr-x)
  (let* ((mode-file (expand-file-name "~/.config/themer/mode"))
         (mode (when (file-readable-p mode-file)
                 (with-temp-buffer
                   (insert-file-contents mode-file)
                   (string-trim (buffer-string))))))
    (load-theme (if (equal mode "light") 'modus-operandi 'modus-vivendi) t)))

(use-package doom-modeline
  :defer 0.5
  :init
  (setq doom-modeline-icon nil
        doom-modeline-major-mode-icon nil
        doom-modeline-major-mode-color-icon nil
        doom-modeline-buffer-state-icon nil
        doom-modeline-buffer-modification-icon nil
        doom-modeline-lsp-icon nil
        doom-modeline-time-icon nil
        doom-modeline-time-live-icon nil
        doom-modeline-time-analogue-clock nil
        doom-modeline-vcs-icon nil
        doom-modeline-check-icon nil
        doom-modeline-persp-icon nil
        doom-modeline-modal-icon nil
        doom-modeline-modal-modern-icon nil
        doom-modeline-unicode-fallback nil
        doom-modeline-unicode-number nil)
  :config
  (doom-modeline-mode 1))

(provide 'feat/theme)
;;; theme.el ends here

;;; ui-rc.el --- UI configuration -*- lexical-binding: t; -*-

(set-face-attribute 'default nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(set-fontset-font t 'arabic
                  (font-spec :family "Noto Sans Arabic"))

(set-face-attribute 'variable-pitch nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(defvar-local beed/selection-whitespace-overlays nil
  "Whitespace markers displayed in the active region.")

(defvar beed/selection-whitespace-last-buffer nil
  "Buffer whose selection whitespace was last updated.")

(defun beed/clear-selection-whitespace ()
  "Remove whitespace markers from the current buffer."
  (mapc #'delete-overlay beed/selection-whitespace-overlays)
  (setq beed/selection-whitespace-overlays nil))

(defun beed/update-selection-whitespace ()
  "Display whitespace characters only in the active region."
  (when (and (buffer-live-p beed/selection-whitespace-last-buffer)
             (not (eq beed/selection-whitespace-last-buffer (current-buffer))))
    (with-current-buffer beed/selection-whitespace-last-buffer
      (beed/clear-selection-whitespace)))
  (setq beed/selection-whitespace-last-buffer (current-buffer))
  (beed/clear-selection-whitespace)
  (when (use-region-p)
    (let ((start (region-beginning))
          (end (region-end)))
      (save-excursion
        (goto-char start)
        (while (re-search-forward "[ \t\u00A0]" end t)
          (let* ((char (char-before))
                 (overlay (make-overlay (1- (point)) (point)))
                 (marker (pcase char
                           (?\t "»\t")
                           (?\xA0 "¤")
                           (_ "·"))))
            (overlay-put overlay 'display marker)
             (overlay-put overlay 'face 'shadow)
            (push overlay beed/selection-whitespace-overlays)))))))

(add-hook 'post-command-hook #'beed/update-selection-whitespace)
(add-hook 'deactivate-mark-hook #'beed/clear-selection-whitespace)

(use-package modus-themes
  :demand t
  :config
  (setq modus-themes-bold-constructs t
         modus-themes-italic-constructs nil)
  (set-face-attribute 'line-number nil :slant 'normal)
  (set-face-attribute 'line-number-current-line nil :slant 'normal)
  (load-theme 'modus-vivendi t))

(use-package doom-modeline
  :defer nil
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

(provide 'ui-rc)
;;; ui-rc.el ends here

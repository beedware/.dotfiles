;;; ui-rc.el --- UI configuration -*- lexical-binding: t; -*-

(set-face-attribute 'default nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(set-fontset-font t 'arabic
                  (font-spec :family "Noto Sans Arabic"))

(set-face-attribute 'variable-pitch nil
                    :family "CommitMono Nerd Font"
                    :height 120)

(use-package whitespace
  :ensure nil
  :defer nil
  :custom
  (whitespace-style '(face tabs tab-mark nbsp nbsp-mark))
  :config
  (global-whitespace-mode 1))

(defvar-local beed/trailing-space-overlays nil)

(defface beed/trailing-space-marker
  '((t :inherit shadow))
  "Face used for trailing-space markers.")

(defun beed/set-trailing-space-marker-face ()
  (when (featurep 'modus-themes)
    (set-face-attribute
     'beed/trailing-space-marker nil
     :foreground (modus-themes-generate-color-blend
                  (modus-themes-get-color-value 'fg-dim)
                  (modus-themes-get-color-value 'bg-main)
                  0.55)
     :background 'unspecified)))

(defun beed/clear-trailing-space-overlays ()
  (mapc #'delete-overlay beed/trailing-space-overlays)
  (setq beed/trailing-space-overlays nil))

(defun beed/show-trailing-spaces-as-dots (&rest _)
  (beed/clear-trailing-space-overlays)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward " +$" nil t)
      (let ((overlay (make-overlay (match-beginning 0) (match-end 0))))
        (overlay-put overlay 'display
                     (make-string (- (match-end 0) (match-beginning 0))
                                  ?·))
        (overlay-put overlay 'face 'beed/trailing-space-marker)
        (push overlay beed/trailing-space-overlays)))))

(define-minor-mode beed/trailing-space-mode
  "Display trailing spaces as middle dots."
  :lighter nil
  (if beed/trailing-space-mode
      (progn
        (add-hook 'after-change-functions #'beed/show-trailing-spaces-as-dots nil t)
        (beed/show-trailing-spaces-as-dots))
    (remove-hook 'after-change-functions #'beed/show-trailing-spaces-as-dots t)
    (beed/clear-trailing-space-overlays)))

(define-globalized-minor-mode global-beed/trailing-space-mode
  beed/trailing-space-mode
  (lambda ()
    (unless (minibufferp)
      (beed/trailing-space-mode 1))))

(global-beed/trailing-space-mode 1)

(use-package modus-themes
  :demand t
  :config
  (setq modus-themes-bold-constructs t
         modus-themes-italic-constructs nil)
  (set-face-attribute 'line-number nil :slant 'normal)
  (set-face-attribute 'line-number-current-line nil :slant 'normal)
  (load-theme 'modus-vivendi t)
  (beed/set-trailing-space-marker-face)
  (add-hook 'enable-theme-functions #'beed/set-trailing-space-marker-face))

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

;;; bootstrap.el --- Package setup -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

(unless (bound-and-true-p package--activated)
  (package-activate-all))

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t
      use-package-always-defer t)

(provide 'bootstrap)
;;; bootstrap.el ends here

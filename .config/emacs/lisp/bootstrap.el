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
(require 'cl-lib)
(require 'bytecomp)

(defun conf/ensure-packages (name args state)
  "Install NAME and ARGS before compiling their dependency transaction.
STATE is passed through to `use-package-ensure-elpa'.  Upstream compiler
lint warnings are disabled only for installed packages, not configuration
files; compiler errors and runtime warnings are still reported."
  (let ((compile-package (symbol-function 'package--compile))
        pending
        result)
    (cl-letf (((symbol-function 'package--compile)
               (lambda (descriptor) (push descriptor pending))))
      (setq result (use-package-ensure-elpa name args state)))
    (let* ((byte-compile-warnings nil)
           (log-diagnostic byte-compile-log-warning-function)
           (byte-compile-log-warning-function
            (lambda (message position fill level)
              (when (eq level :error)
                (funcall log-diagnostic message position fill level))))
           (macroexp-diagnostic (symbol-function 'macroexp-warn-and-return)))
      (cl-letf (((symbol-function 'macroexp-warn-and-return)
                 (lambda (message form &optional category compile-only arg)
                   (if (eq (if (consp category) (car category) category) 'obsolete)
                       form
                     (funcall macroexp-diagnostic message form category compile-only arg)))))
        (dolist (descriptor (nreverse pending))
          (funcall compile-package descriptor))))
    result))

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-ensure-function #'conf/ensure-packages)

(provide 'bootstrap)
;;; bootstrap.el ends here

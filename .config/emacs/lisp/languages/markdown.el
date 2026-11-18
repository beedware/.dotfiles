;;; markdown.el --- Markdown configuration -*- lexical-binding: t; -*-

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-command "pandoc")
  (markdown-fontify-code-blocks-natively nil)
  (markdown-enable-wiki-links t)
  (markdown-italic-underscore t))

(provide 'languages/markdown)
;;; markdown.el ends here

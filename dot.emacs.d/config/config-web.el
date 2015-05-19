(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . web-mode))

(add-hook 'web-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c /") 'web-mode-element-close)
            (local-set-key (kbd "C-c C-c") 'web-mode-comment-or-uncomment)
            )
          )

(provide 'config-web)

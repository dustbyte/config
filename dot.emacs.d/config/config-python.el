(push 'python-mode-hook flycheck-hooks)

;; Jedi
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (local-set-key (kbd "C-c /") 'jedi:complete)
            (local-set-key (kbd "M-RET") 'jedi:complete)
            (setq jedi:setup-keys t)
            (setq jedi:complete-on-dot t)
            )
          )

(add-hook 'python-mode-hook
	  (lambda ()
	    (local-unset-key (kbd "C-c C-c"))
	    (local-set-key (kbd "M-,") 'python-indent-shift-left)
	    (local-set-key (kbd "M-.") 'python-indent-shift-right)
            (setq fill-column 120)
	    )
          )

(provide 'config-python)

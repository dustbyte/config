(on-require 'go-mode

            (add-hook 'go-mode-hook
                      (lambda ()
                        (local-set-key (kbd "C-c d") 'godoc)
                        (local-set-key (kbd "C-c s") 'go-remove-unused-imports)
                        (local-set-key (kbd "C-c g") 'go-goto-imports)
                        (local-set-key (kbd "M-,") 'godef-jump-other-window)
                        (local-set-key (kbd "M-.") 'godef-jump)
                        (setq tab-width 4)
                        )
                      )

            (setq gofmt-command "goimports")
            (add-hook 'before-save-hook 'gofmt-before-save)

            (add-hook 'go-mode-hook 'company-mode)
            (add-hook 'go-mode-hook (lambda ()
                                      (set (make-local-variable 'company-backends) '(company-go))
                                      (company-mode)))
            )

(provide 'config-go)

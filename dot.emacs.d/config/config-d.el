(push 'd-mode-hook flycheck-hooks)

(add-to-list 'load-path "~/.emacs.d/misc/")
(on-require 'ac-dcd
            (add-hook 'd-mode-hook
                      (lambda ()
                        (add-to-list 'ac-modes 'd-mode)

                        (ac-dcd-maybe-start-server)
                        (add-to-list 'ac-sources 'ac-source-dcd)

                        (define-key d-mode-map (kbd "C-c ?") 'ac-dcd-show-ddoc-with-buffer)
                        (define-key d-mode-map (kbd "C-c .") 'ac-dcd-goto-definition)
                        (define-key d-mode-map (kbd "C-c ,") 'ac-dcd-goto-def-pop-marker)
                        (when (featurep 'popwin)
                          (add-to-list 'popwin:special-display-config
                                       `(,ac-dcd-document-buffer-name :position right :width 80)))
                        )
                      )
            )

(on-require 'flycheck-d-unittest
            (setup-flycheck-d-unittest)
            )

(provide 'config-d)

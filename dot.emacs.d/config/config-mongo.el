(on-require 'inf-mongo

            (defun mongo-send-paragraph ()
              "Send the last paragraph to mongo"
              (interactive)
              (let ((start (save-excursion
                             (backward-paragraph)
                             (point)))
                    (end (save-excursion
                           (forward-paragraph)
                           (point))))
                (mongo-send-region start end))
              )

            (add-hook 'web-mode-hook
                      (lambda ()
                        (local-set-key (kbd "C-c C-s") 'mongo-send-paragraph)
                        (local-set-key (kbd "C-c m") 'mongo-send-region)
                        )
                      )

            )

(provide 'config-mongo)

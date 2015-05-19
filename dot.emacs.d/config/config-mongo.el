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

            (global-set-key (kbd "C-c C-p") 'mongo-send-paragraph)
            (global-set-key (kbd "C-c m") 'mongo-send-region)

            )

(provide 'config-mongo)

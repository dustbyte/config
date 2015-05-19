(setq c-modes-hooks '(c-mode-hook c++-mode-hook))

(c-add-style "mota"
             '("bsd"
               (indent-tabs-mode . nil)
               (tab-width . 4)
               (c-basic-offset . 4)
               (innamespace . 0)
               (substatement-open . 2)
               (statement-block-intro . 2)
               ))

; Found in EmacsWiki
 (c-add-style "openbsd"
              '("bsd"
                (indent-tabs-mode . t)
                (defun-block-intro . 8)
                (statement-block-intro . 8)
                (statement-case-intro . 8)
                (substatement-open . 4)
                (substatement . 8)
                (arglist-cont-nonempty . 4)
                (inclass . 8)
                (knr-argdecl-intro . 8)
                ))

(setq c-default-style "mota")

(add-multiple-hooks c-modes-hooks
          (lambda ()
            (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48\
                                    52 56 60 64 68 72 76 80 84 86\
                                    90 120))
            )
          )

(on-require 'auto-complete-clang
            (add-multiple-hooks c-modes-hooks
                      (lambda ()
                        (setq ac-sources (append '(ac-source-clang) ac-sources))
                        (local-set-key (kbd "C-c /") 'ac-complete-clang)
                        (local-set-key (kbd "M-RET") 'ac-complete-clang)
                        )))

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp$" . c++-mode))

(provide 'config-c)

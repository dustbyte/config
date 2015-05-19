;; Based on emacsd-tile

(global-set-key (kbd "M-J") (lambda () (interactive) (enlarge-window -1)))
(global-set-key (kbd "M-K") (lambda () (interactive) (enlarge-window 1)))
(global-set-key (kbd "M-H") (lambda () (interactive) (enlarge-window -1 t)))
(global-set-key (kbd "M-L") (lambda () (interactive) (enlarge-window 1 t)))

(global-set-key (kbd "ESC <down>") 'windmove-down)
(global-set-key (kbd "ESC <up>") 'windmove-up)
(global-set-key (kbd "ESC <left>") 'windmove-left)
(global-set-key (kbd "ESC <right>") 'windmove-right)

(global-set-key (kbd "ESC <down>") 'windmove-down)
(global-set-key (kbd "ESC <up>") 'windmove-up)
(global-set-key (kbd "ESC <left>") 'windmove-left)
(global-set-key (kbd "ESC <right>") 'windmove-right)

(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)

(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)
(global-set-key (kbd "C-c <left>") 'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)

(provide 'config-wm)

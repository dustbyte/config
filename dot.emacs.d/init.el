(defmacro on-require (mode &rest body)
  `(when (require ,mode nil 'noerror)
     ,@body
     )
  )

(defmacro add-multiple-hooks (hooks function)
  `(mapc (lambda (hook)
           (add-hook hook ,function))
         ,hooks)
  )

(defun smart-open-line-above()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-line-according-to-mode)
  )

(defun magit-status-solo (&optional dir)
  "Helper function allowing to call magit-status directly from command-line"
  (interactive)
  (when (not dir)
    (setq dir ".")
    )
  (magit-status dir)
  (delete-other-windows)
  )

(setq flycheck-hooks ())

(add-to-list 'load-path "~/.emacs.d/scripts")
(add-to-list 'load-path "~/.emacs.d/config")
(add-to-list 'load-path "~/.emacs.d/shadow")

;; Variables
(custom-set-variables
 '(auth-source-save-behavior nil)
 '(column-number-mode t)
 '(display-time-24hr-format t)
 '(display-time-interval 1)
 '(display-time-mode t)
 '(electric-pair-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(ido-mode t nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(linum-format "%3d ")
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(ring-bell-function (quote ignore) t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(wrap-region-mode t)
 '(save-place t)
 '(redisplay-dont-pause t)
 '(scroll-margin 1)
 '(scroll-step 1)
 '(scroll-conservatively 10000)
 '(scroll-preserve-screen-position 1)
 '(mouse-wheel-follow-mouse 't)
 '(mouse-wheel-scroll-amount '(1 ((shift) . 1)))
 '(electric-indent-mode t)
 '(visible-cursor nil)
 )

;; Misc options
(prefer-coding-system 'utf-8)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))

(setq font-height
      (if (eq system-type 'darwin) 120 80)
      )

(set-face-attribute 'default nil :height 120 :family "DejaVu Sans Mono")
(which-function-mode 1)

;; Package setup
(on-require 'package
            (when (file-exists-p "~/.cask/cask.el")
              (require 'cask "~/.cask/cask.el")
              (cask-initialize)
              )

            ;; Themes
            (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
            (load-theme 'wwombat t)

            ;; autocomplete
            (on-require 'auto-complete
                        (global-auto-complete-mode t)
                        )

            ;; Yasnippet
            (on-require 'yasnippet
                        (yas-global-mode t)
                        (setq yas/root-directory "~/.emacs.d/snippets")
                        )

            (setq global-hl-line-mode t)

            (custom-set-faces
             '(flycheck-error ((t (:underline t))))
             '(flycheck-warning ((t (:underline t))))
             '(flycheck-info ((t (:underline t))))
             )
            (setq
             flycheck-highlighting-mode 'lines
             flycheck-display-errors-delay 0.5
             )
            (global-set-key (kbd "M-n") 'flycheck-next-error)
            (global-set-key (kbd "M-p") 'flycheck-previous-error)

            )

;; Mouse
(on-require 'mouse
            (xterm-mouse-mode t)
            (defun track-mouse (e))
            (setq mouse-sel-mode t)
            )

;; selection
(on-require 'selection
            (global-set-key (kbd "C-x c") 'copy-to-clipboard)
            (global-set-key (kbd "C-x v") 'paste-from-clipboard)
            (global-set-key (kbd "C-x x") 'cut-to-clipboard)
            (global-set-key (kbd "C-c c") 'copy-to-primary)
            (global-set-key (kbd "C-c v") 'paste-from-primary)
            (global-set-key (kbd "C-c x") 'cut-to-primary)
            )

;; Symbol properties
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; General Shortcuts
(global-set-key [(control tab)] 'other-window)
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c r") 'replace-string)
(global-set-key (kbd "C-c R") 'replace-regexp)
(global-set-key (kbd "C-c a") 'align)
(global-set-key (kbd "C-x m") 'list-matching-lines)
(global-set-key (kbd "C-x r q") 'replace-rectangle)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x g s") 'magit-status)
(global-set-key (kbd "C-x g b") 'magit-blame-mode)
(global-set-key (kbd "C-o") 'smart-open-line-above)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-^") (lambda () (interactive) (delete-indentation 1)))
(global-set-key (kbd "C-x p") 'pwd)
(global-set-key (kbd "<backtab>") (lambda () (interactive) (let ((current-prefix-arg -4)) (call-interactively 'indent-rigidly))))

(global-set-key (kbd "C-M-w") 'delete-window)
(global-set-key (kbd "C-M-f") (lambda ()
                                (interactive)
                                (save-excursion
                                  (beginning-of-buffer)
                                  (set-mark-command nil)
                                  (end-of-buffer)
                                  (indent-for-tab-command)
                                  (setq deactivate-mark nil)
                                  )
                                (recenter)
                                )
                )

;; Saveplace file
(setq save-place-file "~/.saveinfo")

;; subconfs
(require 'config-python)
(require 'config-go)
(require 'config-c)
(require 'config-d)
(require 'config-wm)
(require 'config-web)
(require 'config-mongo)
(require 'saveplace)

;; Possibly not provided configuration (in ~/.emacs.d/shadow)
(on-require 'config-sql)
(on-require 'config-postgre)
(on-require 'config-mongodb)

(on-require 'flycheck
            (dolist (hook flycheck-hooks)
              (add-hook hook
                        (lambda ()
                          (flycheck-mode t)
                          )
                        )
              )
            )


;; Try

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

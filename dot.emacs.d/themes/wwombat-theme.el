;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; by wacren_p
;;
;; 256 colors wombat theme
;; with buffer-menu colorization
;;

(deftheme wwombat "Custom theme wombat")

(let (
      (background "#151515")
      (foreground "#b0b0b0")

      (selection  "#253B76")

      (comment    "#909090")
      (gold	  "#c0bc6c")

      (red        "#e5786d")
      (orange     "#f1aa7e")
      (yellow     "#caeb82")
      (green      "#95e454")
      (cyan       "#78f2c9")
      (blue       "#87afff")
      )

  (progn
    (custom-theme-set-faces
     'wwombat

     '(default ((t (:inherit nil :stipple nil :background "#202020" :foreground "#b0b0b0" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "DejaVu Sans Mono"))))

     `(cursor ((t (:background "cyan"))))

     ;; Languages
     `(font-lock-builtin-face ((t (:foreground ,cyan))))
     `(font-lock-preprocessor-face ((t (:foreground ,red))))
     `(font-lock-constant-face ((t (:foreground ,red))))
     `(font-lock-function-name-face ((t (:foreground ,yellow))))
     `(font-lock-keyword-face ((t (:foreground ,blue :weight normal))))
     `(font-lock-string-face ((t (:foreground ,green))))
     `(font-lock-type-face ((t (:foreground ,yellow))))
     `(font-lock-variable-name-face ((t (:foreground ,orange))))

     ;; Comments
     `(font-lock-comment-delimiter-face ((t (:foreground ,gold))))
     `(font-lock-comment-face ((t (:foreground ,gold))))

     `(linum ((t (:foreground "#6B5B2C" :background "#111111"))))
     `(highlight ((t (:background "gray15" :height 1.0 :weight normal))))
     `(mode-line ((default (:foreground "#f6f3e8" :background "#444444"))))
     `(mode-line-inactive ((default (:foreground "#857b6f" :background "#333333"))))
     `(mouse ((t (:background "white"))))
     `(region ((t (:background ,selection))))
     `(vertical-border ((t (:foreground "black"))))
     `(minibuffer-prompt ((t (:foreground "#36b5b1"))))
     `(ac-completion-face ((t (:foreground "white" :underline t))))
     `(popup-isearch-match ((t (:background "sky blue" :foreground "red"))))
     `(semantic-tag-boundary-face ((t (:overline "#333333"))))
     `(font-lock-warning-face ((t (:foreground "#B34949" :weight normal :underline nil))))
     `(compilation-warning ((t (:foreground "#66D466" :weight normal :underline nil))))
     `(compilation-info ((t (:foreground "#79B379" :weight normal :underline nil))))
     `(flymake-errline ((t (:background nil :underline ,foreground))))
     `(flymake-warnline ((t (:background nil :underline ,foreground))))
     `(mumamo-background-chunk-major ((t (:background "#202020"))))
     `(mumamo-background-chunk-submode1 ((t (:background "gray10"))))
     `(mumamo-background-chunk-submode2 ((t (:background "gray10"))))
     `(mumamo-background-chunk-submode3 ((t (:background "gray10"))))
     `(mumamo-background-chunk-submode4 ((t (:background "gray10"))))
     `(ebrowse-root-class ((t (:foreground "#f1aa7e" :weight normal ))))
     `(ebrowse-member-class ((t (:foreground "#f1aa7e" :weight normal ))))

     `(buffer-menu-star-buffer ((t (:foreground ,comment :slant normal))))
     `(buffer-menu-buffer-name ((t (:foreground ,orange :weight normal))))
     `(buffer-menu-read-only-mark ((t (:foreground ,green))))
     `(buffer-menu-directory-buffer ((t (:foreground ,red :background nil))))

     `(buffer-menu-mode ((t (:foreground ,blue))))
     `(buffer-menu-file-name ((t (:foreground ,blue))))
     `(buffer-menu-modified-mark ((t (:foreground ,green))))
     `(buffer-menu-size ((t (:foreground ,blue))))

     `(diff-added ((t (:foreground "green"))))
     `(diff-removed ((t (:foreground "red"))))
     `(diff-changed ((t (:foreground "purple"))))
     `(which-func ((t (:foreground ,gold))))

     `(web-mode-html-tag-bracket-face ((t (:foreground ,foreground))))
     `(web-mode-html-attr-equal-face ((t (:foreground ,foreground))))
     `(web-mode-html-tag-face ((t (:foreground ,yellow))))
     `(web-mode-html-attr-name-face ((t (:foreground ,orange))))
     `(web-mode-doctype-face ((t (:foreground ,blue))))
     )

    (set-face-background 'default background)

    (setq buffer-menu-buffer-font-lock-keywords
          '(("^....[*]Man .*Man.*"   . font-lock-variable-name-face) ; Man page
            (".*Dired.*"             . font-lock-comment-face)       ; Dired
            ("^....[*]shell.*"       . font-lock-preprocessor-face)  ; shell buff
            (".*[*]scratch[*].*"     . font-lock-function-name-face) ; scratch buffer
            ("^....[*].*"            . font-lock-string-face)        ; "*" named buffers
            ("^..[*].*"              . font-lock-constant-face)      ; Modified
            ("^.[%].*"               . font-lock-keyword-face)))     ; Read only
    (defun buffer-menu-custom-font-lock  ()
      (let ((font-lock-unfontify-region-function
             (lambda (start end)
               (remove-text-properties start end '(font-lock-face nil)))))
        (font-lock-unfontify-buffer)
        (set (make-local-variable 'font-lock-defaults)
             '(buffer-menu-buffer-font-lock-keywords t))
        (font-lock-fontify-buffer)))
    )
)

(provide-theme 'wwombat)

;;EOF

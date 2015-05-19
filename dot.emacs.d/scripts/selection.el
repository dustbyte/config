;; Copyright (c) 2013, Pierre Wacrenier <mota@souitom.org>
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without modification,
;; are permitted provided that the following conditions are met:

;;   Redistributions of source code must retain the above copyright notice, this
;;   list of conditions and the following disclaimer.

;;   Redistributions in binary form must reproduce the above copyright notice, this
;;   list of conditions and the following disclaimer in the documentation and/or
;;   other materials provided with the distribution.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;; DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
;; ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
;; ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;;
;; Works on x11 windowing system (Linux, OpenBSD, FreeBSD, etc.)
;; as well as the Mac OS X and Windows operating systems.
;;
;; Allows to copy and paste the clipboard via Emacs
;; The goal of this script is to be able to work
;; with either a GUI or a terminal session of emacs
;; and interact with the graphical/windowing system.
;;
;; Unlinke xclip, section is not integrated within the kill-ring
;; in order to avoir both ring and clipboard pollution.
;;
;; The x11 version requires the `xclip' tool to be installed first
;;
;; Usage:
;; ;; In your init script
;; (add-to-list 'load-path "/directory/where/selection/resides")
;; (require 'selection)
;;
;; ;; Then you just bind functions to whichever shortcut you like
;; (global-set-key (kbd "C-c c") 'copy-to-clipboard)
;; (global-set-key (kbd "C-c v") 'paste-from-clipboard)
;;
;; ;; The primary selection is also available for x11 windowing system
;; (global-set-key (kbd "C-c w") 'copy-to-primary)
;; (global-set-key (kbd "C-c p") 'paste-from-primary)
;;


(defun system-copier (selection)
  "Tool function that selects a ``copier'' given the platform"
   (if (eq system-type 'darwin)
       (start-process "pbcopy" nil "pbcopy")
     (start-process "xclip" nil "xclip" "-selection" selection)
     )
   )

(defun to-selection (selection content)
  "Generic function that saves into the specified selection a content
given in parameter"
  (let* (
	 (process-connection-type nil)
	 (proc (system-copier selection))
	 )
    (process-send-string proc content)
    (process-send-eof proc)
    )
  )

(defun from-selection (selection)
  "Generic function that gets content from parametrized selection."
  (interactive "M")
  (if (eq system-type 'darwin)
      (shell-command-to-string "pbpaste")
    (shell-command-to-string (format "xclip -o -selection %s" selection))
    )
  )

(defun copy-to-selection (begin end selection)
  "Generic version of cut with parametrized selection target"
  (to-selection selection (buffer-substring-no-properties begin end))
  (keyboard-escape-quit)
  )

(defun cut-to-selection (begin end selection)
  "Generic version of cut with parametrized selection target"
  (to-selection selection (buffer-substring-no-properties begin end))
  (kill-region begin end)
)

(defun copy-to-clipboard (begin end)
  "Copy content from the current region and put it into the clipboard
selection"
  (interactive "r")
  (if (eq system-type 'windows-nt)
      (clipboard-kill-ring-save begin end)
    (copy-to-selection begin end "clipboard")
    )
)

(defun cut-to-clipboard (begin end)
  "Cut content from the region and paste it into the clipboard"
  (interactive "r")
  (if (eq system-type 'windows-nt)
      (clipboard-kill-region-save begin end)
    (cut-to-selection begin end "clipboard")
    )
  )

(defun copy-to-primary (begin end)
  "Copy characters from region and put them into the primary
selection (X11 only)"
  (interactive "r")
  (copy-to-selection begin end  "primary")
)

(defun cut-to-primary (begin end)
  "Cut selected text form the region (i.e. kill the region) and put
its content into the primary selection."
  (interactive "r")
  (cut-to-selection begin end  "primary")
)

(defun paste-from-clipboard ()
  "Insert into the buffer at current point the content of the
clipboard selection (X11, Mac OS X, Windows)"
  (interactive)
  (if (eq system-type 'windows-nt)
      (clipboard-yank)
    (insert (from-selection "clipboard"))
    )
)

(defun paste-from-primary ()
  "Insert into the buffer at current point the content of the primary
selection (X11 only)"
  (interactive)
  (insert (from-selection "primary"))
)

(provide 'selection)

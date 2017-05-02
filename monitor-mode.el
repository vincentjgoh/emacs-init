;; Monitor mode
(defface monitor-font-lock-error-face '((t (:foreground "red" :bold t :height 1.3))) "Monitor Error Face")
(defface monitor-font-lock-success-face '((t (:foreground "green" :bold t :height 1.3))) "Monitor Success Face")
(defface monitor-font-lock-info-face '((t (:foreground "yellow" :background "black" :bold t))) "Monitor Info Face")
(defface monitor-font-lock-section-face '((t (:foreground "DarkOrchid1" :bold t :height 1.3))) "Section Info Face")
(defface monitor-font-lock-timestamp-face '((t (:foreground "DarkOrange1" :bold t ))) "Section Timestamp Face")

(defvar monitor-info-keywords
  '("unresolved"
    "externals"
    "scimitar"
    "Scimitar"
    "anvil"
    "Anvil"
    "engine"
    "Engine"
    "tool"
    "GuildLib"
    "link"
    "sync"
    "Syncing"
    "code"
    "Tool"
    "sharpmake"
    "moldmake"
    "zenmake"))

(defconst monitor-mode-font-lock-keywords
  (list
   (cons ".*succeeded.*" ''monitor-font-lock-success-face)
   (cons "\\(.*errors.*\\)" ''monitor-font-lock-error-face)
   (cons "\\(?:first\\)" ''monitor-font-lock-info-face)
   (cons "\\(?:second\\)" ''monitor-font-lock-info-face)
   (cons "\\(?:failed\\)" ''monitor-font-lock-error-face)
   (cons "\\(\@[0-9]*\\)" ''monitor-font-lock-info-face)
   (cons "\\*\\*-.*" ''monitor-font-lock-section-face)
   (cons "[0-9]+:[0-9]+:[0-9]+" ''monitor-font-lock-timestamp-face)
   `( ,(concat "\\<" (regexp-opt monitor-info-keywords) "\\>") . 'monitor-font-lock-info-face)
   ))

(define-derived-mode monitor-mode fundamental-mode "Monitor"
  "Monitor Mode"
  (set (make-local-variable 'font-lock-defaults) '(monitor-mode-font-lock-keywords))
  (set (make-local-variable 'font-lock-string-face) nil))

(provide 'monitor-mode)

(defun print-to-compilation-monitor (msg &optional timestamp)
  (interactive "sMessage: \n")

  (let ((prev-frame (selected-frame)))
    (if (not (find-frame-by-name "COMPILATION MONITOR" t))
        (let ((new-frame (make-frame '((name . "COMPILATION MONITOR")
                                       (width . 164)
                                       (height . 30)
                                       (minibuffer . nil)
                                       (font . "-outline-Gill Sans MT-bold-normal-normal-sans-11-*-*-*-p-*-iso8859-1")
                                       (background-color . "black")
                                       (foreground-color . "SteelBlue3")
                                       (top . 694)
                                       (left . 1913)
                                       (menu-bar-lines 0)))))
          (progn
            (message "Selecting new frame")
            (select-frame new-frame t)
            ;; The *monitor* buffer is either acquired or created if it doesn't already exist, and dedicated
            ;; to the compilation frame.
            ;;(dedicate-window (display-buffer-use-some-frame (get-buffer-create "*monitor*") '((name . "COMPILATION MONITOR"))) t )
            (display-buffer (get-buffer-create "*monitor*") nil new-frame)
            (delete-other-windows (get-buffer-window "*monitor*"))
            (monitor-mode)
            (setq window-size-fixed t)
            (set-window-dedicated-p (get-buffer-window "*monitor*") t)
            (modify-frame-parameters new-frame '((width . 164) (top . 694)))
            (delete-other-windows (get-buffer-window "*monitor*"))
            (select-frame prev-frame t)
            ))
      ))

  (with-current-buffer "*monitor*"
    (progn
      (goto-char (point-max))
      (if timestamp
          (insert (concat msg " " (format-time-string "%I:%M:%S\n")))
        (insert msg) )
      ))

  (with-selected-frame (find-frame-by-name "COMPILATION MONITOR" t)
    (goto-char (point-max)))

    )

(defun close-compilation-monitor ()
  (interactive)
  "If it exists, destroy the compilation monitor."
  (condition-case nil
      (progn
        (select-frame-by-name "COMPILATION MONITOR")
        (delete-frame))
    (error t)))

(add-hook 'kill-emacs-hook 'close-compilation-monitor)

;;(run-at-time "1 sec" 600 (lambda () (print-to-compilation-monitor "-------------------- " t)))
;;(print-to-compilation-monitor ";; This buffer displays the current status of any compilations")

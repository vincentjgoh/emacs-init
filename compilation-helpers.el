(defvar build-list-alist nil
  "Global build queue")
(defvar pause-build-queue nil
  "Global flag for pausing the build queue")

;; Builds that end in errors stay active as a compilation process.
(defvar build-stopped-from-errors nil
  "Flag that the last time the build finished, it was with errors")

(defface compilation-boundary-face '((t (:foreground "pink" :bold t :height 1.2))) "Compilation Boundary Face")
(defface compilation-exit-code-face '((t (:foreground "green" :background "black" :bold t))) "Compilation Exit Code Face")
(defface compilation-exit-code-error-face '((t (:foreground "red" :background "black" :bold t))) "Compilation Exit Code Error Face")
(defface compilation-deoptimized-face '((t (:foreground "green" :italic t))) "Compilation Deoptimized Face")
(defface compilation-final-time-face '((t (:foreground "DarkOrange1" :bold t :height 2.0))) "Compilation Final Time Face")

(font-lock-add-keywords 'compilation-mode '( ("\\([a-zA-Z0-9_]+\\.\\)+\\(zen\\|cpp\\|h\\|mold\\|sc\\)\\b" . font-lock-variable-name-face) ))
(font-lock-add-keywords 'compilation-mode '( (".*exit code.*" . 'compilation-exit-code-face) ))
(font-lock-add-keywords 'compilation-mode '( ("^---.*" . 'compilation-boundary-face) ))
(font-lock-add-keywords 'compilation-mode '( (".*Deoptimized.*" . 'compilation-deoptimized-face )))
(font-lock-add-keywords 'compilation-mode '( ("^Time:.*" . 'compilation-final-time-face )))

(require 'compile)

(pushnew '(csharp
     "^ *\\(?:[0-9]+>\\)*\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\),\\([0-9]+\\),\\([0-9]+\\),\\([0-9]+\\)) *\: \\(error\\|warning\\) *CS[0-9]+:"
     1 (2 . 4) (3 . 5) nil )
         compilation-error-regexp-alist-alist)

(pushnew '(zen
     "^ *\\(?:[0-9]+>\\)*\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\),\\([0-9]+\\)) ?\: \\(?:error\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
     1 2 3 (4) 2)
         compilation-error-regexp-alist-alist)

(defun compile-hooks ()
;;  (setq global-semantic-idle-scheduler-mode nil)
;;  (setq semantic-idle-work-parse-neighboring-files-flag nil)
;;  (setq semantic-idle-work-update-headers-flag nil)
  )

(defun add-to-build-queue ( function &optional preserve-list)
  "Add more build commands to the queue. It's not necessary that the list is running."
  (interactive "aFunction Name: ")

  (if build-list-alist
      ;; if the incoming function is itself a list that we don't care to preserve the structure of, add it
      (if (and (listp function) (not preserve-list))
          (setq build-list-alist (append build-list-alist function))
        ;; otherwise, it's either a single item, or it's a list that should be treated as a single item
        (add-to-list 'build-list-alist function t))
    ;; else, there's nothing in the build queue yet
    (if (and (listp function) (not preserve-list))
        ;; if the incoming function is a list already and we don't want to preserve the structure
        (setq build-list-alist function)
      ;; otherwise it's a single item, and again, we want to preserve the structure
      (setq build-list-alist (list function))) )
  )

(defun is-compilation-active ()
  "Actually determines if a compilation is
  active. compilation-in-progress returns t if a previous
  compilation finished but there were errors, so we have to
  account for that with our own monitoring variable."
  (if build-stopped-from-errors
      (print-to-compilation-monitor "Un-caught build errors. Stopping.\n")
    (if (and (boundp 'compilation-in-progress) compilation-in-progress)
        (print-to-compilation-monitor "Compile still running?\n")))

  (if build-stopped-from-errors
      nil
    (if (and (boundp 'compilation-in-progress) compilation-in-progress)
        t
      nil))
  )

(defun force-clear-build-queue ()
  (interactive)
  "Reset compilation-in-progress variable and clear the build queue."
  (setq print-to-compilation-monitor nil)
  (setq build-list-alist nil) )

(defun start-build-queue()
  "Start an inactive build queue"
  (interactive)

  (print-to-compilation-monitor "\n**---------------------------------------------------------------Starting Build Queue--------------------------------------------------------------**\n")

  (if (and build-list-alist (not (is-compilation-active)))
      ;; There are things in the list
      (progn
        (setq pause-build-queue nil)
        (setq build-stopped-from-errors nil)
        (let ((queue-len (length build-list-alist)))
          (if (> queue-len 1)
              (print-to-compilation-monitor (format "\n%d items are pending." (- queue-len 1)) t )
            (print-to-compilation-monitor "\nQueue Empty.\n")))
        (if (listp (car build-list-alist))
            ;; The first thing in the list is itself a list. Use apply instead of funcall.
            ;; the backtick-comma syntax quotes the list returned by the cdr-car
            (progn (apply (caar build-list-alist) `,(cdar build-list-alist))
                   (pop build-list-alist))
          ;; The next thing on the list is just a function call. Use it.
          (progn (message "funcall pop build-list-alist")
                 (funcall (pop build-list-alist)) ))
        )
    ))

(defun pause-build()
  "Pause the build queue after the next item is finished."
  (interactive)
  (setq pause-build-queue t)
  )

(defun clear-build-queue()
  "Empty the build queue. Does not cancel any running builds."
  (interactive)
  (setq build-list-alist nil)
  )

(defun send-invisible-to-compilation()
  "Send a signal to the current compilation"
  (interactive)
  (if (get-process "compilation")
      (comint-simple-send (get-process "compilation") ""))
  )

(defun find-compilation-frame ()
  (setq compilation-frame-list (frame-list))
  (while compilation-frame-list
    (setq tmp-compilation-frame (pop compilation-frame-list))
    (if (string-match "*compilation*" (frame-parameter tmp-compilation-frame 'name))
        (setq compilation-frame-list nil)
      (setq tmp-compilation-frame)))
  tmp-compilation-frame)

(add-to-list 'display-buffer-alist
             '("^\\*compilation\\*" . ((display-buffer-reuse-window
                                        display-buffer-pop-up-frame) .
                                        ( (reusable-frames . t)
                                          (inhibit-same-window . nil)
                                          ))))

(defun kill-all-compilation ()
  (interactive)
  "Kill the current compilation and make sure the compilation
queue is empty."
  (setq build-list-alist nil)
  (kill-compilation)
  (setq assassin-project-generation-done nil)
  )


(defun print-remaining-build-queue()
  (let ((tmp-bq build-list-alist)
        (queue-msg "Next: ")
        (first t))
    (while tmp-bq
      (progn
        (setq queue-msg (concat queue-msg (format "%s " (pop tmp-bq))))
        (if (and first tmp-bq)
            (progn
              (setq queue-msg (concat queue-msg (format "\n%d remaining: " (length tmp-bq))))
              (setq first nil)
              ))
        ))
    (print-to-compilation-monitor queue-msg)
    (print-to-compilation-monitor "\n")
    )
)

(defun compile-finished-hooks (buf exitmsg)
  "When a compile finishes, check if there are any build
errors. If there are, play the error sound and reset the build
list.  If there were no errors and there are still builds left in
the queue, start the next build. If there are no builds left, run
the post-build teardown."
  (goto-char (point-max))

  (save-excursion
    (if (or (search-backward "error 0x2" nil t)
            (search-backward "generation errors" nil t 1)
            (search-backward "parser errors" nil t 1)
            (search-backward "BUILD FAILED" nil t 1)
            (search-backward "Errors detected" nil t 1)
            )

        ;; Not a good thing to search for anymore.
        ;;             (search-backward "failed" nil t 1 )

        (progn (parse-messages-on-compile-exit buf exitmsg)
               (setq build-stopped-from-errors t)
               (print-to-compilation-monitor (format "Compile aborted with %d items left to process.\n" (length build-list-alist)) )
               (setq build-list-alist nil))
      ;; else
      (if (and build-list-alist (not pause-build-queue))
          ;; There are things in the list, and we're not attempting to pause the build queue.
          (progn
            (print-to-compilation-monitor (format "\n%d items are pending." (length build-list-alist)) t )
            (print-remaining-build-queue)
            (setq compilation-in-progress nil)
            (if (listp (car build-list-alist))
                ;; The first thing in the list is itself a list. Use apply instead of funcall.
                ;; the backtick-comma syntax quotes the list returned by the cdr-car
                (progn (apply (caar build-list-alist) `,(cdar build-list-alist))
                       (pop build-list-alist))
              ;; The next thing on the list is just a function call. Use it.
              (funcall (pop build-list-alist)) ))

        (progn
          (parse-messages-on-compile-exit buf exitmsg)
          (setq semantic-idle-work-parse-neighboring-files-flag 1)
          (setq semantic-idle-work-update-headers-flag 1)
          (setq assassin-project-generation-done nil)

          ;; Find the compilation frame and delete it if the compile was successful.
          (if (string= "finished\n" exitmsg)
              (progn
                (message "No errors")
                (let ((my-frame-list (frame-list)))
                  (while my-frame-list
                    (setq frame-var (pop my-frame-list))
                    (if (string-match "*compilation*" (frame-parameter frame-var 'name))
                        (progn
                          (message "Found compilation frame")
                          (delete-frame frame-var))
                      )))
                )))
        ))
    )
  (if (get-buffer "scimitar-output.txt")
      (kill-buffer "scimitar-output.txt"))
  )

(defun start-or-add-item-to-compile (function)
  "Add a command to the build queue. If the queue is empty and there's nothing else running, start the compilation."

  (add-to-build-queue function)
  (start-build-queue))

(defun play-finish-sound ()
  (set-message-beep 'asterix)
  (beep)
  (beep)
  (beep)
  (set-message-beep 'exclamation)
)

(defun play-error-sound ()
  (set-message-beep 'hand)
  (beep)
  (beep)
  (beep)
  (set-message-beep 'exclamation)
)

(defun parse-messages-on-compile-exit (buf exitmsg)
  (display-buffer buf)
  (goto-char (point-max))
  (if (or (search-backward "error 0x2" nil t)
          (search-backward "generation errors" nil t 1)
          (search-backward "parser errors" nil t 1)
          (search-backward "BUILD FAILED" nil t 1)
          (search-backward "Errors detected" nil t 1)
          )

      ;; Not useful anymore?
      ;;           (search-backward "failed" nil t 1)

      ;; THEN
      ;; Found an error. Can we identify it more specifically?
      (progn
        (goto-char (point-max))
        (if (or (search-backward "LNK1168" nil t)
                (search-backward "LNK1104" nil t))
            (print-to-compilation-monitor "Build failed to link. Is the target still running?" t)
          (if (or (search-backward "LNK1120" nil t 1)
                  (search-backward "LNK2019" nil t 1))
              (print-to-compilation-monitor "Build failed to link: unresolved externals" t)
            (print-to-compilation-monitor "Compilation failed" t)))
        (play-error-sound))

    ;; ELSE
    ;; The exit message is 'finished', so we assume that there was a successful compile.
    (if (string= "finished\n" exitmsg)
        (progn (play-finish-sound)
               (print-to-compilation-monitor "**------------------------------------------------------------Compilation succeeded----------------------------------------------------------**\n" t))
      ;; The exit message is something other than 'finished', so we failed I guess?
      (progn (play-error-sound)
             (print-to-compilation-monitor (concat "**--- Compilation failed: " exitmsg "\n") t))
      )
    )
  )

;; Switch to the compilation window, wherever we are.
(defun switch-to-compilation-window ()
  (interactive)

  ;; If we're not currently in the compilation buffer, store away what buffer we're in.
  ;; If we are in the compilation buffer, go back to the previous buffer, if it exists.
  (if (not (eq (current-buffer) (get-buffer "*compilation*")))
      (progn
        (setq prev-buffer (current-buffer))

        ;; Switch to the compilation buffer if it exists.
        (if (get-buffer-window "*compilation*" 0)
            (switch-to-buffer-other-frame "*compilation*")))

    ;;(if (not (eq prev-buffer nil))
    ;;(switch-to-buffer-other-frame prev-buffer))
    )
  )

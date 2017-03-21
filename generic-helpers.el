(defun find-frame-by-name (frame-name)
  "Find any frame by partial or complete name."
  (let ((my-frame-list (frame-list))
        (prospective-frame nil))
    (while my-frame-list
      (setq prospective-frame (pop my-frame-list))
      (if (string-match frame-name (frame-parameter prospective-frame 'name))
          (progn (setq my-frame-list nil)
                 (message (concat "Found frame matching " frame-name)))
        (setq prospective-frame nil)
        ))
    prospective-frame)
  )

(defun find-buffer-by-name (buffer-name)
  "Find any buffer by partial or complete name."
  (let ((my-buffer-list (buffer-list))
        (prospective-buffer nil))
    (while my-buffer-list
      (setq prospective-buffer (pop my-buffer-list))
      (if (string-match buffer-name (buffer-name prospective-buffer))
          (progn (setq my-buffer-list nil)
                 (message (concat "Found buffer matching " buffer-name)))
        (setq prospective-buffer nil)
        ))
    prospective-buffer)
  )

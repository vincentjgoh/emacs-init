; ;; Semantic, ECB, Speedbar, P4, gtags, etc.
;; --------------------------------------------------------------------------------
(load-library "p4")
(setq load-path (cons "d:/Utilities/emacs-24.5/share/emacs/25.0.50/lisp/" load-path))
(setq load-path (add-to-list 'load-path "~/../site-lisp/wl/"))
(setq load-path (add-to-list 'load-path "d:/Utilities/emacs-24.5/share/emacs/site-lisp/"))
(add-to-list 'load-path "d:/home/")
(setenv "P4CLIENT" "jgoh_MTL-BE471")

(setq debug-on-error nil)
;; --------------------------------------------------------------------------------

;; --------------------------------------------------------------------------------
;; Package
(require 'package)
(add-to-list 'package-archives
            '("melpa-stable" . "http://stable.melpa.org/packages/") t )
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t )
;; (add-to-list 'package-archives
;;              '("marmalade" . "https://marmalade-repo.org/packages/") t )
;;(add-to-list 'package-archives
;;             '("Sunrise" . "http://joseito.republika.pl/sunrise-commander/") t )

;; Disable auto package init and manually init them so that we can configure them here instead of
;; waiting for later.
(setq package-enable-at-startup nil)
(package-initialize)

(autoload 'powershell "powershell" "Run powershell as a shell within emacs." t)

;; Environment setup --------------------------------------------------------------------------------
(setenv "SHELL" "d:/Utilities/cygwin-64/bin/bash.exe")
(setenv "PATH" "c:/Windows/System32;c:/ubiperl/script;c:/Perl/bin;c:/Windows/System32/WindowsPowerShell/v1.0;")
(setenv "PATH" (concat (getenv "PATH") "d:/Utilities/cygwin-64/bin;d:/Utilities/gnuwin/bin;~/bin;d:/Utilities/emacs-24.5/bin;d:/Utilities/Everything;d:/Utilities/gnuGlobal/bin;d:/Utilities/sift;d:/Utilities/emacs-24.5/libexec/emacs/25.0.50/x86_64-w64-mingw32;d:/Utilities/Elevate;"))
(setenv "MANPATH" "d:/Utilities/cygwin-64/usr/man/")
(setenv "GTAGSFORCECPP" "")
(setq exec-path (append exec-path '("d:/Utilities/cygwin-64/bin")))
(setq exec-path (append exec-path '("d:/Utilities/Everything")))
(setq exec-path (append exec-path '("d:/Utilities/Elevate")))
(setq exec-path (append exec-path '("d:/Utilities/gnuwin/bin")))
(setq exec-path (append exec-path '("d:/Utilities/gnuGlobal/bin")))
(setq exec-path (append exec-path '("d:/Utilities/emacs-24.5/bin")))
(setq exec-path (append exec-path '("d:/Utilities/sift")))
(setq exec-path (append exec-path '("d:/Utilities/emacs-24.5/libexec/emacs/25.0.50/x86_64-w64-mingw32")))
(setq exec-path (append exec-path '("c:/Windows/System32/WindowsPowerShell/v1.0")))

;; --------------------------------------------------------------------------------
;; Special config files
;; --------------------------------------------------------------------------------
(load-file "d:/home/.emacs.d/generic-helpers.el")
(load-file "d:/home/.emacs.d/compilation-helpers.el")
(load-file "d:/home/.emacs.d/monitor-mode.el")
(load-file "d:/home/.emacs.d/special-modes.el")
(load-file "d:/home/.emacs.d/assassin-config.el")
(require 'monitor-mode)
;; --------------------------------------------------------------------------------

;; GNU Global Tags and Helm --------------------------------------------------------------------------------
(require 'ggtags)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (helm-gtags-mode 1))))

(define-key ggtags-mode-map (kbd "M-.") 'helm-gtags-dwim)

;; Anything-Helm
;;(add-to-list 'load-path "d:/Utilities/emacs/lisp/helm")
(require 'helm-config)
(require 'helm-grep)
(require 'helm-swoop)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
;; helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
(add-hook 'helm-gtags-mode 'helm-gtags-mode-hook)
(add-hook 'helm-after-initialize-hook (lambda ()
                                        (with-helm-buffer
                                          (visual-line-mode))))

(add-hook 'helm-gtags-mode-hook (lambda()
                                  (local-set-key (kbd "M-.") 'helm-gtags-dwim)
                                  (local-unset-key (kbd "C-t"))))




(require 'everything)
;; GNU Global Tags and Helm ENDS --------------------------------------------------------------------------------

;; Company mode --------------------------------------------------------------------------------
(require 'company)

;; Powerline
(powerline-center-theme)

;; Other packages
(eval-after-load "menu-bar" '(require 'menu-bar+))

;; Tool-bar+
(require 'tool-bar+)

;; (setq process-coding-system-alist (cons '("bash" . (raw-text-unix . raw-text-dos))
;;                                     process-coding-system-alist))
;;(setenv "SHELL" "c:/Windows/System32/cmdproxy.exe")
;;(setq shell-file-name "cmdproxy.exe")
;;(setq shell-command-switch "/c")

(setq using-unix-filesystems t)
(setq shell-file-name "cmdproxy")
(setq explicit-shell-file-name "bash.exe")
(setq shell-command-switch "/C")
(setq archive-zip-use-pkzip nil)
;;(setq w32-quote-process-args ?\")
(setq w32-enable-italics t)
(setq comint-process-echoes nil)

;; commenting test starts --------------------------------------------------------------------------------
(setq default-major-mode 'text-mode)
(setq font-lock-maximum-decoration '((c-mode . 3) (c++-mode . 3)))
(font-lock-mode t)
(setq font-lock-maximum-size 2097152)
(setq default-fill-column 100)

(setq line-number-mode t)
(setq show-paren-mode t)
(setq selective-display 3) ;; <<==== ?
(put 'scroll-left 'disabled nil)

(setq create-lockfiles nil)

(require 'bookmark+)
(require 'dedicate-windows-manually)
;; commenting test ends --------------------------------------------------------------------------------
;; Environment setup ENDS --------------------------------------------------------------------------------

;; Environment setup ENDS

(defun coding-hooks ()
  (setq c-basic-offset 4)
  (setq-default tab-width 4)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'brace-list-open 0)
  (c-set-offset 'block-open 0)
  (c-set-offset 'class-open 0)
  (c-set-offset 'inline-open 0)
  (c-toggle-hungry-state 1)
  (local-set-key "\M-a" 'paren-backward-sexp)
  (local-set-key "\M-e" 'paren-forward-sexp)
  (local-set-key "\C-\M-h" 'hs-hide-all)
  (local-set-key "\M-o" 'ff-find-other-file)
  (local-set-key "\C-t" 'transpose-chars)
  (hs-minor-mode t)
  (abbrev-mode 0)
  (company-mode t)
  (add-hook 'before-save-hook 'coding-system-hook)
  (column-enforce-mode t)
  )

(defun c-sharp-hook ()
  (setq hs-isearch-open t)
  (company-mode t)
)

(defun coding-system-hook ()
  (set-buffer-file-coding-system 'dos)
)

;; Hooks to untabify and tabify files on entry and exit.
(defun c++-mode-untabify ()
  (interactive)
  (if (and (file-writable-p (buffer-file-name))
		   (string= (substring mode-name 0 3) "C++") )
	  (save-excursion
		(delete-trailing-whitespace)
		(untabify (point-min) (point-max)))))

(defun c++-mode-tabify ()
  (interactive)
  (if (and (file-writable-p (buffer-file-name))
           (string= (substring mode-name 0 3) "C++") )
      (save-excursion
        (delete-trailing-whitespace)
        (tabify (point-min) (point-max)))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'c-mode-common-hook 'ACE-macros-update)
(add-hook 'c++-mode-hook 'coding-hooks)
(add-hook 'c-mode-hook 'coding-hooks)
(add-hook 'csharp-mode-hook 'coding-hooks)
(add-hook 'csharp-mode-hook 'c-sharp-hook)
(add-hook 'mold-mode-hook 'coding-hooks)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'font-lock-mode)
(add-hook 'c-mode-hook 'font-lock-mode)
(add-hook 'csharp-mode-hook 'font-lock-mode)
(add-hook 'mold-mode-hook 'font-lock-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'emacs-lisp-mode-hook 'font-lock-mode)
(add-hook 'org-mode-hook (lambda() (auto-fill-mode -1)
                           (visual-line-mode t)))

(add-hook 'pre-command-hook
          (lambda ()
            (when (eq major-mode 'p4-mode)
              p4-operation-hook)
            ) )
;;(add-hook 'compilation-mode-hook 'compile-hooks)


(setq compilation-finish-functions 'compile-finished-hooks)

(defadvice p4-edit (before p4-location-validation activate)
  "Runs before checking out files from perforce so the file is checked out from the correct repository."
  (p4-operation-hook) )

(defadvice p4-add (before p4-location-validation activate)
  "Runs before checking out files from perforce so the file is checked out from the correct repository."
  (p4-operation-hook) )

(defadvice p4-revert (before p4-location-validation activate)
  "Runs before checking out files from perforce so the file is checked out from the correct repository."
  (p4-operation-hook) )

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.inl\\'" . c++-mode))


;; Ivy
(require 'ivy)
(ivy-mode 1)

;; All the Icons
(require 'all-the-icons)

;; mic-paren
(require 'mic-paren)
(paren-activate)

;; Frame setup
(setq default-frame-alist
      (append default-frame-alist
              '( (top . 30) (left . 340)
                 (width . 150) (height . 80)
                 (cursor-type . box)
                 (cursor-color . "green")
                 (foreground-color . "cyan")
                 (background-color . "navyblue")
                 (font . "-*-Consolas-normal-r-semicondensed--11-*-*-*-c-*-iso8859-1")
                 ;;(font . "-*-Consolas-normal-r-semicondensed--12-*-*-*-c-*-iso8859-1")
                 )))

(setq initial-frame-alist
      '( (top + -354) (left . -1208)
         (width . 168) (height . 132)
         (cursor-type . box)
         (cursor-color . "green")
         (foreground-color . "cyan")
         (background-color . "navyblue")
         (font . "-*-Consolas-normal-r-semicondensed--12-*-*-*-c-*-iso8859-1")
         ))

(add-hook 'after-make-frame-functions 'j-after-make-frame)
(defun j-after-make-frame (frame)
  (if (string-match "*compilation*" (frame-parameter frame 'name))
      (modify-frame-parameters frame '((font . "-outline-Gill Sans MT-normal-normal-normal-sans-11-*-*-*-p-*-iso8859-1")
                                       (title . "COMPILATION")
                                       (fullscreen . t)))))

;; Faces/font-lock
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(alert-low-face ((t (:foreground "coral"))))
 '(alert-trivial-face ((t (:foreground "brown"))))
 '(column-enforce-face ((t (:underline t :weight bold))))
 '(compilation-error ((t (:inherit error))))
 '(fa-face-hint ((t (:background "black" :foreground "red"))))
 '(fa-face-hint-bold ((t (:background "navyblue" :weight bold))))
 '(fa-face-semi ((t (:background "black" :foreground "green" :weight bold))))
 '(fa-face-type ((t (:inherit (quote font-lock-type-face) :foreground "red" :background "navyblue"))))
 '(fa-face-type-bold ((t (:inherit (quote font-lock-type-face) :foreground "red" :background "navyblue" :bold t))))
 '(font-lock-builtin-face ((nil (:background "black" :foreground "cyan"))))
 '(font-lock-comment-delimiter-face ((default (:inherit font-lock-comment-face)) (((class color) (min-colors 16)) nil)))
 '(font-lock-comment-face ((t (:foreground "red" (background light)))))
 '(font-lock-constant-face ((nil (:background "black" :foreground "green"))))
 '(font-lock-function-name-face ((nil (:foreground "green" :box (:line-width 1 :color "grey75" :style released-button)))))
 '(font-lock-keyword-face ((nil (:background "black" :foreground "red"))))
 '(font-lock-string-face ((nil (:background "black" :foreground "magenta"))))
 '(font-lock-type-face ((nil (:background "black" :foreground "yellow"))))
 '(font-lock-variable-name-face ((nil (:foreground "magenta"))))
 '(font-lock-warning-face ((((class color) (background light)) (:bold nil :foreground "white" :background "black"))))
 '(ggtags-highlight ((t (:background "black" :foreground "yellow" :underline t))))
 '(hl-line ((t (:box (:line-width 2 :color "grey75" :style released-button)))))
 '(log4j-font-lock-debug-face ((t (:foreground "Gray45" :weight bold))))
 '(mode-line ((t (:background "black" :foreground "green"))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button)))))
 '(mode-line-inactive ((t (:background "grey40" :foreground "yellow"))))
 '(my-long-line-face ((default (:background "black" :weight bold)) (nil nil)) t)
 '(paren-face-match ((((class color)) (:foreground "white" :background "purple"))))
 '(powerline-active2 ((t (:inherit sml/global :background "red4"))))
 '(senator-momentary-highlight-face ((((class color) (background light)) (:background "black"))))
 '(speedbar-highlight-face ((((class color) (background light)) (:foreground "green" :background "black"))))
 '(vhdl-font-lock-attribute-face ((((class color) (background light)) nil)))
 '(vhdl-font-lock-clock-signal-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-control-signal-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-data-signal-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-prompt-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-reset-signal-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-test-signal-face ((((class color) (background light)) (:foreground "Blue"))))
 '(vhdl-font-lock-value-face ((((class color) (background light)) (:bold nil :foreground "Blue")))))

(font-lock-add-keywords nil '(("\\<\\(FIXME\\):" 1 '(:foreground "blue") t)))


;; Function definitions start
;;---------------------------------------------------------------------------------------------------------------------------------

(defun set-ecb-vc-mode ()
  (setq vc-delete-logbuf-window nil)
  )

(defun reload-buffer ()
  "Reload the current buffer."
  (interactive)
  (revert-buffer nil t)
  )

(defun window-back ()
  "Like other window, but with a negative arg."
  (interactive)
  (other-window -1)
)

(defun set-project-grep-path (dir)
  "Update the project-grep-path variable"
  (interactive
   "DDirectory: ")
   (setq project-grep-path dir) )

(defun Jinteractive-project-search (dir filter)
  (interactive
   "DFind in directory: \nsFile type filter: ")
  (internal-project-search dir (list filter)))

(defun internal-project-search (dir filter)
  (helm-do-grep-1 (list dir) '(4) nil filter) )


(defun optimize-off ()
  "Insert pragma directives at the top and bottom of a file to disable optimization"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (insert "#pragma optimize(\"\",off)\n")
    (end-of-buffer)
    (insert "\n#pragma optimize(\"\",on)")
))

(defun kill-all-buffers (&optional list)
  "For each buffer in LIST, kill it. If it's been modified don't do anything.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           (/= (aref name 0) ? )
           (if (not (buffer-modified-p buffer)) t )
           (kill-buffer buffer)))
    (setq list (cdr list))))

(defun reload-all-buffers (&optional list)
  "For each buffer in LIST, reload it. If it's been modified don't do anything.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           (/= (aref name 0) ? )
           (if (not (buffer-modified-p buffer)) t )
           (revert-buffer buffer t)
           (message "Buffer %s reverted\n" name))
      )
    (setq list (cdr list))))

(defun fizz-buzz (n)
  "Prints numbers from n to 1. If the number is a multiple of 3
it relpaces it with 'Fizz'; if it's a multiple of 5, it's
replaced with 'Buzz'. Multiples of both are replaced with
'FizzBuzz'."
  (interactive)
  (if (= n 0)
      nil
    (if (and (= (% n 3) 0) (= (% n 5) 0))
        (insert "FizzBuzz\n")
      (if (= (% n 3) 0 )
          ( insert "Fizz\n" )
        (if (= (% n 5) 0)
            (insert "Buzz\n")
          (print (format "%d" n) ) ) ) )
    (fizz-buzz (- n 1) ) )
)

(defun raise-all-frames ()
  "Raise every frame."
  (interactive)
  (setq raiselist (frame-list))
  (while raiselist
    (raise-frame (car raiselist))
    (setq raiselist (cdr raiselist))))

(defun get-current-file-name ()
  "Copy the full path of the current file name into the kill ring."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name))
)

;; Sources can be things like helm-source-locate, etc.
(defun show-related-files ()
  "Show all files related to this one, based on the name before the extension."
  (interactive)
  (require 'helm-files)
  (helm :sources helm-for-files-preferred-list
        :input (file-name-sans-extension (buffer-name))
        :buffer "*helm related*" ))

;; Function definitions End
;;---------------------------------------------------------------------------------------------------------------------------------

; ;; Key bindings. --------------------------------------------------------------------------------

;; Generic
;; Unset
(global-unset-key "\C-xb")
(global-unset-key "\C-\\")
(global-unset-key "\M-.")

(global-set-key "\M-a" 'paren-backward-sexp)
(global-set-key "\M-e" 'paren-forward-sexp)
(global-set-key "\C-xg" 'goto-line)
(global-set-key "\C-c-\C-c" 'comment-region)
(global-set-key "\C-h" 'backward-delete-char-untabify)
(global-set-key "\C-xl" 'recenter)
(global-set-key "\C-l" 'count-lines-page)
(global-set-key "\C-xr" 'replace-string)
(global-set-key "\C-z" 'fill-paragraph)
(global-set-key "\C-xz" 'iconify-frame)
(global-set-key "\M-i" 'iconify-frame)
(global-set-key "\M-t" 'toggle-read-only)
(global-set-key "\C-\M-r" 'reload-buffer)
(global-set-key "\M-\C-n" 'narrow-to-defun)
(global-set-key "\M-\C-w" 'widen)
(global-set-key "\C-xaa" 'align-entire)
(global-set-key "\C-x\M-n" 'insert-note)
(global-set-key "\C-xcw" 'overwrite-mode)
(global-set-key "\C-xw" 'append-next-kill)
(global-set-key "\M-r" 'show-related-files)
;;(global-set-key "\C-xcc" 'switch-to-compilation-window)
(global-set-key "\C-x\C-f" 'counsel-find-file)

;; Hide-show
(global-set-key "\M-s" 'hs-show-block)
(global-set-key "\M-h" 'hs-hide-block)
(global-set-key "\C-\M-h" 'hs-hide-all)
(global-set-key "\C-\M-s" 'hs-show-all)
(global-set-key "\C-\M-t" 'hs-toggle-hiding)

;; Helm
(global-set-key "\C-x\C-b" 'helm-mini)
(global-set-key "\C-xf" 'helm-for-files)
;;(global-set-key "\M-\C-f" 'helm-gtags-find-files)
;;(global-set-key "\C-x\M-." 'helm-gtags-select)
;;(global-set-key "\C-xi" 'helm-semantic-or-imenu)
(global-set-key "\C-x\C-o" 'helm-occur)
(global-set-key "\M-y" 'helm-show-kill-ring)

;; Tags, semantic, etc.
;;(global-set-key "\C-x\C-e" 'fa-show)
(global-set-key "\C-x\M-t" 'c++-mode-untabify)
(global-set-key "\M-." 'helm-gtags-dwim)
(global-set-key "\C-\M-o" 'moo-complete)
(global-set-key "\M-o" 'ff-find-other-file)
(global-set-key "\C-t" 'transpose-chars)

;; File search
(global-set-key [f1] 'helm-mini)
(global-set-key [f2] 'helm-for-files)
(global-set-key [f3] 'helm-swoop)
(global-set-key [f4] 'helm-do-ag-at-point-with-base-dir)
(global-set-key [(control f4)] 'helm-resume)
(global-set-key [f5] 'helm-do-ag-with-base-dir)
;; f6 undefined
;; f7 is project specific
;; f9 is project specific
;; f10 is project specific
(global-set-key [f8] 'kill-all-compilation)
;;(global-set-key [f12] 'semantic-ia-fast-jump)

;; P4
(global-unset-key "\C-xpe")
(global-set-key "\C-xpe" 'p4-edit)
(global-unset-key "\C-xpr")
(global-set-key "\C-xpr" 'p4-revert)
(global-set-key "\C-xpa" 'p4-add)

;; Bookmarks+
(global-set-key "\C-xbl" 'bookmark-bmenu-list)
(global-set-key "\C-xbm" 'bmkp-bookmark-set-confirm-overwrite)
(global-set-key "\C-xbj" 'bookmark-jump)
(global-set-key "\C-xbt" 'bmkp-autofile-add-tags)
(global-set-key "\C-xb\r" 'bmkp-toggle-autonamed-bookmark-set/delete)
(global-set-key "\C-xbn" 'bmkp-next-bookmark)
(global-set-key "\C-xbp" 'bmkp-previous-bookmark)
(global-set-key "\C-xbc" 'bmkp-next-bookmark-this-file/buffer-repeat)

;; Company
;;(global-set-key [(control >)] 'company-gtags)
(global-set-key [C-tab] 'company-gtags)

;; Transpose frames
(global-set-key [C-right] 'flop-frame)
(global-set-key [C-left] 'flop-frame)
(global-set-key [C-up] 'flip-frame)
(global-set-key [C-down] 'flip-frame)

; ;; Key bindings END --------------------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-start nil)
 '(ac-modes
   (quote
    (emacs-lisp-mode lisp-mode lisp-interaction-mode slime-repl-mode c-mode cc-mode c++-mode go-mode java-mode malabar-mode clojure-mode clojurescript-mode scala-mode scheme-mode ocaml-mode tuareg-mode coq-mode haskell-mode agda-mode agda2-mode perl-mode cperl-mode python-mode ruby-mode lua-mode tcl-mode ecmascript-mode javascript-mode js-mode js2-mode php-mode css-mode less-css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode web-mode ts-mode sclang-mode verilog-mode qml-mode mold-mode zen-mode)))
 '(ac-stop-words (quote ("else")))
 '(ac-use-fuzzy t)
 '(add-to-list (quote warning-suppress-types) t)
 '(alert-default-style (quote fringe))
 '(alert-severity-colors
   (quote
    ((urgent . "red")
     (high . "orange")
     (moderate . "yellow")
     (normal . "green")
     (low . "blue")
     (trivial . "purple"))))
 '(align-c++-modes (quote (c++-mode c-mode java-mode csharp-mode mold-mode)))
 '(align-indent-before-aligning t)
 '(appt-display-interval 12)
 '(appt-visible nil)
 '(auto-revert-interval 2)
 '(auto-revert-stop-on-user-input nil)
 '(auto-revert-use-notify nil)
 '(backup-directory-alist (quote (("." . "~/.saves"))))
 '(blink-cursor-delay 11.5)
 '(blink-cursor-mode t)
 '(bmkp-autotemp-bookmark-predicates nil)
 '(bmkp-last-as-first-bookmark-file "d:\\home\\.emacs.d\\bookmarks")
 '(bs-max-window-height 20)
 '(c++-font-lock-extra-types
   (quote
    ("ios" "string" "rope" "list" "slist" "deque" "vector" "bit_vector" "set" "multiset" "map" "multimap" "stack" "queue" "priority_queue" "iterator" "const_iterator" "reverse_iterator" "const_reverse_iterator" "reference" "const_reference" "LPCTSTR" "BYTE" "WORD" "DWORD" "FIXME" "INT" "BOOL" "TRUE" "FALSE" "FLOAT" "true" "false" "private" "protected" "public" "__forceinline" "Vector" "Quaternion" "RESTYPE" "nullptr")))
 '(c-basic-offset 4)
 '(c-cleanup-list (quote (brace-else-brace scope-operator)))
 '(c-font-lock-extra-types
   (quote
    ("FILE" "LPCTSTR" "WORD" "DWORD" "BYTE" "FIXME" "ios" "string" "rope" "list" "slist" "deque" "vector" "bit_vector" "set" "multiset" "map" "multimap" "hash\\(_\\(m\\(ap\\|ulti\\(map\\|set\\)\\)\\|set\\)\\)?" "stack" "queue" "priority_queue" "iterator" "const_iterator" "reverse_iterator" "const_reverse_iterator" "reference" "const_reference" "FIXME" "INT" "BOOL" "TRUE" "FALSE" "FLOAT" "true" "false" "private" "protected" "public" "__forceinline" "Vector" "Quaternion" "RESTYPE" "nullptr")))
 '(c-syntactic-indentation t)
 '(c-tab-always-indent nil)
 '(case-fold-search t)
 '(cc-other-file-alist
   (quote
    (("\\.cc\\'"
      (".hh" ".h"))
     ("\\.hh\\'"
      (".cc" ".C"))
     ("\\.c\\'"
      (".h"))
     ("\\.h\\'"
      (".c" ".cc" ".C" ".CC" ".cxx" ".cpp"))
     ("\\.C\\'"
      (".H" ".hh" ".h"))
     ("\\.H\\'"
      (".C" ".CC"))
     ("\\.CC\\'"
      (".HH" ".H" ".hh" ".h"))
     ("\\.HH\\'"
      (".CC"))
     ("\\.c\\+\\+\\'"
      (".h++" ".hh" ".h"))
     ("\\.h\\+\\+\\'"
      (".c++"))
     ("\\.cpp\\'"
      (".hpp" ".hh" ".h"))
     ("\\.hpp\\'"
      (".cpp"))
     ("\\.cxx\\'"
      (".hxx" ".hh" ".h"))
     ("\\.hxx\\'"
      (".cxx"))
     ("\\.mold\\'"
      (".h"))
     ("\\.zen\\'"
      (".h"))
     ("\\.sc\\'"
      (".cpp")))))
 '(column-enforce-column 164)
 '(company-auto-complete (quote (quote company-explicit-action-p)))
 '(company-auto-complete-chars (quote (32 46)))
 '(company-backends
   (quote
    (company-elisp
     (company-dabbrev-code company-gtags company-etags company-keywords)
     company-files company-capf company-semantic)))
 '(company-dabbrev-code-everywhere nil)
 '(company-dabbrev-code-modes
   (quote
    (prog-mode batch-file-mode csharp-mode css-mode erlang-mode haskell-mode jde-mode lua-mode python-mode zen-mode c++-mode c-mode lisp-mode mold-mode emacs-lisp-mode lisp-interaction-mode)))
 '(company-dabbrev-code-other-buffers t)
 '(company-global-modes t)
 '(company-idle-delay 0.3)
 '(company-minimum-prefix-length 4)
 '(company-require-match (quote (quote company-explicit-action-p)))
 '(company-show-numbers t)
 '(compilation-always-kill t)
 '(compilation-ask-about-save nil)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-environment (quote ("ECHO=OFF")))
 '(compilation-error-regexp-alist
   (quote
    (csharp ant bash msft edg-1 edg-2 java zen msft omake rxp)))
 '(compilation-scroll-output t)
 '(compilation-window-height 40)
 '(compile-auto-highlight t)
 '(completion-how-to-resolve-old-completions (quote ask))
 '(csharp-want-flymake-fixup nil)
 '(current-language-environment "Latin-1")
 '(custom-safe-themes
   (quote
    ("428718b72dcd54cdf623d658106bfd719318fa70efce12d13b5bc89e76248e7b" "0556a276299104b574df244efe5997e8afc07b337ff55090a480763dfdc9d77a" "aee8de6eaa9dc2e7813945f611097d28668c1bdb3c9c2272154b8954a1b33dd6" "d8541c603e1377725989a3a684d66e97fc374f60b06e5d18728b7f957440d9db" "3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "cdc7555f0b34ed32eb510be295b6b967526dd8060e5d04ff0dce719af789f8e5" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default)))
 '(debug-ignored-errors
   (quote
    ("^Invalid face:? " search-failed beginning-of-line beginning-of-buffer end-of-line end-of-buffer end-of-file buffer-read-only file-supersession mark-inactive user-error jit-lock--debug-fontify)))
 '(debug-on-error nil)
 '(default-input-method "latin-1-prefix")
 '(desktop-globals-to-save
   (quote
    (desktop-missing-file-warning tags-file-name tags-table-list search-ring regexp-search-ring register-alist file-name-history)))
 '(desktop-load-locked-desktop t)
 '(desktop-restore-reuses-frames :keep)
 '(desktop-save t)
 '(desktop-save-hook (quote (powerline-desktop-save-delete-cache)))
 '(desktop-save-mode t nil (desktop))
 '(display-time-day-and-date t)
 '(display-time-format "%d/%b/%Y %H:%M")
 '(display-time-mode t nil (time))
 '(eol-mnemonic-dos "dos")
 '(european-calendar-style t)
 '(everything-cmd "D:/Utilities/Everything/es.exe")
 '(fa-insert-method (quote name-and-parens-and-hint))
 '(find-dired-find-program "find")
 '(find-ls-option (quote ("-exec ls -ld '{}' \\;" . "-ld")))
 '(font-lock-global-modes t)
 '(font-lock-maximum-decoration (quote ((c-mode . 3) (c++-mode . t))))
 '(font-lock-maximum-size 2097152)
 '(ggtags-executable-directory "d:/Utilities/gnuGlobal/bin/")
 '(ggtags-global-ignore-case t)
 '(global-company-mode t)
 '(global-ede-mode t)
 '(global-hl-line-mode t)
 '(global-semantic-decoration-mode nil)
 '(global-semantic-idle-breadcrumbs-mode nil nil (semantic/idle))
 '(global-semantic-idle-completions-mode nil nil (semantic/idle))
 '(global-semantic-idle-scheduler-mode t)
 '(global-semantic-idle-summary-mode t)
 '(global-semantic-stickyfunc-mode t nil (semantic/util-modes))
 '(gmm-tool-bar-style (quote gnome))
 '(grep-command "grep -r -n")
 '(helm-ack-grep-executable "ack-grep")
 '(helm-ag-base-command "sift -a --stats --no-color -x cpp,mold,zen,h -nrs")
 '(helm-ag-command-option nil)
 '(helm-boring-buffer-regexp-list
   (quote
    ("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf" "\\*monitor")))
 '(helm-buffer-max-length 65)
 '(helm-buffers-truncate-lines t)
 '(helm-for-files-preferred-list
   (quote
    (helm-source-buffers-list helm-source-locate helm-source-recentf helm-source-bookmarks helm-source-file-cache helm-source-files-in-current-dir)))
 '(helm-grep-ag-command
   "sift --line-numbers -ars --no-color --nogroup --stats %s %s")
 '(helm-grep-default-command "grep -a -d skip -n%cH -e %p %f")
 '(helm-grep-default-recurse-command "grep -a -d recurse %e -n%cH -e %p %f")
 '(helm-grep-save-buffer-name-no-confirm t)
 '(helm-grep-truncate-lines t)
 '(helm-idle-delay 0.3)
 '(helm-input-idle-delay 0.3)
 '(helm-locate-command "es %s %s")
 '(helm-truncate-lines t t)
 '(helm-white-buffer-regexp-list (quote ("\\*helm ag results\\*")))
 '(hs-hide-comments-when-hiding-all nil)
 '(hs-isearch-open t)
 '(ido-mode (quote file) nil (ido))
 '(indent-tabs-mode nil)
 '(iswitchb-all-frames (quote visible))
 '(iswitchb-buffer-ignore
   (quote
    ("^ " "*Completions*" "*scratch*" "*Help*" "*grep*" "*P4" "*Messages")))
 '(iswitchb-default-method (quote samewindow))
 '(iswitchb-mode t)
 '(ivy-count-format "(%d/%d) ")
 '(jit-lock-debug-mode t)
 '(mode-line-format
   (quote
    ("%e"
     (:eval
      (let*
          ((active
            (powerline-selected-window-active))
           (mode-line
            (if active
                (quote mode-line)
              (quote mode-line-inactive)))
           (face1
            (if active
                (quote powerline-active1)
              (quote powerline-inactive1)))
           (face2
            (if active
                (quote powerline-active2)
              (quote powerline-inactive2)))
           (separator-left
            (intern
             (format "powerline-%s-%s"
                     (powerline-current-separator)
                     (car powerline-default-separator-dir))))
           (separator-right
            (intern
             (format "powerline-%s-%s"
                     (powerline-current-separator)
                     (cdr powerline-default-separator-dir))))
           (lhs
            (list
             (powerline-raw "%*" nil
                            (quote l))
             (powerline-buffer-size nil
                                    (quote l))
             (powerline-buffer-id nil
                                  (quote l))
             (powerline-raw " ")
             (funcall separator-left mode-line face1)
             (powerline-narrow face1
                               (quote l))
             (powerline-vc face1)))
           (rhs
            (list
             (powerline-raw global-nas-version-string face1
                            (quote r))
             (powerline-raw global-mode-string face1
                            (quote r))
             (powerline-raw "%4l" face1
                            (quote r))
             (powerline-raw ":" face1)
             (powerline-raw "%3c" face1
                            (quote r))
             (funcall separator-right face1 mode-line)
             (powerline-raw " ")
             (powerline-raw "%6p" nil
                            (quote r))
             (powerline-hud face2 face1)))
           (center
            (list
             (powerline-raw " " face1)
             (funcall separator-left face1 face2)
             (when
                 (and
                  (boundp
                   (quote erc-track-minor-mode))
                  erc-track-minor-mode)
               (powerline-raw erc-modified-channels-object face2
                              (quote l)))
             (powerline-major-mode face2
                                   (quote l))
             (powerline-process face2)
             (powerline-raw " :" face2)
             (powerline-minor-modes face2
                                    (quote l))
             (powerline-raw " " face2)
             (funcall separator-right face2 face1))))
        (concat
         (powerline-render lhs)
         (powerline-fill-center face1
                                (/
                                 (powerline-width center)
                                 2.0))
         (powerline-render center)
         (powerline-fill face1
                         (powerline-width rhs))
         (powerline-render rhs)))))))
 '(open-paren-in-column-0-is-defun-start nil)
 '(p4-executable "c:/Program Files/Perforce/p4.exe")
 '(p4-verbose nil)
 '(package-selected-packages
   (quote
    (magit swiper ivy counsel tool-bar+ transpose-frame all-the-icons alert helm-company company-c-headers company adaptive-wrap powershell helm-swoop sift helm-core helm cus-edit+ menu-bar+ forecast xml-rpc sunrise-x-w32-addons sunrise-x-tree sunrise-x-buttons smart-mode-line-powerline-theme regex-tool org-jira mic-paren log4j-mode jira irony helm-projectile grizzl ggtags ecb column-enforce-mode color-theme-buffer-local color-theme bookmark+ auto-complete-c-headers)))
 '(paren-highlight-offscreen t)
 '(paren-message-truncate-lines t)
 '(paren-mode (quote sexp))
 '(paren-sexp-mode (quote match))
 '(powerline-default-separator (quote arrow-fade))
 '(powerline-height nil)
 '(powerline-text-scale-factor nil)
 '(query-user-mail-address nil)
 '(save-place-mode t nil (saveplace))
 '(scroll-bar-mode nil)
 '(semantic-c-member-of-autocast nil)
 '(semantic-complete-inline-analyzer-displayor-class (quote semantic-displayor-ghost))
 '(semantic-idle-scheduler-idle-time 600)
 '(semantic-idle-scheduler-verbose-flag t)
 '(semantic-idle-scheduler-work-idle-time 1200)
 '(semantic-idle-work-parse-neighboring-files-flag t)
 '(semantic-idle-work-update-headers-flag t)
 '(semantic-mode-line-prefix "Sem" nil (semantic/util-modes))
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(show-trailing-whitespace t)
 '(sift-arguments (quote ("-a -s -x cpp,mold,zen,h -r")))
 '(sml/mode-width
   (if
       (eq powerline-default-separator
           (quote arrow))
       (quote right)
     (quote full)))
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (car powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active1)
                   nil)))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (car powerline-default-separator-dir)))
                   nil
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s" powerline-default-separator
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active2)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes)))
 '(speedbar-frame-parameters
   (quote
    ((minibuffer)
     (width . 46)
     (border-width . 0)
     (menu-bar-lines . 0)
     (tool-bar-lines . 0)
     (unsplittable . t)
     (height . 83)
     (left . 1560)
     (top . 0))))
 '(speedbar-supported-extension-expressions
   (quote
    (".org" ".cs" ".wy" ".by" ".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".emacs" ".l" ".lsp" ".p" ".java" ".f\\(90\\|77\\|or\\)?" ".ada" ".p[lm]" ".tcl" ".m" ".scm" ".pm" ".py" ".g" ".s?html" ".ma?k" "[Mm]akefile\\(\\.in\\)?" ".uc" ".mold" ".zen")))
 '(template-date-format "%d/%b/%Y")
 '(tool-bar-mode nil)
 '(tool-bar-style (quote text))
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(w32-use-w32-font-dialog nil)
 '(warning-suppress-types (quote ((undo discard-info)))))



;; Start the emacs server so we can send files to emacs from VS
(server-start)
;; Remove the hook that confirms closing the buffer if it was started with emacsclientw
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;; Actually, finish with loading my last group of files
;; Remember what I was working on.
(desktop-load-default)
(desktop-read)

(eshell)

;; Auto-added by something somehow.
(put 'narrow-to-region 'disabled nil)

;; (add-hook 'kill-emacs-hook 'close-compilation-monitor)

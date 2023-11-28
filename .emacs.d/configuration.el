(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode '(0 . 0))
(defalias 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil :font "Comic Mono" :height 140)

(defvar p-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq oh/packages
      '(multiple-cursors
	gcmh
	amx
	ido-yes-or-no
	ido-completing-read+
	icomplete
	find-file-in-repository
	ctrlf
	symbol-overlay
	savehist
	helpful
	popwin
	which-key
	org-download
	iedit
	wgrep
	ripgrep
	org
        format-all
	haskell-mode
	markdown-mode
	purescript-mode
	nix-mode
	typescript-mode
	tree-sitter
	tree-sitter-langs
	pdf-tools
	'(acutex :type git :host github :repo "emacs-straight/auctex")
	eglot
	magit
	direnv
	0x0
	yasnippet
	yasnippet-snippets
	modus-themes))

(setq oh/requires
      '(multiple-cursors
	amx
	ido-yes-or-no
	ido-completing-read+
	icomplete
	find-file-in-repository
	helpful
	popwin
	org-download
	symbol-overlay
	ctrlf
	iedit
	wgrep
	ripgrep
	org-tempo
	org
	haskell-mode
	purescript-mode
	nix-mode
	typescript-mode
	agda2-mode
	markdown-mode
	tree-sitter
	tree-sitter-langs
	eglot
	direnv
	modus-themes))

(load-file (shell-command-to-string "agda-mode locate"))
(dolist (pkg oh/packages) (straight-use-package pkg))
(dolist (pkg oh/requires) (require pkg))

(setq gc-cons-threshold 10000000
      default-directory "~"
      default-tab-width 2
      ring-bell-function 'ignore
      backup-directory-alist '(("" . "~/.emacs.d/backup"))
      inhibit-startup-message t
      redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq ido-enable-flex-matching t
      ido-everywhere t
      ido-decorations '(" | " "" " <> " " <> ..." "" "" " [Not Exist]" " E" " [Not readable]" " [Too big]" " [Confirm]")
      ido-use-faces t
      ido-use-virtual-buffers t
      ido-max-window-height 1)

(setq recentf-max-menu-items 25
      recentf-max-saved-items 25)

(setq org-use-property-inheritance t
      org-tags-column 0
      org-image-actual-width 250)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (haskell . t)
   (shell . t)
   ))

(defun oh/org-mode ()
  (org-indent-mode)
  (visual-line-mode 1)
  (setq visual-fill-column-width 140
        visual-fill-column-center-text t
	org-download-method 'directory
	org-download-image-dir "./resources")
  (visual-fill-column-mode)
  (auto-fill-mode)
  (org-download-enable))

(add-hook 'org-mode-hook #'oh/org-mode)

(setq TeX-auto-save t
      TeX-parse-self t)
(setq-default TeX-master nil)

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

(setq haskell-indentation-starter-offset 2
      haskell-indentation-where-post-offset 2
      haskell-indentation-where-pre-offset 2
      haskell-indentation-left-offset 2
      haskell-indentation-layout-offset 2)

(setq yas-triggers-in-field t)

(setq-default typescript-indent-level 2)

(setq auto-mode-alist
      (append auto-mode-alist
	      '(("\\.hs\\'" . haskell-mode)
		("\\.nix\\'" . nix-mode)
		("\\.agda\\'" . agda2-mode)
		("\\.purs\\'" . purescript-mode)
		("\\.ts\\'" . typescript-mode)
		("\\.org\\'" . org-mode))))

(prettify-symbols-mode 1)
(purescript-indentation-mode)
(global-display-fill-column-indicator-mode)
(gcmh-mode)
(amx-mode)
(ido-yes-or-no-mode)
(ido-ubiquitous-mode)
(icomplete-mode)
(ido-mode)
(savehist-mode)
(recentf-mode)
(popwin-mode)
(which-key-mode)
(yas-global-mode 1)
(load-theme 'modus-operandi :no-confirm)

(global-set-key [f1] #'previous-buffer)
(global-set-key [f2] #'next-buffer)
(global-set-key [f5] #'compile)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-s") 'oh/select)
(global-set-key (kbd "C-r") 'ctrlf-backward-default)

(define-key ido-common-completion-map (kbd "C-n") #'ido-next-match)
(define-key ido-common-completion-map (kbd "C-p") #'ido-prev-match)
(global-set-key (kbd "C-x C-b") #'ibuffer)

(with-eval-after-load 'find-file-in-repository
  (global-set-key (kbd "C-x f") 'find-file-in-repository))

(with-eval-after-load 'symbol-overlay
  (global-set-key (kbd "<f6>") 'symbol-overlay-remove-all)
  (global-set-key (kbd "M-i") 'symbol-overlay-put))

(with-eval-after-load 'helpful
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function)
  (global-set-key (kbd "C-h C") #'helpful-command))

(with-eval-after-load 'ripgrep
  (global-set-key (kbd "C-c r") #'ripgrep-regexp))

(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))

;; This is broken in original repository. This can go once PR is merged
;; https://github.com/magnars/multiple-cursors.el/pull/377
(defun oh/mark-all-in-region (beg end &optional search)
  (interactive "r")
  (let ((search (or search (read-from-minibuffer "Mark all in region: ")))
        (case-fold-search nil))
    (if (string= search "")
        (message "Mark aborted")
      (progn
        (mc/remove-fake-cursors)
        (goto-char beg)
	(let ((lastmatch))
          (while (search-forward search end t)
            (push-mark (match-beginning 0))
            (mc/create-fake-cursor-at-point)
	    (setq lastmatch t))
          (unless lastmatch
	    (error "Search failed for %S" search)))
	(goto-char (match-end 0))
	(if (< (mc/num-cursors) 3)
            (mc/disable-multiple-cursors-mode)
          (mc/pop-state-from-overlay (mc/furthest-cursor-before-point))
          (multiple-cursors-mode 1))))))

(defun oh/select ()
  (interactive)
  (if (region-active-p)
      (oh/mark-all-in-region (region-beginning) (region-end))
    (ctrlf-forward-default)))

(add-hook 'before-save-hook
	  (lambda ()
	    (when (derived-mode-p 'prog-mode)
	      (delete-trailing-whitespace))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper"))))

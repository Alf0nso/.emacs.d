;;; -*- lexical-binding: t -*-

(defun tangle-init ()
  "If the current buffer is init.org the code-blocks are
tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
		 (expand-file-name
		  (concat user-emacs-directory "init.org")))
      ;; Avoid running hooks when tangling.
      (let ((prog-mode-hook nil))
	(org-babel-tangle)
	(byte-compile-file (concat user-emacs-directory "init.el")))))

(add-hook 'after-save-hook 'tangle-init)

(defvar personal-keybindings '())

(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold (* 50 1000 1000))

;; Set and reset threshold
(let ((old-gc-treshold gc-cons-threshold))
  (setq gc-cons-threshold most-positive-fixnum)
  (add-hook 'after-init-hook
	    (lambda () (setq gc-cons-threshold old-gc-treshold))))

;; native-comp warning
(setq native-comp-async-report-warnings-errors 'silent)
(setq byte-compile-warnings
      '(not free-vars unresolved noruntime lexical make-local))

(setq idle-update-delay 1.0)

(setq process-adaptive-read-buffering nil)
(setq read-process-output-max (* 4 1024 1024))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(require 'package)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile
    (unless (bound-and-true-p package--initialized)
      ;; be sure load-path includes package directories
      (when (< emacs-major-version 27)
	(package-initialize)))
    (require 'use-package)))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
	("MELPA"        . "https://melpa.org/packages/")
	("ORG"          . "https://orgmode.org/elpa/")
	("MELPA Stable" . "https://stable.melpa.org/packages/")
	("nongnu"       . "https://elpa.nongnu.org/nongnu/"))
      package-archive-priorities
      '(("GNU ELPA"     . 20)
	("MELPA"        . 15)
	("ORG"          . 10)
	("MELPA Stable" . 5)
	("nongnu"       . 0)))
(package-initialize)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
	"straight/repos/straight.el/bootstrap.el"
	(or (bound-and-true-p straight-base-dir)
	    user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://radian-software.github.io/straight.el/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq utf-translate-cjk-mode nil)
(set-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-selection-coding-system (prefer-coding-system 'utf-8))
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(scroll-bar-mode -1)
(menu-bar-mode 0)
(tool-bar-mode 0)
(display-time-mode 1)
(display-battery-mode 1)

(setq ring-bell-function 'ignore)
(setq truncate-lines t)
(setq frame-resize-pixelwise t)

(fset 'yes-or-no-p 'y-or-n-p)

(defun custom/kill-this-buffer ()
  (interactive) (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k")
		   'kill-buffer-and-window)

(global-set-key (kbd "C-c k")
		   'kill-buffer)

(defun config-visit()
  (interactive)
  (find-file "~/.emacs.d/init.org"))
(global-set-key (kbd "C-c e") 'config-visit)

(put 'dired-find-alternate-file 'disabled nil)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.saves/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)

(setq frame-title-format "%b")

(defvar custom-bindings-map (make-keymap)
  "A keymap for custom keybindings.")

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-org-config))

;; set a default font
(when (member "Fira Code" (font-family-list))
  (set-face-attribute 'default nil
		      :font "Fira Code"
		      :height 160))

(when (member "Iosevka Fixed Curly" (font-family-list))
  (set-face-attribute 'default nil
		      :font "Iosevka Fixed Curly"
		      :height 160))

(when (member "Iosevka Comfy" (font-family-list))
  (set-face-attribute 'default nil
		      :font "Iosevka Comfy"
		      :height 160))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

(global-prettify-symbols-mode 1)
(defun add-pretty-lambda ()
  (setq prettify-symbols-alist
	   '(
	     ("[ ]" . 9744)
	     ("[X]" . 9745)
	     ("lambda" . 955)
	     ("epsilon" . 603)
	     ("->" . 8594)
	     ("<-" . 8592)
	     (":-" . 8592)
	     ("!sum" . 8721)
	     ("<=" . 8804)
	     (">=" . 8805)
	     ("=>" . 8658)
	     ("#+BEGIN_SRC"     . 955)
	     ("#+END_SRC"       . 955)
	     ("#+begin_src"     . 955)
	     ("#+end_src"       . 955))))
(add-hook 'prog-mode-hook 'add-pretty-lambda)
(add-hook 'org-mode-hook 'add-pretty-lambda)

(use-package olivetti
  :defer t
  :bind (:map custom-bindings-map ("C-c o" . olivetti-mode))
  :config
  (setq olivetti-style t))

(use-package writeroom-mode
  :bind (:map custom-bindings-map ("<f1>" . writeroom-mode))
  :defer t)

(setq inhibit-startup-screen t)

;; https://www.youtube.com/watch?v=NfjsLmya1PI
(setq initial-scratch-message 
      ";; Present Day, Present Time...\n")

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-set-navigator t)
  (setq dashboard-center-content t)
  (setq dashboard-banner-logo-title "G A F A N H O T O")
  (setq dashboard-startup-banner "~/.emacs.d/grasshopper.png")
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*"))))

(use-package dired
  :ensure nil
  :hook
  (dired-mode . dired-hide-details-mode))

(use-package dired-subtree
  :ensure t
  :config
  (setq dired-subtree-use-backgrounds nil)
  (define-key dired-mode-map [tab] 'dired-subtree-toggle))

(use-package vertico
  :config
  (vertico-mode 1)
	; Show more candidates
  (setq vertico-count                         25
	read-extended-command-predicate
	'command-completion-default-include-p
	; Ignore case of file names
	read-file-name-completion-ignore-case t
	; Ignore case in buffer completion
	read-buffer-completion-ignore-case    t
	; Ignore case in completion
	completion-ignore-case                t))

(use-package vertico-posframe
  :config
  (vertico-posframe-mode 1)
  (setq vertico-posframe-width  90
	vertico-posframe-height vertico-count))

(use-package corfu
  :custom
  ;; Enable auto completion
  (corfu-auto t)
  ;; Enable cycling for `corfu-next/previous'
  (corfu-cycle t)
  ;; No delay
  (corfu-auto-delay 0)
  ;; Start when this many characters have been typed
  (corfu-auto-prefix 2)
  ;; Short delay
  (corfu-popupinfo-delay 0.5)
   ;; Preselect the prompt
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode))

(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  ;; (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)

  ;; Emacs 30 and newer: Disable Ispell completion
  ;; function. As an alternative,
  ;; try `cape-dict'.
  (setq text-mode-ispell-word-completion nil)

  ;; Emacs 28 and newer: Hide commands in M-x
  ;; which do not apply to the current
  ;; mode.  Corfu commands are hidden, since
  ;; they are not used via M-x. This
  ;; setting is useful beyond Corfu.
  (setq read-extended-command-predicate
	#'command-completion-default-include-p))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package marginalia
  :init 
  (marginalia-mode 1))

(use-package helpful
  :bind (:map custom-bindings-map
			  ("C-h f" . #'helpful-function)
			  ("C-h v" . #'helpful-variable)
			  ("C-h k" . #'helpful-key)
			  ("C-h x" . #'helpful-command)
			  ("C-h d" . #'helpful-at-point)
			  ("C-h c" . #'helpful-callable)))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package haskell-snippets
  :defer t)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  :custom (pdf-annot-activate-created-annotations
	      t "automatically annotate highlights"))

(use-package lorem-ipsum)

;; Make sure that cmake, libtool, libtool-bin
(use-package vterm
    :ensure t)

(setq eshell-prompt-regexp "^[^αλ\n]*[αλ] ")
(setq eshell-prompt-function
      (lambda nil
	(concat
	 (if (string= (eshell/pwd) (getenv "HOME"))
	     (propertize "~" 'face `(:foreground "#99CCFF"))
	   (replace-regexp-in-string
	    (getenv "HOME")
	    (propertize "~" 'face `(:foreground "#99CCFF"))
	    (propertize (eshell/pwd) 'face
			`(:foreground "#99CCFF"))))
	 (if (= (user-uid) 0)
	     (propertize " α " 'face `(:foreground "#FF6666"))
	   (propertize " λ " 'face `(:foreground "#A6E22E"))))))

(setq eshell-highlight-prompt nil)

(defalias 'open 'find-file-other-window)
(defalias 'clean 'eshell/clear-scrollback)

(defun eshell-other-window ()
  "Create or visit an eshell buffer."
  (interactive)
  (if (not (get-buffer "*eshell*"))
      (progn
	(split-window-sensibly (selected-window))
	(other-window 1)
	(eshell))
    (switch-to-buffer-other-window "*eshell*")))

(global-set-key (kbd "<C-escape>") 'eshell-other-window)

(use-package magit
  :ensure t
  :bind (("C-c m" . magit-status)))

(use-package markdown-mode
  :defer t)

(use-package flyspell
  :ensure t
  :config
  (add-hook 'text-mode-hook 'flyspell-mode))

(use-package ispell
  :ensure t
  :config
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "english")
  (global-set-key (kbd "C-<f8>")
		     'flyspell-check-previous-highlighted-word))

(use-package org
  :ensure nil
  :defer t
  :hook (org-mode . olivetti-mode)
  :config
  ;; Start up any org file with pretty latex images
  (setq org-startup-with-latex-preview t)
  (plist-put org-format-latex-options :scale 1.5)

  ;; All images showing
  (setq org-startup-with-inline-images t)

  ;; Org tempo templates
  (require 'org-tempo)
  (setq org-structure-template-alist
	'(("el" . "src emacs-lisp")
	  ("sh" . "src shell")
	  ("py" . "src python :results output :exports both")
	  ("pys" . 
	  "src python :session :results output :exports both")
	  ("c" . "src C")
	  ("cl" . "src lisp")
	  ("hs" . "src haskell :results value :exports both")
	  ("js" . "src js :results output")
	  ))

  ;; Babel and the polyglot configuration
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell      . t)
     (python     . t)
     (C          . t)
     (haskell    . t)
     (js         . t)))
  )

(use-package org-agenda
  :ensure nil
  :config
  (global-set-key (kbd "C-c a") 'org-agenda)
  (custom-set-variables
   '(org-directory "~/Org/agenda")
   '(org-agenda-files (list org-directory))))

(use-package org-appear
  :commands (org-appear-mode)
  :hook     (org-mode . org-appear-mode)
  :config
  ; Must be activated for org-appear to work
  (setq org-hide-emphasis-markers t)
  ; Show bold, italics, verbatim, etc.
  (setq org-appear-autoemphasis   t
	; Show links
	org-appear-autolinks      t
	; Show sub- and superscripts
	org-appear-autosubmarkers t))

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode))

(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list
	'("ꖜ" "•" "❉" "⨿" "ᖷ"))
  (setq org-todo-keywords 
	'((sequence "☛ TODO(t)" "➤ NEXT(n)" "|" "✔ DONE(d)")
	  (sequence "∞ WAITING(w)" "|"  "✘ CANCELED(c)")
	  (sequence "∞ READING(r)"
		    "∞ VIEWING(v)"
		    "𝅘𝅥𝅮 LISTENING(l)"
		    "░ WATCHLIST(a)"
		    "|"  "◤ FINISHED(f)")))
  (setq org-todo-keyword-faces
	'(("✔ DONE" . (:foreground "gray"))))

  :config
  (add-hook 'org-mode-hook
	    (lambda () (org-bullets-mode 1)))
  (setq org-ellipsis "▼"))

(use-package org-pomodoro
  :ensure t
  :commands (org-pomodoro)
  :config
  (setq org-pomodoro-play-sounds nil)
  (setq alert-user-configuration (quote
				  ((((:category . "org-pomodoro"))
				    libnotify nil)))))

(use-package ox-reveal
  :ensure ox-reveal
  :config
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  (setq org-reveal-mathjax t))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Org/roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n g" . org-roam-graph)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ;; Dailies
	 ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework,
  ;; you might want a more informative completion interface
  (setq org-roam-node-display-template
	(concat "${title:*} "
		(propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
	  org-roam-ui-follow t
	  org-roam-ui-update-on-save t
	  org-roam-ui-open-on-start t))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((c-mode . lsp)
   (c++-mode . lsp)
   (web-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-tramp-connection "clangd")
    :major-modes '(c-mode c++-mode)
    :remote? t
    :server-id 'clangd-remote)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))

(use-package lean4-mode
  :ensure lean4-mode
  :straight (lean4-mode
	     :type git
	     :host github
	     :repo "leanprover/lean4-mode"
	     :files ("*.el" "data"))
  :commands (lean4-mode))

(let ((my-ghcup-path (expand-file-name "~/.ghcup/bin")))
  (setenv "PATH" (concat my-ghcup-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-ghcup-path))

(use-package haskell-mode
  :defer t
  :hook (haskell-mode . haskell-doc-mode)
  :config
  (custom-set-variables
   '(haskell-tags-on-save t)
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t)
   '(haskell-process-type 'stack-ghci)
     )

  (define-key haskell-mode-map (kbd "C-c C-l")
    'haskell-process-load-or-reload)
  )

(when (file-exists-p "~/.emacs.d/elisp/prolog.el")
  (load "~/.emacs.d/elisp/prolog.el")
  (setq prolog-electric-if-then-else-flag t))

(when (executable-find "swipl")
  (message "SWI-Prolog exists on path, using it!")
  (setq prolog-system 'swi
	prolog-program-switches
	'((swi ("-G128M" "-T128M" "-L128M" "-O"))
	  (t nil))))

(use-package ediprolog
  :ensure t
  :config
  ;; Scryer prolog is a pretty nice prolog system
  (when (executable-find "scryer-prolog")
    (setq ediprolog-system 'scryer)
    (setq ediprolog-program (executable-find "scryer-prolog")))
  (global-set-key [f10] 'ediprolog-dwim))

(when (file-exists-p "~/scryer-prolog/tools/showterm.el")
  (load "~/scryer-prolog/tools/showterm.el")
  (global-set-key [f12] 'showterm))

(use-package python
  :interpreter ("python3" . python-mode)
  :defer t
  :config
  (setq python-shell-interpreter "python3"))

(use-package pyvenv
  :defer t
  :config
  (setenv "WORKON_HOME" "~/py_home"))

(use-package ein
  :ensure t)

(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred))

(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
	 ("\\.cjs\\'" . js2-mode))
  :hook (js2-mode . lsp-deferred))
(add-hook 'javascript-mode #'js2-mode)

(when
    (file-directory-p
     "~/.local/share/SuperCollider/downloaded-quarks/scel/el/")
  (add-to-list
   'load-path
   "~/.local/share/SuperCollider/downloaded-quarks/scel/el/")
  (require 'sclang))

(define-minor-mode custom-bindings-mode
  "A mode that activates custom keybindings."
  :init-value t
  :keymap custom-bindings-map)

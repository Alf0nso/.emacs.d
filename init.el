;;; Package stuff
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
;;;

;;; In case stuff no on melpa, can always use el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;;;

;;; el-get for extra things I might want
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path
	     "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;;; Quelpa helps in some stuff
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

;;(quelpa
;; '(quelpa-use-package
;;   :fetcher git
;;   :url "https://github.com/quelpa/quelpa-use-package.git"))
;;(require 'quelpa-use-package)

;;; Making sure use package is working
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;;;


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" default))
 '(diredp-dir-heading t t)
 '(diredp-dir-name t t)
 '(diredp-file-name t t)
 '(diredp-file-suffix t t)
 '(ediprolog-program "swipl")
 '(ediprolog-system 'swi)
 '(ein:output-area-inlined-images t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-type 'stack-ghci)
 '(haskell-tags-on-save t)
 '(olivetti-body-width 72)
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.7 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(htmlize mastodon ob-elm django-snippets django-mode ediprolog julia-repl julia-mode auto-complete-c-headers auto-complete-clang auto-complete-clang-async haskell-emacs lua-mode erlang ocamlformat racket-mode calfw-gcal calfw-cal dante liquid-types flycheck-liquidhs company-coq proof-general boogie-friends vterm org-roam ox-gfm hindent ghc-imported-from retrie ein go-imports go-snippets go-mode slime projectile page-break-lines pdf-tools helm-spotify tide lsp-grammarly php-mode elm-mode gnuplot-mode gnuplot calfw calfw-org rustic racer rust-mode magit lsp-jedi peep-dired dired-hacks-utils olivetti org-roam-bibtex lsp-ivy lsp-ui ob-deno ac-sly dashboard easy-hugo ox-hugo ob-prolog js2-mode typescript-mode pyvenv docker dockerfile-mode math-preview yascroll smartparens deft org-roam-server yasnippet-snippets java-snippets sly sly-quicklisp common-lisp-snippets sparql-mode lsp-haskell haskell-snippets ivy lsp-mode haskell-mode all-the-icons doom-themes afternoon-theme treemacs-icons-dired dired+ quelpa org-bullets dired-subtree company comapny-mode comapny yasnippet auto-complete which-key smex use-package))
 '(safe-local-variable-values '((eval turn-off-auto-fill)))
 '(warning-suppress-types
   '((comp)
     (comp)
     (comp)
     (comp)
     (use-package)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (comp)
     (emacs)
     (lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Load org file configuration
(org-babel-load-file (expand-file-name
		      "~/.emacs.d/README.org"))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

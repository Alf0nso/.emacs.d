(require 'url)
(defun llvm-mode-get ()
  (interactive)
  (when (not (file-directory-p "llvm-mode"))
    (make-directory "llvm-mode")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/emacs.el")
     "llvm-mode/emacs.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/llvm-mir-mode.el")
     "llvm-mode/llvm-mir-mode.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/llvm-mode.el")
     "llvm-mode/llvm-mode.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/tablegen-mode.el")
     "llvm-mode/tablegen-mode.el")))

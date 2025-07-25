(require 'url)
(defun llvm-mode-get ()
  (interactive)
  (when (not (file-directory-p "~/.emacs.d/llvm-mode"))
    (make-directory "~/.emacs.d/llvm-mode")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/emacs.el")
     "~/.emacs.d/llvm-mode/emacs.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/llvm-mir-mode.el")
     "~/.emacs.d/llvm-mode/llvm-mir-mode.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/llvm-mode.el")
     ".emacs.d/llvm-mode/llvm-mode.el")
    (url-copy-file
     (concat "https://raw.githubusercontent.com/llvm/llvm-project/"
	     "refs/heads/main/llvm/utils/emacs/tablegen-mode.el")
     ".emacs.d/llvm-mode/tablegen-mode.el")))

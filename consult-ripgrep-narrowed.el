;;; consult-ripgrep-narrowed.el --- Two-step ripgrep narrowing for Consult -*- lexical-binding: t; -*-

;; Author: if001 <otomijuf.004@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "30.1") (consult "0.34"))
;; Keywords: search, tools, convenience
;; URL: https://github.com/your-username/consult-ripgrep-narrowed

;;; Commentary:

;; This package provides a two-step narrowing interface using ripgrep and Consult.
;; It first searches with keyword A to collect matching files, and then
;; allows narrowing within those files using keyword B via `consult--grep`.

;;; Code:

;;; -*- lexical-binding: t; -*-

(defun consult--ripgrep-narrowed-make-builder (file-list)
  "Return a ripgrep builder for searching within FILE-LIST."
  (lambda (paths)
    (let* ((cmd (consult--build-args consult-ripgrep-args)))
      (lambda (input)
	;; (setq cmd (consult--build-args consult-ripgrep-args))
	(pcase-let* ((`(,arg . ,opts) (consult--command-split input))
                     (re-quoted (regexp-quote arg))
                     (ignore-case
                      (or (member "-i" opts)
                          (member "--ignore-case" opts)
                          ;; 簡易判定
                          (not (string-match-p "[A-Z]" arg))))
                     (full-cmd (append cmd (list "-e" arg) opts file-list)))
	  (cons
	   full-cmd
	   (apply-partially #'consult--highlight-regexps (list re-quoted) ignore-case)))))
    )
  )


;;;###autoload
(defun consult-ripgrep-narrowed (keyword-a keyword-b dir)
  "Search for KEYWORD-A to collect files, then search KEYWORD-B within those files in DIR."
  (interactive
   (list
    (read-string "First keyword (A): ")
    (read-string "Second keyword (B): ")
    (read-directory-name "Directory: ")))

  (let* ((default-directory dir)
         (file-command (format "rg -l %s" (shell-quote-argument keyword-a)))
         (file-output (shell-command-to-string file-command))
         (file-list (split-string file-output "\n" t)))
    (if (null file-list)
        (message "No files matched keyword A.")
      (progn
        (consult--grep
         (format "rg: %s in files matching \"%s\"" keyword-b keyword-a)
         (make-builder file-list)
         dir
         keyword-b)))))

(provide 'consult-ripgrep-narrowed)

;;; consult-ripgrep-narrowed.el ends here

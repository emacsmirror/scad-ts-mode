;; Debug functions for Tree-sitter based code
;;
;; M-x treesit-explore-mode
;; M-x treesit-check-indent

(setq treesit--indent-verbose t)
(setq treesit-font-lock-level 4)

(defun my-treesit-code-to-node (code-string)
  (treesit-parse-string code-string 'openscad))

(defun my-treesit-node-to-string (node)
  (with-temp-buffer
    (treesit--explorer-draw-node node)
    (buffer-substring-no-properties (point-min) (point-max))))

(defun my-treesit-code-to-string (code-string)
  (my-treesit-node-to-string
   (my-treesit-code-to-node code-string)))

(defun my-treesit-node-parent-at-point ()
  (interactive)
  (let ((parent (treesit-node-parent (treesit-node-at (point)))))
    (message "%s" (my-treesit-node-to-string parent))
    (setq my-treesit-node parent)))

(defun my-treesit-node-at-point ()
  (interactive)
  (let ((node (treesit-node-at (point))))
    (message "%s" (my-treesit-node-to-string node))
    (setq my-treesit-node node)))

(defun my-treesit-font-face-at-point ()
  (interactive)
  (message "%s" (face-at-point)))

(defun my-eval-buffer ()
  "Execute the current buffer as Lisp code.
Top-level forms are evaluated with `eval-defun' so that `defvar'
and `defcustom' forms reset their default values."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (forward-sexp)
      (eval-defun nil)))
  (eval-buffer))

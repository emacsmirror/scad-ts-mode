#!/usr/bin/env -S emacs30 --script

;; emacs30 --script scripts/show-treesit-nodes.el test.scad
;; it looks:
;; #+begin_example
;;   (source_file
;;    (transform_chain
;;     (module_call name: (identifier)
;;      arguments:
;;       (arguments (
;;        (list [ (integer) , (integer) , (integer) ])
;;        )))
;;     ;))
;; #+end_example
;;

(require 'treesit)

(defun my-treesit-syntax-tree-as-string (code-string lang)
  (with-temp-buffer
    (treesit--explorer-draw-node
     (treesit-parse-string code-string lang))
    (buffer-substring-no-properties (point-min) (point-max))))

(setq scad-filename-or-code (nth 0 argv))
(setq argv nil)

(if (not (stringp scad-filename-or-code))
    (message "Usage: %s {FILENAME.scad|CODE-SNIPPET}"
             (file-name-nondirectory (or load-file-name buffer-file-name)))

  (setq code-string
        (if (and (file-exists-p scad-filename-or-code)
                 (not (file-directory-p scad-filename-or-code)))
            (with-temp-buffer
              (insert-file-contents scad-filename-or-code)
              (buffer-substring-no-properties (point-min) (point-max)))
          scad-filename-or-code))
  (princ (my-treesit-syntax-tree-as-string code-string 'openscad))
  (princ "\n"))

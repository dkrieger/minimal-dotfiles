;;; Misc
;;;; kubernetes

  ;; kubernetes-tramp :: use "/bin/sh" as 'tramp-remote-shell instead of "/bin/bash"
  ;; (setq tramp-methods
  ;;       (cons
  ;;        '("kubectl"
  ;;          (tramp-login-program "kubectl")
  ;;          (tramp-login-args
  ;;           (nil
  ;;            ("exec" "-it")
  ;;            ("-u" "%u")
  ;;            ("%h")
  ;;            ("sh")))
  ;;          (tramp-remote-shell "/bin/sh")
  ;;          (tramp-remote-shell-args
  ;;           ("-i" "-c")))
  ;;        ;; (cdr tramp-methods)
  ;;        tramp-methods
  ;;        )
  ;;       )

;;;; pop window into frame

  ;; https://emacs.stackexchange.com/questions/7116/pop-a-window-into-a-frame
  (defun my-turn-current-window-into-frame ()
    (interactive)
    (let ((buffer (current-buffer)))
      (unless (one-window-p)
        (delete-window))
      (display-buffer-pop-up-frame buffer nil)))

;;; Org
;;;; Misc
  
  (setq-default org-tags-column -70) ; right align tags to col 70
  (setq-default org-adapt-indentation nil) ; don't indent contents to heading level

;;;; Task Management
  (setq-default org-todo-keywords '((sequence "TODO" "NEXT" "|" "DONE" "CANCEL")))
  (setq-default org-log-done t) ; add CLOSED time

;;;; Agenda

  (setq-default org-agenda-files (list
                                  "~/org/agendas/work.org"
                                  "~/org/agendas/misc.org"
                                  "~/org/agendas/home.org"
                                  ))

;;;; Org Babel
;;;;; misc

  ;; (setq-default org-src-preserve-indentation t)
  (setq-default org-edit-src-content-indentation 0) ; this is preferred over above because it can repair old indentation schemes

;; https://github.com/syl20bnr/spacemacs/issues/7055
;; Use minted
(when (configuration-layer/package-usedp 'ox-latex)
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted)
  
  ;; Add the shell-escape flag
  (setq org-latex-pdf-process '(
                                "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                                ;; "bibtex %b"
                                "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                                "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                                ))

  ;; Sample minted options.
  (setq org-latex-minted-options '(
                                   ("frame" "lines")
                                   ("fontsize" "\\scriptsize")
                                   ("xleftmargin" "\\parindent")
                                   ("linenos" "")
                                   )))

;;;;; enable execution

  (require 'ob-shell) ; enable bash execution
  (require 'ob-js) ; enable node
  (require 'ob-dot) ; enable graphviz / dot
  (defun org-babel-execute:yaml (body params) body) ; https://www.reddit.com/r/orgmode/comments/9vofts/source_blocks_for_diffs/e9fx905/
  (defun my-org-snip-heading-prefix ()
    (interactive)
    (insert ((lambda (string)
               (forward-char)
               (concat (nth 4 (org-heading-components))
                       "-"
                       string)) (read-string "Enter Suffix: "))))

;;;;; tangle output files

;;;;;; list

  (defun my-org-babel-tangle-output-files (&optional file)
    (interactive "f")
    (funcall
     (if (called-interactively-p 'interactive) 'print 'identity)
     (with-current-buffer (if file (find-file-noselect file) (current-buffer))
       (delete-dups
        (mapcan
         (lambda (by-lang)
           (mapcar
            (lambda (block)
              (let ((props (cadr (cdr (cdr (cdr block))))))
                (cdr (assoc :tangle props))
                ))
            (cdr by-lang)
            ))
         (org-babel-tangle-collect-blocks))))))

;;;;;; untangle

  (defun my-org-babel-untangle ()
    (interactive)
    (mapcar
     (lambda (file) (delete-file file))
     (my-org-babel-tangle-output-files)))

;;;;; convenience

  ;; define the ":tangle" header arg based on the name property and some suffix
  (defun my-org-snip-tangle-by-name ()
    (interactive)
    (forward-char)
    (insert
     (when (org-babel-get-src-block-info)
       (concat
        " :tangle "
        (plist-get (cadr (org-element-at-point)) :name)
        "."
        (cdr
         (assoc
          (plist-get (cadr (org-element-at-point)) :language)
          org-babel-tangle-lang-exts)))))) ; https://emacs.stackexchange.com/questions/2328/using-org-babel-to-tangle-to-a-variable-file-name

;;;; my directory listing lib
;;;;; recursive

  (defun my-directory-files-recursively-ignore (&optional regex)
    (unless regex (setq regex ""))
    (require 'seq)
    (let ((excludes '("/.git/" "\.png$")))
      (seq-filter
       (lambda (fname)
         (not
          (eval
           (seq-reduce
            (lambda (carry el)
              (append carry (list (posix-string-match el fname))))
            excludes '(or)))))
       (directory-files-recursively default-directory regex))))

;;;;;; org files only

  (defun my-directory-files-recursively-ignore-org ()
    (my-directory-files-recursively-ignore "\.org"))

;;;;; project

  (defun my-projectile-project-files-current (&optional regex)
    (unless regex (setq regex ""))
    (require 'seq)
    (let ((proj-root (projectile-root-bottom-up default-directory)))
      (seq-filter
       (lambda (fname)
         (posix-string-match regex fname))
       (mapcar
        (lambda (file)
          (concat proj-root file))
        (projectile-project-files proj-root)))))

;;;; refile

  ;; https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
  (setq org-refile-targets '((nil . (:regexp . ".")))) ; include all headings
  ;; (setq org-refile-use-outline-path t) ; heading1/heading2/heading3
  (setq org-refile-use-outline-path 'file) ; file/heading1/heading2/heading3
  ;; (setq org-refile-use-outline-path 'full-file-path) ; /file/path/h1/h2/h3
  (setq org-outline-path-complete-in-steps nil) ; let helm work its magic
  ;; create a new parent as refile target
  (setq org-refile-allow-creating-parent-nodes 'confirm)

;;;;; recursive

  (defun my-org-refile-find-set-targets ()
    (setq org-refile-targets '((my-directory-files-recursively-ignore-org :maxlevel . 3))))
  ;; my-org-refile-find uses files that might be searched by ack for refile targets
  (defun my-org-refile-find ()
    (let ((rtargets org-refile-targets))
      (interactive)
      (my-org-refile-find-set-targets)
      (org-refile)
      (setq org-refile-targets rtargets)
      ))

;;;;; project

  (defun my-org-refile-project-set-targets ()
    (setq org-refile-targets '((my-projectile-project-files-current :maxlevel . 3))))
  (defun my-org-refile-project ()
    (interactive)
    (let ((rtargets org-refile-targets))
      (my-org-refile-project-set-targets)
      (org-refile)
      (setq org-refile-targets rtargets)
      ))

;;;;; agenda

  (defun my-org-refile-agenda-set-targets ()
    (setq org-refile-targets '((org-agenda-files :maxlevel . 3))))
  (defun my-org-refile-agenda ()
    (interactive)
    (let ((rtargets org-refile-targets))
      (my-org-refile-agenda-set-targets)
      (org-refile)
      (setq org-refile-targets rtargets)
      ))

;;;;; datetree

  ;; https://emacs.stackexchange.com/a/10762
  (defun my-org-refile-to-datetree (&optional file)
    "Refile a subtree to a datetree corresponding to it's timestamp.

The current time is used if the entry has no timestamp. If FILE
is nil, refile in the current file."
    (interactive "f")
    (let* ((datetree-date (or (org-entry-get nil "TIMESTAMP" t)
                              (org-read-date t nil "now")))
           (date (org-date-to-gregorian datetree-date))
           )
      (save-excursion
        (with-current-buffer (current-buffer)
          (org-cut-subtree)
          (if file (find-file file))
          (org-datetree-find-date-create date)
          (org-narrow-to-subtree)
          (outline-show-subtree)
          (org-end-of-subtree t)
          (newline)
          (goto-char (point-max))
          (org-paste-subtree 4)
          (widen)
          ))
      )
    )

;;;;; top level
  (defun my-org-refile-top (&optional file)
    (interactive "f")
    (save-excursion
      (let ((curr-buff (current-buffer)))
        (org-cut-subtree)
        (with-current-buffer (if file (find-file-noselect file)
                               (current-buffer))
          (widen)
          (org-show-all)
          (goto-char (point-max))
          (newline)
          (goto-char (point-max))
          (org-paste-subtree 1)
          (bookmark-set (plist-get org-bookmark-names-plist :last-refile))
          )
        )))

;;;; tags

  ;; https://orgmode.org/manual/Tag-hierarchy.html
  (setq org-tag-alist
        '(
          (:startgrouptag)
          ("emacs")
          (:grouptags)
          ("spacemacs")
          ("org")
          (:endgrouptag)
          (:startgrouptag)
          ("productivity")
          (:grouptags)
          ("org")
          (:endgrouptag)
          ))

;;;;; rename tags

  ;; derived from https://emacs.stackexchange.com/a/41447
  (defun my-change-tag (old new)
    (when (member old (org-get-tags))
      (org-toggle-tag new 'on)
      (org-toggle-tag old 'off)
      ))

;;;;;; buffer
  (defun my-org-rename-tag (old new &optional scope)
    (when (called-interactively-p)
      (interactive "scurrent tag: \nsnew name: "))
    ;; (message "%s" (list old new scope))
    (org-map-entries
      (lambda () (my-change-tag old new))
      (format "+%s" old)
      scope
      )
    )

;;;;;; project
  (defun my-org-rename-tag-project (old new)
    (interactive "scurrent tag: \nsnew name: ")
    ;; note that this fails if swap files are in list
    (my-org-rename-tag old new (my-projectile-project-files-current "/[^\.][^/]*\.org$")))

;;; declare packages
(defconst outshine-packages
  '(
    outshine
    ;; outorg
    ))

;;; config based on PR by siddharthist (Langston Barrett) on syl20bnr/spacemacs
;;;; outshine
(defun outshine/init-outshine ()
  (use-package outshine
    :defer t
    :init
    (progn
      (add-hook 'prog-mode-hook 'outline-minor-mode)
      (add-hook 'outline-minor-mode-hook 'outshine-mode))
    :config
    (progn
      (spacemacs/declare-prefix "an" "outline")
      (spacemacs/set-leader-keys
        "anS" 'outline-show-all
        "angh" 'outline-up-heading
        "angj" 'outline-forward-same-level
        "angk" 'outline-backward-same-level
        "angl" 'outline-next-heading
        "anih" 'outline-insert-heading
        "anK" 'outline-move-subtree-up
        "anJ" 'outline-move-subtree-down
        "anL" 'outline-demote
        "anH" 'outline-promote
        ))))
;;;; outorg
(defun outshine/init-outorg ()
  (use-package outorg
    :defer t
    :config
    (progn
      (spacemacs/declare-prefix "aon" "outorg")
      (spacemacs/set-leader-keys
        "aone" 'outorg-edit-as-org
        "aonq" 'outorg-copy-edits-and-exit
        )
      ;; (spacemacs/declare-prefix-for-mode 'org-mode "mO" "outorg")
      ;; (spacemacs/set-leader-keys-for-major-mode 'org-mode
      ;;   "Oq" 'outorg-copy-edits-and-exit)
      )))

;;; My raw attempt at a config
;; (defun outshine/pre-init-outshine ()
;;     (progn
;;       (defvar outline-minor-mode-prefix (kbd "M-#"))
;;       ;; (spacemacs/declare-prefix-for-mode 'outshine-mode "o")
;;       ;; (spacemacs/set-leader-keys
;;       ;;   "ogh" 'outshine-do-something)
;;       )
;;     )
;; (defun outshine/init-outshine ()
;;     (use-package outshine
;;       :ensure t
;;       ;; :init
;;       ;; (progn
;;       ;;   (spacemacs/declare-prefix-for-mode 'outshine-mode "o" "outshine")
;;       ;;   )
;;       )
;;   )

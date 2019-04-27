(defconst kubernetes-packages
  '(
    kubernetes-tramp
    kubernetes
    kubernetes-evil
    ))

(defun kubernetes/init-kubernetes ()
  (use-package kubernetes-tramp
    :ensure t))

(defun kubernetes/init-kubernetes ()
    (use-package kubernetes
      :ensure t
      :defer t
      :commands (kubernetes-overview)))

(defun kubernetes/init-kubernetes-evil ()
    (use-package kubernetes-evil
      :ensure t
      :after kubernetes))

;;;; diagram.asd

(asdf:defsystem #:diagram
  :description "Describe diagram here"
  :author "Wim Oudshoorn <woudshoo@xs4all.nl>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:cl-pdf #:cl-typesetting #:cl-typegraph #:diagram/diagram)
  :pathname "src/"
  :class :package-inferred-system
  :in-order-to ((test-op (test-op "diagram/test"))))

;; The systems are already required, but package inferred does not
;; know that the packages are loaded because of the name mismatch.
;; NOTE:  the cl-typegraph is an extension to cl-typesetting and
;; does not define a package by itself. Therefore:
;; 1. It has to be included in depends-on (it cannot automatically be inferred).
;; 2. There is no point in adding it with (asdf:register-system-packages ...) because
;;    only one system can associated with a package

(asdf:register-system-packages "cl-pdf" :pdf)
(asdf:register-system-packages "cl-typesetting" :typeset)
(asdf:register-system-packages "diagram/spec/spec-base" :spec)

;; This is strictly not needed, but it makes the dependency clear
(asdf:register-system-packages "diagram/diagram" :diagram)

;;--------------------------------------------------------------------------------
(asdf:defsystem "diagram/test"
  :depends-on ("diagram/driver" "diagram/spec/spec" "diagram/spec/spec-elements" "fiveam" "uiop")
  :pathname "t/"
  :components ((:file "test"))
  :perform (asdf:test-op (o c) (symbol-call :5am :run! :diagram)))





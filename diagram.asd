;;;; diagram.asd

(asdf:defsystem #:diagram
  :description "Describe diagram here"
  :author "Wim Oudshoorn <woudshoo@xs4all.nl>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:cl-pdf #:cl-typesetting #:cl-typegraph)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "diagram")
	       (:file "spec")
	       (:file "spec-elements")
	       (:file "file-node")
	       (:file "cluster"))
  :in-order-to ((test-op (test-op "diagram/test"))))


(asdf:defsystem "diagram/test"
  :depends-on ("diagram" "fiveam" "uiop")
  :pathname "t/"
  :components ((:file "test"))
  :perform (test-op (o c) (symbol-call :5am :run! :diagram)))

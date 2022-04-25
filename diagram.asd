;;;; diagram.asd

(asdf:defsystem #:diagram
  :description "Describe diagram here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:cl-pdf #:cl-typesetting #:cl-typegraph)
  :serial t
  :components ((:file "package")
               (:file "diagram")
	       (:file "spec")
	       (:file "spec-elements")
	       (:file "file-node")
	       (:file "test")))

;;;; diagram.asd

(asdf:defsystem #:diagram
  :description "Describe diagram here"
  :author "Wim Oudshoorn <woudshoo@xs4all.nl>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (#:cl-pdf #:cl-typesetting #:cl-typegraph)
  :pathname "src/"
  :components ((:file "package")
	       
	       (:module "spec"
		:components ((:file "package")
			     (:file "spec" :depends-on ("package"))
			     (:file "spec-elements" :depends-on ("spec" "package"))
			     (:file "file-node" :depends-on ("spec" "package"))
			     (:file "cluster" :depends-on ("spec" "package")))
		:depends-on ("package"))
	       
               (:file "diagram" :depends-on ("spec")))
  
  :in-order-to ((test-op (test-op "diagram/test"))))


(asdf:defsystem "diagram/test"
  :depends-on ("diagram" "fiveam" "uiop")
  :pathname "t/"
  :components ((:file "test"))
  :perform (asdf:test-op (o c) (symbol-call :5am :run! :diagram)))

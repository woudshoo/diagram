(in-package #:diagram)

(defun test-1 ()
  (create-diagram-pdf :in-file (asdf:system-relative-pathname  "diagram" "test.spec" ) :out-file #P "/tmp/test-diagram.pdf"))




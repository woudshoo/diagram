;;;; diagram.lisp

(in-package #:diagram)

(defun create-diagram-pdf (&key in-file out-file)
  (let ((graph (graph-from-spec-file in-file)))
    (compute-graph-layout graph)
    (with-document ()
      (with-page (:bounds
		      (make-array 4 :initial-contents `(-10 -10 ,(+ 10 (tt::dx graph)) ,(+ (tt::dy graph) 10)))) 
	(stroke graph  0 (+ (tt::dy graph) 0)))
      (write-document out-file))))


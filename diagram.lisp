;;;; diagram.lisp

(in-package #:diagram)

(defun create-diagram-pdf (&key in-file out-file)
  (let ((graph (graph-from-spec-file in-file)))
    (compute-graph-layout graph)
    (write-graph-pdf graph out-file)))

(defun write-graph-pdf (graph out-file)
  (with-document ()
    (with-page (:bounds
		(make-array 4 :initial-contents `(-10 -10 ,(+ 10 (dx graph)) ,(+ (dy graph) 10)))) 
      (stroke graph  0 (+ (dy graph) 0)))
    (write-document out-file)))

(defun dot-file-from-spec (in-file)
  (let ((graph (graph-from-spec-file in-file)))
    (tt::gen-graph-dot-data graph t)
    graph))

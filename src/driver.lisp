(uiop:define-package :diagram/driver
    (:import-from :diagram/spec/spec
		  #:graph-from-spec-file)
  (:import-from :pdf
		#:with-document
		#:with-page
		#:write-document)
  ;; Not sure how importing private symbols work
  (:import-from :typeset
		#:dx
		#:dy
		#:gen-graph-dot-data
		#:compute-graph-layout
		#:compute-graph-layout-cps
		#:stroke)
  (:export
   #:create-diagram-pdf
   #:dot-file-from-spec
   #:write-graph-pdf
   #:create-diagram-cps-pdf
   #:cps-problem
   #:cps-problem-simple))

(in-package :diagram/driver)


(setq tt::*dot-command* "/opt/homebrew/bin/dot")

(defun create-diagram-pdf (&key in-file out-file)
  (let ((graph (graph-from-spec-file in-file)))
    (compute-graph-layout graph)
    (write-graph-pdf graph out-file)))

(defun create-diagram-cps-pdf (&key in-file out-file)
  (let ((graph (graph-from-spec-file in-file)))
    (compute-graph-layout-cps graph)
    (write-graph-pdf graph out-file)))

(defun write-graph-pdf (graph out-file)
  (with-document ()
    (with-page (:bounds
		(make-array 4 :initial-contents `(-10 -10 ,(+ 10 (dx graph)) ,(+ (dy graph) 10)))) 
      (stroke graph  0 (+ (dy graph) 0)))
    (write-document out-file)))

(defun dot-file-from-spec (in-file)
  (let ((graph (graph-from-spec-file in-file)))
    (with-output-to-string (s)
      (tt::gen-graph-dot-data graph s))))

(defun cps-problem (in-file)
  (let ((graph (graph-from-spec-file in-file)))
    (typeset::make-graph-cps-problem graph)))

(defun cps-problem-simple (in-file)
  (let ((graph (graph-from-spec-file in-file)))
    (typeset::make-graph-cps-problem-simple graph)))

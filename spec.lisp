(in-package #:diagram)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reading and high-levelparsing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun graph-from-spec-file (file-name)
  "Read a SPEC from file FILE-NAME and returns a GRAPH object"
  (spec-to-graph-entry (parse-graph-spec file-name)))

(defun spec-to-graph-entry (spec)
  "Converts a SPEC into a TT:GRAPH object.

A SPEC is a lisp form of the form

  SPEC := (diagram [NODE | EDGE]*)

Where

 NODE := (node <NODE OPTIONS>)
 EDGE := ([--|<-|->|<->] <EDGE OPTIONS>)

...
"
  (if (fboundp (car spec))
      (apply (car spec) (cdr spec))
      (error "Symbol ~A is not defined" (car spec))))


(defun parse-graph-package ()
  "Returns the package used to read the SPEC files"
  (find-package 'spec))

(defun parse-graph-spec (file-name)
  (with-open-file (s file-name)
    (let ((*package* (parse-graph-package)))
      (let ((spec (read s)))
	spec))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Administration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *current-graph* nil "Current GRAPH to be creaded when converting SPEC to GRAPH")
(defparameter *current-id-node-map* nil "Maps ids to GRAPH nodes")



(defun get-node (id)
  (or (gethash id *current-id-node-map*)
      (setf (gethash id *current-id-node-map*)
	    (make-instance 'graph-node
			   :data (symbol-name id)
			   :graph *current-graph*))))

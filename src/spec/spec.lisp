(uiop:define-package :diagram/spec/spec
  (:export
   #:graph-from-spec-file
   #:*current-graph*
   #:*current-entity*
   #:get-node
   #:spec-to-graph-entry)
  (:import-from :spec)
  (:import-from :typeset
		#:graph-node))

;; the following package is for parsing/reading the spec files

(in-package :diagram/spec/spec)

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
  (cond
    ((eq 'defun (car spec)) (eval spec))
    ((fboundp (car spec))
     (apply (car spec) (cdr spec)))
    (t (error "Symbol ~A is not defined" (car spec)))))


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
(defparameter *current-entity* nil "Current entity, either GRAPH, NODE or EDGE.   Used for modifying the current object in generic option setting code.")

(defparameter *current-id-node-map* nil "Maps ids to GRAPH nodes")

(defun get-node (id)
  "Returns a node for ID.

If a node with ID already exists, return that one.  If no node is associated with ID, create a new one."
  (or (gethash id *current-id-node-map*)
      (setf (gethash id *current-id-node-map*)
	    (make-instance 'graph-node
			   :data (symbol-name id)
			   :graph *current-graph*))))


(defparameter *edge-class* 'tt::graph-edge)

(defun make-edge (id-a id-b &key edge-arrows (direction :nond))
  "Returns the default edge between ID-A and ID-B"
  (make-instance *edge-class*
		 :graph *current-graph*
		 :head (get-node id-a)
		 :tail (get-node id-b)
		 :edge-arrows edge-arrows
		 :direction direction
		 :width 0))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


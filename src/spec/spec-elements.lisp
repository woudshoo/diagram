(in-package #:diagram)


(defun spec::diagram (&rest entries)
  (let ((*current-graph* (make-instance 'graph
					:padding 10 ))
	(*current-id-node-map* (make-hash-table))
	(*edge-class* 'tt::graph-edge))
    (dolist (entry entries)
      (spec-to-graph-entry entry))
    *current-graph*))

(defun spec::edge-type (type)
  (ecase type
    (spec::ortho
     (spec::attributes '("splines" "ortho"))
     (setf *edge-class* 'tt::ortho-edge))
    (spec::bezier
     (setf *edge-class* 'tt::graph-edge))))

(defun spec::attributes (&rest entries)
  (setf (tt::dot-attributes *current-graph*)
	(append (tt::dot-attributes *current-graph*) entries)))

(defun spec::node (id label)
  (let* ((text (tt:compile-text (:font "Times-Roman" :font-size 12)
		 (etypecase label
		   (string (tt::put-string label))
		   (t (eval label)))))
	 (vbox (tt::make-filled-vbox text 70 400)))
    (change-class (get-node id) 'graph-node :data vbox :decoration tt::+box+)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun spec::same-rank (&rest ids)
  (add-rank-constraint *current-graph* "same"
		       (mapcar #'get-node ids)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun spec::-> (id-a id-b)
  (make-edge id-a id-b :edge-arrows '(:head :arrow) :direction :right))

(defun spec::-o (id-a id-b)
  (make-edge id-a id-b :edge-arrows '(:head :circle) :direction :right))

(defun spec::<- (id-a id-b)
  (make-edge id-a id-b :edge-arrows '(:tail :arrow) :direction :right))

(defun spec::-- (&rest node-ids)
  (loop :for (id-a id-b) :on node-ids
	:while id-b
	:do
	   (make-edge id-a id-b :direction :down)))

(defun spec::<-> (id-a id-b)
  (make-edge id-a id-b :edge-arrows '(:tail :arrow :head :arrow) :direction :down))




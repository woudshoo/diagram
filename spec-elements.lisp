(in-package #:diagram)


(defun spec::diagram (&rest entries)
  (let ((*current-graph* (make-instance 'graph
					:decoration (make-instance 'file-node-decoration :file-type "GRAPH")
					:padding 10 ))
	(*current-id-node-map* (make-hash-table)))
    (dolist (entry entries)
      (spec-to-graph-entry entry))
    *current-graph*))

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
  (make-instance 'tt::ortho-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows  '(:head :arrow)))

(defun spec::-o (id-a id-b)
  (make-instance 'tt::ortho-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows  '(:head :circle)))

(defun spec::<- (id-a id-b)
  (make-instance 'tt::ortho-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows '(:tail :arrow)))

(defun spec::-- (&rest node-ids)
  (loop :for (id-a id-b) :on node-ids
	:while id-b
	:do
	   (make-instance 'tt::ortho-edge :graph *current-graph*
				      :head (get-node id-a) :tail (get-node id-b)
				      :edge-arrows nil)))

(defun spec::<-> (id-a id-b)
  (make-instance 'tt::ortho-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows '(:tail :arrow :head :arrow)))




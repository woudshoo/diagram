(in-package #:diagram)


(defun spec::diagram (&rest entries)
  (let ((*current-graph* (make-instance 'graph :border-width nil))
	(*current-id-node-map* (make-hash-table)))
    (dolist (entry entries)
      (spec-to-graph-entry entry))
    *current-graph*))


(defun spec::node (id label)
  (let* ((text (tt:compile-text (:font "Times-Roman" :font-size 12 :color '(1 0 0))
		 (etypecase label
		   (string (tt::put-string label))
		   (t (eval label)))))
	 (vbox (tt::make-filled-vbox text 70 400))
	 (node (make-instance 'graph-node :fixed-width t :data vbox :graph *current-graph* :decoration nil)))
    (register-node id node)
    node))

(defun spec::-> (id-a id-b)
  (make-instance 'graph-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows  '(:head :arrow)))

(defun spec::-o (id-a id-b)
  (make-instance 'graph-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows  '(:head :circle)))

(defun spec::<- (id-a id-b)
  (make-instance 'graph-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows '(:tail :arrow)))

(defun spec::-- (id-a id-b)
  (make-instance 'graph-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows nil))

(defun spec::<-> (id-a id-b)
  (make-instance 'graph-edge :graph *current-graph*
			     :head (get-node id-a) :tail (get-node id-b)
			     :edge-arrows '(:tail :arrow :head :arrow)))


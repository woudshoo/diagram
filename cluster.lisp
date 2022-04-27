(in-package #:diagram)

(defclass cluster (graph-node)
  ()
  (:default-initargs :data (list)))


(defmethod adjust-graph-node-size ((cluster cluster) data fixed-width fixed-height)
  (loop :for b :in (data cluster)
	:for x = (x b)
	:for y = (y b)
	:for dx = (dx b)
	:for dy = (dy b)
	:maximizing (+ x dx) :into max-x
	:maximizing y  :into max-y
	:minimizing x :into min-x
	:minimizing (- y dy) :into min-y
	:finally (setf (x cluster) min-x
		       (dx cluster) (- max-x min-x)
		       (y cluster)  max-y
		       (dy cluster) (- max-y min-y)))
  (call-next-method)
  (decf (x cluster) (tt::content-offset-x cluster))
  (incf (y cluster) (tt::content-offset-y cluster)))


(defmethod gen-graph-dot-data ((cluster cluster) s)
  (format s "subgraph cluster_~a {~{~s;~^ ~}};~%" (id cluster) (mapcar #'id (data cluster))))


(defmethod stroke-node ((cluster cluster) data)
  (adjust-graph-node-size cluster data nil nil)
  (call-next-method cluster nil))


(defun spec::cluster (&rest nodes)
  (make-instance 'cluster :data (mapcar #'get-node nodes)
			  :decoration (make-instance 'graph-node-decoration-box
						     :background-color '(0.0 1.0 1.0)
						     :background-transparency 0.3
						     :border-color '(0.0 1.0 1.0))
			  :graph *current-graph*))

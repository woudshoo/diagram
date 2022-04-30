(in-package #:diagram)








(defun spec::cluster (&rest nodes)
  (make-instance 'tt::graph-cluster :data (mapcar #'get-node nodes)
			  :decoration (make-instance 'file-node-decoration
						     :file-type ".CLU"
						     :background-color '(0.0 1.0 1.0)
						     :background-transparency 0.1
						     :border-color '(0.0 1.0 1.0))
			  :graph *current-graph*))

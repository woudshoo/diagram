(in-package #:diagram)

(defclass cluster ()
  ((id :accessor id :initform (make-graph-node-id))
   (decoration :accessor decoration :initarg :decoration :initform tt::+box+)
   (data :accessor data :initarg :data :initform (list))))


(defmethod initialize-instance :after ((cluster cluster)
				       &key graph &allow-other-keys)
  (when graph (add-node graph cluster)))

(defmethod gen-graph-dot-data ((cluster cluster) s)
  (format s "subgraph cluster_~a {~{~s;~^ ~}};~%" (id cluster) (mapcar #'id (data cluster))))

(defun min-x (list)
  (loop :for b :in list
	:minimizing (x b)))

(defun min-y (list)
  (loop :for b :in list
	:minimizing (- (y b) (dy b))))

(defun max-x (list)
  (loop :for b :in list
	:maximizing (+ (x b) (dx b))))

(defun max-y (list)
  (loop :for b :in list
	:maximizing (y b)))

(defmethod stroke-node ((cluster cluster) data)
  (pdf:with-saved-state
    (pdf:set-color-stroke '(0.0 1.0 0.0))
    (pdf:basic-rect (min-x data) (min-y data) (- (max-x data) (min-x data)) (- (max-y data) (min-y data)))
    (pdf:stroke)))


(defun spec::cluster (&rest nodes)
  (make-instance 'cluster :data (mapcar #'get-node nodes) :graph *current-graph*))

(in-package #:diagram)


;;
;;  +---------------------+
;;  |/FILE/          .CSV |
;;  +---------------------+
;;  | CONENT              |
;;  |                     |
;;  |                     |                     
;;  +---------------------+ 

(defclass file-node (graph-node)
  ((file-type :accessor file-type :initarg :file-type :initform ".unknown")
   (top-height :accessor top-height :initarg :top-height :initform 10)))


(defmethod adjust-graph-node-size ((node file-node) data fixed-width fixed-height)
  (call-next-method)
  (incf (dy node) (top-height node)))

(defmethod stroke-node ((node file-node) data)
  (call-next-method)
  (let* ((th (top-height node))
	 (x0 (x node))
	 (x1 (+ (x node) (dx node)))
	 (y (- (y node) th)))
    (pdf:with-saved-state
      (pdf:set-color-stroke '(0.9 0.5 0.9))
      (pdf:set-color-fill '(0.9 0.5 0.9))
      (pdf:rectangle x0 y (dx node) th)
      (pdf:fill-and-stroke))
    (pdf:draw-right-text (+ x0 (* 0.15 th)) (+ y (* 0.15 th)) "FILE" (pdf:get-font "Helvetica-Oblique") th)
    (pdf:draw-left-text (- x1 (* 0.15 th)) (+ y (* 0.15 th)) (file-type node) (pdf:get-font "Courier") th)))



(defun spec::file-node (id file-type content)
  (let* ((text (tt:compile-text (:font "Times-Roman" :font-size 12 :color '(1 0 0)) (tt::put-string content)))
	 (vbox (tt::make-filled-vbox text 70 400))
	 (node (make-instance 'file-node :data vbox
					 :graph *current-graph*
					 :file-type file-type)))
    (register-node id node)
    (setf (offset vbox) (- (top-height node)))
    node))


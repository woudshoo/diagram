(in-package #:diagram)


;;
;;  +---------------------+
;;  |/FILE/          .CSV |
;;  +---------------------+
;;  | CONTENT             |
;;  |                     |
;;  |                     |                     
;;  +---------------------+ 

(defclass file-node-decoration (tt::box-decoration)
  ((file-type :accessor file-type :initarg :file-type :initform ".unknown"))
  (:default-initargs :size-adjust '(0 10 0 0)))

(defmethod tt::stroke-decoration ((node box) (decoration file-node-decoration))
  (call-next-method)
  (with-quad (l-a t-a) (tt::size-adjust decoration)
    (let* ((th t-a)
	   (x0 (x node))
	   (x1 (+ (x node) (dx node)))
	   (y (- (y node) th)))

      (pdf:with-saved-state
	(pdf:set-color-stroke '(0.9 0.5 0.9))
	(pdf:set-color-fill '(0.9 0.5 0.9))
	(pdf:rectangle x0 y (dx node) th)
	(pdf:fill-and-stroke))
      (pdf:draw-right-text (+ x0 (* 0.15 th)) (+ y (* 0.15 th)) "FILE" (pdf:get-font "Helvetica-Oblique") th)
      (pdf:draw-left-text (- x1 (* 0.15 th)) (+ y (* 0.15 th)) (file-type decoration) (pdf:get-font "Courier") th))))


(defun spec::file-node (id file-type content)
  (let* ((text (tt:compile-text (:font "Times-Roman" :font-size 12) (tt::put-string content)))
	 (vbox (tt::make-filled-vbox text 70 400)))
    (change-class (get-node id) 'graph-node
		  :data vbox
		  :decoration (make-instance 'file-node-decoration :file-type file-type))))


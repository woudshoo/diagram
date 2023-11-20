(uiop:define-package :diagram/spec/class-node
    (:import-from :typeset
		  #:box-decoration
		  #:stroke-decoration
		  #:with-quad
		  #:graph-node
		  #:dx
		  #:x
		  #:y
		  #:box)
  (:import-from :pdf
		#:set-line-width
		#:set-color-stroke
		#:set-color-fill
		#:rectangle
		#:fill-and-stroke
		#:draw-right-text
		#:draw-centered-text
		#:compile-text
		#:make-filled-vbox)
  (:import-from :diagram/spec/spec
		#:get-node))

(in-package :diagram/spec/class-node)


;;;
;;; +----------------------------------+
;;; | (C)      Class Name              |
;;; +----------------------------------+
;;; | ret-t    name (argument types,..)|
;;; | ...                              |
;;; +----------------------------------+

(defclass class-node-decoration (tt::box-decoration)
  ((class-name :accessor class-name :initarg :class-name :initform ".unknown"))
  (:default-initargs :size-adjust '(0 10 0 0)
		     :border-width 0))



(defmethod tt::stroke-decoration ((node box) (decoration class-node-decoration))
  (call-next-method)
  (with-quad (l-a t-a) (tt::size-adjust decoration)
    (let* ((th t-a)
	   (x0 (x node))
	   (w (dx node))
#+nil	   (x1 (+ x0 w))
	   (y (- (y node) th)))

      (pdf:with-saved-state
	(pdf:set-line-width 0)
	(pdf:set-color-stroke '(0.9 0.9 0.5))
	(pdf:set-color-fill '(0.5 0.9 0.9))
	(pdf:rectangle x0 y w th)
	(pdf:fill-and-stroke))
      (pdf:draw-right-text (+ x0 (* 0.15 th)) (+ y (* 0.15 th)) "A" (pdf:get-font "Helvetica-Oblique") th)
      (pdf:draw-centered-text (+ x0 (* 0.5 w)) (+ y (* 0.15 th)) (class-name decoration) (pdf:get-font "Helvetica") th))))


(defun spec::class-node (id class-name &optional (content ""))
  (let* ((text (tt:compile-text (:font "Times-Roman" :font-size 12) (tt:put-string content)))
	 (vbox (tt::make-filled-vbox text 100 400)))
    (change-class (get-node id) 'graph-node
		  :data  vbox 
		  :decoration (make-instance 'class-node-decoration :class-name class-name))))

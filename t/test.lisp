(defpackage #:diagram/test
  (:use #:cl #:5am #:diagram/driver #:diagram/spec/spec #:diagram/spec/spec-elements #:tt)
  (:import-from #:tt dx dy))

(in-package #:diagram/test)


(defun file-size (fn)
  (with-open-file (file fn) 
    (file-length file)))

(defun file-not-empty-p (fn)
  (> (file-size fn) 0))

(defmacro with-temporary-file ((fn) &body body)
  `(uiop:call-with-temporary-file
    (lambda (,fn)
      ,@body)
   :want-stream-p nil))

(def-suite :diagram)
(in-suite :diagram)

(pdf::load-ttf-font "/System/Library/PrivateFrameworks/FontServices.framework/Versions/A/Resources/Fonts/ApplicationSupport/SchoolHouse Printed A.ttf")
;;; This gave the following error
;;; kerning subtable value: #x0 (expected #x1)
;;;   [Condition of type ZPB-TTF::UNSUPPORTED-FORMAT]
;;; OK.


					;(pdf::load-ttf-font "/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/matplotlib/mpl-data/fonts/ttf/STIXGeneral.ttf")
;(pdf::load-ttf-font "/System/Library/Fonts/Supplemental/STIXGeneral.otf")

(pdf::load-ttf-font  "/System/Library/PrivateFrameworks/FontServices.framework/Versions/A/Resources/Fonts/ApplicationSupport/SchoolHouse Cursive B.ttf")
;;; error:
;;;; Evaluation aborted on #<TYPE-ERROR expected-type: (MOD 1114112) datum: 2097168>.
;;; (during parsing cmap I think)
;;; NOW OK.

;;; (test-font #P"/System/Library/Fonts/Supplemental/Zapfino.ttf" "/tmp/helvetica.pdf")
;; error: Unsupported version value in "kern" table: #x00000001 (expected #x00000000)

;(pdf::load-ttf-font "/usr/local/texlive/2017/texmf-dist/fonts/truetype/google/noto/NotoMono.ttf")
(pdf:load-ttf-font (asdf:system-relative-pathname "diagram" "t/NotoSansMono-Regular.ttf"))



;(pdf::load-ttf-font "/usr/local/texlive/2017/texmf-dist/fonts/truetype/public/padauk/PadaukBook-Bold.ttf")
(pdf:load-ttf-font (asdf:system-relative-pathname "diagram" "t/PadaukBook-Bold.ttf"))

(test test-1
  (with-temporary-file (fn)
    (create-diagram-pdf :in-file (asdf:system-relative-pathname  "diagram" "test.spec" ) :out-file fn)
    (is-true (file-not-empty-p fn))))

(test test-2
  (with-temporary-file (fn)
    (create-diagram-pdf :in-file (asdf:system-relative-pathname  "diagram" "rmfmagic.spec" ) :out-file fn)
    (is-true (file-not-empty-p fn))))

(test dot-1 
  (is-true (dot-file-from-spec (asdf:system-relative-pathname  "diagram" "test.spec" ) )))

(test dot-2 
  (is-true (dot-file-from-spec (asdf:system-relative-pathname  "diagram" "rmfmagic.spec" ) )))


(test cps-1 
  (let ((graph
	  (typeset::compute-graph-layout-cps (graph-from-spec-file (asdf:system-relative-pathname "diagram" "test-simple.spec")) )))
    (is-true graph "Graph is at least generated")
    (write-graph-pdf graph #P "/tmp/cps-1.pdf" )
    (is-true graph "testing is graph creation worked")))

(defmethod stroke :after ((box tt::text-line) x y)
  (when (and nil (> (dy box) 3))
    (pdf:with-saved-state
      (pdf:set-color-stroke '(1.0 1.0 0))
      (pdf:basic-rect x y (dx box) (- (dy box)))
      (pdf:stroke)
      (pdf:set-color-stroke '(0.0 0.0 1.0))
      (pdf:move-to x (- y (tt::internal-baseline box)))
      (pdf:line-to (+ x (dx box)) (- y (tt::internal-baseline box)))
      (pdf:stroke))))



(defparameter *ff* nil)
(defparameter *fs* nil)

(defun draw-font-box (box x y)
  (pdf:with-saved-state
    (tt::map-boxes box x y (lambda (b x y)
			     (when (tt::char-box-p b)
			       (let* ((nx x)
				      (ex (+ nx (dx b)))
				      (ny (+ y (tt::baseline b)))
				      (by y)
				      (ay (+ by (pdf:get-font-ascender *ff* *fs*)))
				      (dy (+ by (pdf:get-font-descender *ff* *fs*)))
				      (xy (+ by (* *fs* (pdf::x-height *ff*))))
				      (cy (+ by (* *fs* (pdf::cap-height *ff*)))))
				 (pdf:set-color-stroke '(0 0 0.9))
				 (pdf:basic-rect nx ny (dx b) (- (dy b)))
				 (pdf:stroke)
				 (pdf:set-color-stroke '(0 0.9 0))
				 (pdf:move-to nx by)
				 (pdf:line-to ex by)
				 (pdf:stroke)
				 (pdf:set-color-stroke '(0.5 0 0))
				 (pdf:move-to nx ay)
				 (pdf:line-to ex ay)
				 (pdf:stroke)
				 (pdf:set-color-stroke '(0.5 0.5 0))
				 (pdf:move-to nx dy)
				 (pdf:line-to ex dy)
				 (pdf:stroke)
				 (pdf:set-color-stroke '(0 0.5 0.5))
				 (pdf:move-to nx xy)
				 (pdf:line-to ex xy)
				 (pdf:stroke)
				 (pdf:set-color-stroke '(0.5 0 0.5))
				 (pdf:move-to nx cy)
				 (pdf:line-to ex cy)
				 (pdf:stroke)
				 ))))
    ))


(defun test-font (font-file outfile)
  (let* ((font (etypecase font-file
		 (pathname (pdf:load-ttf-font font-file))
		 (string (pdf::font-metrics (pdf:get-font font-file)))))
	 (font-name (pdf:font-name font))
	 (*ff* font)
	 (*fs* 80))
    (pdf:with-document ()
      (pdf:with-page ()
	(let* ((content (tt::compile-text ()
			 (tt::paragraph (:font font-name :font-size *fs* :color '(0.5 0.5 0.5))
			   "AVjQh" :eol "vclT")))
	       (content-2 (tt::compile-text ()
			    (tt::paragraph (:font "Times-Roman" :font-size 10)
			      "font name: " (tt::put-string (pdf:font-name *ff*)) :eol
			      "x-height: " (tt::put-string (format nil "~A" (pdf::x-height *ff*))) :eol
			      "cap-height: " (tt::put-string (format nil "~A" (pdf::cap-height *ff*))) :eol
			      "ascender: " (tt::put-string (format nil "~A" (pdf:get-font-ascender *ff*))) :eol
			      "descener: "  (tt::put-string (format nil "~A" (pdf:get-font-descender *ff*))) :eol
			      "leading: " (tt::put-string (format nil "~A" (pdf::leading *ff*)))
			      ))))
	  (tt::draw-block content 20 520 500 700 :special-fn #'draw-font-box)
	  (tt::draw-block content-2 20 600 500 200)))
      (pdf:write-document outfile)
      font)))





#+nil (defun gen-box-graph ()
  (let* ((g1 (make-instance 'graph :dot-attributes '(#+nil("rankdir" "LR")("nodesep" "0.3")("ranksep" "0.8") ("splines" "ortho"))
				   :max-dx 500 :max-dy 300))
	 (n1 (make-instance 'graph-node :data "box" :graph g1))
	 (n2 (make-instance 'graph-node :data "h-mode-mixin" :graph g1))
	 (n3 (make-instance 'graph-node :data "v-mode-mixin" :graph g1))
	 (n5 (make-instance 'graph-node :data "soft-box" :graph g1))
	 (n6 (make-instance 'graph-node :data "container-box" :graph g1))
	 (n7 (make-instance 'graph-node :data "vbox" :graph g1))
	 (n8 (make-instance 'graph-node :data "hbox" :graph g1))
	 (n9 (make-instance 'graph-node :data "glue" :graph g1))
	 (n10 (make-instance 'graph-node :data "hglue" :graph g1))
	 (n11 (make-instance 'graph-node :data "vglue" :graph g1))
	 (n12 (make-instance 'graph-node :data "spacing" :graph g1))
	 (n13 (make-instance 'graph-node :data "h-spacing" :graph g1))
	 (n14 (make-instance 'graph-node :data "v-spacing" :graph g1))
	 (n15 (make-instance 'graph-node :data "char-box" :graph g1))
	 (n16 (make-instance 'graph-node :data "white-char-box" :graph g1)))
    (add-rank-constraint g1 "same" (list n1 n5 n15))
    (make-instance 'tt::ortho-edge :head n1 :tail n5 :label "subclass" :graph g1)
    (make-instance 'tt::ortho-edge :head n5 :tail n6 :graph g1)
    (make-instance 'tt::ortho-edge :head n6 :tail n7 :graph g1)
    (make-instance 'tt::ortho-edge :head n2 :tail n7 :graph g1)
    (make-instance 'tt::ortho-edge :head n6 :tail n8 :graph g1)
    (make-instance 'tt::ortho-edge :head n3 :tail n8 :graph g1)
    (make-instance 'tt::ortho-edge :head n5 :tail n9 :graph g1)
    (make-instance 'tt::ortho-edge :head n9 :tail n10 :graph g1)
    (make-instance 'tt::ortho-edge :head n2 :tail n10 :graph g1)
    (make-instance 'tt::ortho-edge :head n9 :tail n11 :graph g1)
    (make-instance 'tt::ortho-edge :head n3 :tail n11 :graph g1)
    (make-instance 'tt::ortho-edge :head n5 :tail n12 :graph g1)
    (make-instance 'tt::ortho-edge :head n12 :tail n13 :graph g1)
    (make-instance 'tt::ortho-edge :head n2 :tail n13 :graph g1)
    (make-instance 'tt::ortho-edge :head n12 :tail n14 :graph g1)
    (make-instance 'tt::ortho-edge :head n3 :tail n14 :graph g1)
    (make-instance 'tt::ortho-edge :head n1 :tail n15 :graph g1)
    (make-instance 'tt::ortho-edge :head n2 :tail n15 :graph g1)
    (make-instance 'tt::ortho-edge :head n10 :tail n16 :graph g1)
    (compute-graph-layout g1)
    g1))



(defun unicode-octets-to-string (octets)
  (let ((string (make-string (/ (length octets) 2))))
    (flet ((ref16 (i)
             (+ (ash (aref octets i) 16)
                (aref octets (1+ i)))))
      (loop for i from 0 below (length octets) by 2
            for j from 0
	    :collect (ref16 i)))))

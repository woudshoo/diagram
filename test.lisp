(in-package #:diagram)



;;;(pdf::load-ttf-font "/System/Library/PrivateFrameworks/FontServices.framework/Versions/A/Resources/Fonts/ApplicationSupport/SchoolHouse Printed A.ttf")
;;; This gave the following error
;;; kerning subtable value: #x0 (expected #x1)
;;;   [Condition of type ZPB-TTF::UNSUPPORTED-FORMAT]



(pdf::load-ttf-font "/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/matplotlib/mpl-data/fonts/ttf/STIXGeneral.ttf")

;;;(pdf::load-ttf-font  "/System/Library/PrivateFrameworks/FontServices.framework/Versions/A/Resources/Fonts/ApplicationSupport/SchoolHouse Cursive B.ttf")
;;; error:
;;;; Evaluation aborted on #<TYPE-ERROR expected-type: (MOD 1114112) datum: 2097168>.
;;; (during parsing cmap I think)

;;; (test-font #P"/System/Library/Fonts/Supplemental/Zapfino.ttf" "/tmp/helvetica.pdf")
;; error: Unsupported version value in "kern" table: #x00000001 (expected #x00000000)

(pdf::load-ttf-font "/usr/local/texlive/2017/texmf-dist/fonts/truetype/google/noto/NotoMono.ttf")




(pdf::load-ttf-font "/usr/local/texlive/2017/texmf-dist/fonts/truetype/public/padauk/PadaukBook-Bold.ttf")

(defun test-1 ()
  (create-diagram-pdf :in-file (asdf:system-relative-pathname  "diagram" "test.spec" ) :out-file #P "/tmp/test-diagram.pdf"))



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
			   "AjQh" :eol "vclT")))
	       (content-2 (tt::compile-text ()
			    (tt::paragraph (:font "Times-Roman" :font-size 10)
			      "font name: " (tt::put-string (pdf:font-name *ff*)) :eol
			      "x-height: " (tt::put-string (format nil "~A" (pdf::x-height *ff*))) :eol
			      "cap-height: " (tt::put-string (format nil "~A" (pdf::cap-height *ff*))) :eol
			      "ascender: " (tt::put-string (format nil "~A" (pdf:get-font-ascender *ff*))) :eol
			      "descener: "  (tt::put-string (format nil "~A" (pdf:get-font-descender *ff*))) :eol
			      "leading: " (tt::put-string (format nil "~A" (pdf::leading *ff*)))
			      ))))
	  (tt::draw-block content 20 520 500 500 :special-fn #'draw-font-box)
	  (tt::draw-block content-2 20 600 500 200)))
      (pdf:write-document outfile))))

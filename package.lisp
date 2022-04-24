;;;; package.lisp

(defpackage #:diagram
  (:use #:cl)
  (:import-from "TT"
		"GRAPH" "GRAPH-NODE" "GRAPH-EDGE"
		"COMPUTE-GRAPH-LAYOUT"
		"WITH-DOCUMENT"
		"WITH-QUAD"
		"BOX"
		"PADDING"
		"BORDER-COLOR"
		"X" "Y"
		"DX" "DY"
		"OFFSET"
		"ADJUST-GRAPH-NODE-SIZE"
		"STROKE" "STROKE-NODE" "STROKE-NODE-CONTENT")
  (:import-from "PDF"
		"WITH-PAGE"
		"WRITE-DOCUMENT"))

(defpackage #:spec
  (:use common-lisp)
  (:documentation "Package that is used to read SPEC files.

The idea is to use READ to read the spec file and all symbols will
be interned in the SPEC package.  However, not sure if we should use the COMMON-LISP package.
One idea is to allow code to be executed later with EVAL.
"))


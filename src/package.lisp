;;;; package.lisp

(defpackage #:diagram
  (:use #:cl)
  (:import-from "TT"
		"GRAPH" "GRAPH-NODE" "GRAPH-EDGE"
		"BOX-DECORATION"
		"COMPUTE-GRAPH-LAYOUT"
		"WITH-DOCUMENT"
		"WITH-QUAD"
		"BOX"
		"PADDING"
		"BORDER-COLOR"
		"X" "Y"
		"DX" "DY"
		"OFFSET"
		"MAKE-GRAPH-NODE-ID"
		"ABSTRACT-GRAPH-NODE"
		"ADJUST-GRAPH-NODE-SIZE"
		"STROKE" "STROKE-NODE" "STROKE-NODE-CONTENT"
		"ADJUST-GRAPH-NODE-SIZE"
		"GEN-GRAPH-DOT-DATA"
		"ADD-RANK-CONSTRAINT"
		"ID"
		"DATA")
  (:import-from "PDF"
		"WITH-PAGE"
		"WRITE-DOCUMENT")
  (:export
   #:create-diagram-pdf
   #:dot-file-from-spec
   #:graph-from-spec-file
   #:write-graph-pdf))

(defpackage #:spec
  (:use common-lisp)
  (:documentation "Package that is used to read SPEC files.

The idea is to use READ to read the spec file and all symbols will
be interned in the SPEC package.  However, not sure if we should use the COMMON-LISP package.
One idea is to allow code to be executed later with EVAL.
"))


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




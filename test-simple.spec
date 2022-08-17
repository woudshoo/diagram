;; -*- mode:lisp -*-
(diagram
 (defun f-node (id desc) (file-node id ".TST" desc))
 (defun bold (string) `(tt::with-style  (:font-size 8 :h-align :center :font "Helvetica-Bold") ,string))
 (defun stix (string) (tt::with-style (:font "STIXGeneral-Regular") string))
 (defun noto (string) (tt::with-style (:font "NotoMono") string))
 (defun pbook (string) (tt::with-style (:font "PadaukBook-Bold")  string))

; (edge-type ortho)
; (attributes ("splines" "ortho"))
 (node b "j box")
 (node h "h-mode-mixin j")
 (node c (bold "cast j"))
 (node d (tt::paragraph (:font "Helvetica") (tt::with-style  (:font-size 8 :h-align :center :font "Helvetica-Bold") "j HEAD") :eol "And j more" :eol (bold "j Next line")))
 (file-node f ".csv" "A nice j file")
 (node g (tt::paragraph () (pbook "And a j test") :eol (pbook "Another j") :eol (pbook "Last-j")))
 (node a1 "A1")
 (node a2 "A2")
 (node a3 "A3")
 (node a4 "A4")
 (-- a1 a2)
 (-- a2 a3)
 (-- a3 a4)
 (-- a1 a3)
 (-- a2 a4)
 (-- a1 a4)
 (node b1 "B1")
 (node b2 "B2")
 (node b3 "B3")
 (node b4 "B4")
 (node b5 "B5")
 (node b6 "B6")
; (-- b1 b2)
; (-- b2 b3)
; (-- b3 b4)
; (-- b4 b5)
					; (-- b5 b6)
 (-- x1 x2 x3)
 (f-node x3 "X3 for real")
 (-- b1 b2 b3 b4 b5 b6)
; (same-rank f g h)
; (same-rank b c)
; (cluster b h c)
; (cluster a1 a3 f)
 (-o b h)
 (<- b h)
 (<- b f)
 (-- b c)
 (<-> b c)
	  

 )
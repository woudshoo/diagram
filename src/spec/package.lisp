(defpackage #:spec
  (:use common-lisp)
  (:documentation "Package that is used to read SPEC files.

The idea is to use READ to read the spec file and all symbols will
be interned in the SPEC package.  However, not sure if we should use the COMMON-LISP package.
One idea is to allow code to be executed later with EVAL.
"))

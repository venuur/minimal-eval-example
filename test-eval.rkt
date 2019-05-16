#lang racket
(require rackunit)

; What works but requires a file per small test.
(check-equal?
 ((dynamic-require "test-script.rkt" 'gs-program-result))
 "123")

; What I would like to work
;(check-equal?
; (with-output-to-string (eval "lang minimal-eval-example" "1 2 3"))
; "123")

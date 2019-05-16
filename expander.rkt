#lang br
(require racket/block)

(provide (rename-out [golfscript-module-begin #%module-begin]
                     [golfscript-top #%top]))
(provide #%app #%datum #%top-interaction require)
(provide (matching-identifiers-out #rx"^gs-" (all-defined-out)))

;; Globals
(define gs-program-result (make-parameter ""))
(define gs-stack (make-parameter empty))

;;; Module begin.
(define-macro (golfscript-module-begin PROGRAM)
  #'(#%module-begin
     (provide gs-program-result gs-stack)
     PROGRAM))

;;; Top
;; Alter top level undefined behavior. Ignore undefined variables.
(define-macro (golfscript-top . ID)
  (if (identifier-binding #'ID) #'ID #'(void)))

;;; Syntax
(define-macro (gs-program EXPR ...)
  ;; Vars are self-evaluating so all we need to do is display the stack.
  (syntax/loc caller-stx
    (block
     EXPR ...
     (gs-program-result (gs-display-stack))
     (display (gs-program-result)))))
(define-macro (gs-var VAR)
  (syntax/loc caller-stx (gs-val VAR)))

(define (gs-display-stack)
  ;Stack must be reversed to display with top on right.
  (gs-stack (reverse (gs-stack)))
  (string-trim
     (with-output-to-string
       (λ () (until (empty? (gs-stack)) (display (gs-pop!  gs-stack)))))
     "\""))

(define (gs-push! a-stack value)
  (a-stack (cons value (a-stack))))
(define (gs-pop! a-stack)
  (define top (first (a-stack)))
  (a-stack (rest (a-stack)))
  top)
(define (gs-val a-var)
  (cond
    ;; Numbers have their literal value as their default value.
    [(number? a-var) (gs-push! gs-stack a-var)]
    ;; Undefined values are ignored. Otherwise we push the new vlaue to the stack.
    [(not (void? a-var)) (gs-push! gs-stack a-var)]
    ))

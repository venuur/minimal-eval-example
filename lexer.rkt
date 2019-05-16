#lang br
(require brag/support)

(provide basic-lexer)

(define-lex-abbrev letters (:+ (char-set "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")))
(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev newline (:or "\r\n" (char-set "\r\n")))

(define basic-lexer
  (lexer-srcloc
   ;; words--original regex: [a-zA-Z_][a-zA-Z0-9_]*
   [(:seq (:+ (:or letters "_"))
          (:* (:or letters "_" digits)))
    (token 'WORD (string->symbol lexeme))]
   ;; integers--original regex part: -?[0-9]+
   [(:seq (:? "-") (:+ digits))
    (token 'INTEGER (string->number lexeme))]
   ;; ignore newlines--not explicit in original, but I don't think they're symbols.
   [(:= 1 newline)
    (token 'NEWLINE lexeme #:skip? #t)]
   ;; symbols (any single character except newlines)--original regex part: ."
   [(:~ (char-set "\r\n"))
    (token 'SYMBOL (string->symbol lexeme))]
   ))

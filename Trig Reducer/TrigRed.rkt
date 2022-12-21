#lang racket 
;now this will actually do reductions!
(require "TrigProd.rkt")
;list-trieify trie-listify trig-add trig-sub trig-mul trig-exp make-tp tp access

(define (sinx n)
  (cond
    [(< n 0) (trie-invert (sinx (- 0 n)))]
    [(= 0 n) (list-trieify (list (tp 1 0 0)))] ;return 1
    [(= 1 n) (list-trieify (list (tp 1 1 0)))] ;return sin x
    [(even? n) (trig-mul (list-trieify (list (tp 2 0 0))) (trig-mul (sinx (quotient n 2)) (cosx (quotient n 2))))]
    [#t (trig-add (trig-mul (sinx (quotient n 2)) (cosx (+ (quotient n 2) 1))) (trig-mul (cosx (quotient n 2))(sinx (+ (quotient n 2) 1))))]
    )
)
(define (cosx n)
  (cond
    [(< n 0) (cosx (- 0 n))]
    [(= 0 n) (list-trieify (list (tp 1 0 0)))] ;return 1
    [(= 1 n) (list-trieify (list (tp 1 0 1)))] ;return cos x
    [(even? n) (trig-sub (trig-exp (cosx (quotient n 2)) 2) (trig-exp (sinx (quotient n 2)) 2))]
    [#t (trig-sub (trig-mul (cosx (quotient n 2)) (cosx (+ (quotient n 2) 1))) (trig-mul (sinx (quotient n 2))(sinx (+ (quotient n 2) 1))))]
    )
)
(define (good-output lst) ;properly prints a list of TrigProds
  (cond
    [(empty? lst) (void)]
    [(empty? (cdr lst)) (printf "~a * sin^~a x * cos^~a x" (tp-coeff (car lst)) (tp-sin-deg (car lst)) (tp-cos-deg (car lst)))]
    [#t (printf "~a * sin^~a x * cos^~a x + " (tp-coeff (car lst)) (tp-sin-deg (car lst)) (tp-cos-deg (car lst)))
        (good-output (cdr lst))])
)

(define (sin-reduce n) (good-output (trie-listify (sinx n))))
(define (cos-reduce n) (good-output (trie-listify (cosx n))))
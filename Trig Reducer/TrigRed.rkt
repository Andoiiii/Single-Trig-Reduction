#lang racket 
;now this will actually do reductions!
(require "TrigProd.rkt")
;list-trieify trie-listify trig-add trig-sub trig-mul trig-exp make-tp tp access

(define (sinx n)
  (cond
    [(< n 0) (tp-- (list (tp 0 0 0)) (sinx (- 0 n)))]
    [(= 0 n) (list (tp 1 0 0))] ;return 1
    [(= 1 n) (list (tp 1 1 0))] ;return sin x
    [(even? n) (tp-* (list (tp 2 0 0)) (tp-* (sinx (quotient n 2)) (cosx (quotient n 2))))]
    [#t (tp-+ (tp-* (sinx (quotient n 2)) (cosx (+ (quotient n 2) 1))) (tp-* (cosx (quotient n 2)) (sinx (+ (quotient n 2) 1))))]
    )
)
(define (cosx n)
  (cond
    [(< n 0) (cosx (- 0 n))]
    [(= 0 n) (list (tp 1 0 0))] ;return 1
    [(= 1 n) (list (tp 1 0 1))] ;return cos x
    [(even? n) (tp-- (tp-exp (cosx (quotient n 2)) 2) (tp-exp (sinx (quotient n 2)) 2))]
    [#t (tp-- (tp-* (cosx (quotient n 2)) (cosx (+ (quotient n 2) 1))) (tp-* (sinx (quotient n 2)) (sinx (+ (quotient n 2) 1))))]
    )
)

(define (sin-reduce n) (tp-print (sinx n)))
(define (cos-reduce n) (tp-print (cosx n)))
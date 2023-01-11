#lang racket
(require "TrigProd.rkt")

(define-struct combinator (n k nCk) #:transparent) ;nCk = this value

(define (Gen start state step)
  (define (cont start state output)
    (append output (Gen start state step)))
  (step start state cont)
)

(define (bump2k comb) ;compute nCk+2
  (define n (combinator-n comb))
  (define k (combinator-k comb))
  (define c (combinator-nCk comb))
  (make-combinator n (+ 2 k) (/ (* c (- n k) (- n k 1)) (+ k 1) (+ k 2)))
  )

(define (make-tp-term s c coeff flop)
  (if flop (tp (- 0 coeff) s c) (tp coeff s c))
)

(define (sinx n)
  (define-struct out (comb flop))
  (if (< n 0) (tp-- (list (tp 0 0 0)) (sinx (- 0 n)))
  (Gen
    (build-list (quotient (+ n 1) 2) (λ(x) (+ 1 (* 2 x))))
    (make-out (combinator n 1 n) #f)
    (λ(in state cont)
      ;(displayln in)
      (if (empty? in) empty
      (if (out-flop state) (cont (cdr in) (make-out (bump2k (out-comb state)) #f) (list (make-tp (- 0 (combinator-nCk (out-comb state))) (car in) (- n (car in)))))
                           (cont (cdr in) (make-out (bump2k (out-comb state)) #t) (list (make-tp (combinator-nCk (out-comb state)) (car in) (- n (car in)))))
      )
)))))
(define (cosx n)
  (define-struct out (comb flop))
  (if (< n 0) (cosx (- 0 n))
  (Gen
    (build-list (quotient (+ 2 n) 2) (λ(x) (* 2 x)))
    (make-out (combinator n 0 1) #f)
    (λ(in state cont)
      ;(displayln in)
      (if (empty? in) empty
      (if (out-flop state) (cont (cdr in) (make-out (bump2k (out-comb state)) #f) (list (make-tp (- 0 (combinator-nCk (out-comb state))) (car in) (- n (car in)))))
                           (cont (cdr in) (make-out (bump2k (out-comb state)) #t) (list (make-tp (combinator-nCk (out-comb state)) (car in) (- n (car in)))))
      )
)))))
(define (sin-reduce n) (tp-print (sinx n)))
(define (cos-reduce n) (tp-print (cosx n)))
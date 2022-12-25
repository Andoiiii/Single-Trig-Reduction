#lang racket 
;now this will actually do reductions!
(require "TrigProd.rkt")

(define (sinx n)
  (cond
    [(< n 0) (tp-- (list (tp 0 0 0)) (sinx (- 0 n)))]
    [#t (sc-memo 'sin n)]
    )
)
(define (cosx n)
  (cond
    [(< n 0) (cosx (- 0 n))]
    [#t (sc-memo 'cos n)]
    )
)
;Deal with negative input at the very very end (start?)
(define (sc-memo type n) ;takes 'sin or 'cos and then an n, and does memoization onto it! 
  ;helpers
  (define-struct idx (sc n))
  (define (idx= a b) (and (equal? (idx-sc a) (idx-sc b)) (= (idx-n a) (idx-n b))))
  (define (mass-complete acc x y) (foldl (λ(a b accu) (complete-list a b accu)) acc x y))

  ;Memoization strategy: Have a function that returns a list that contains the needed item - extract later!
  (define (complete-list type n lst)
    (define val (assoc (make-idx type n) lst idx=))
    (cond
      [val lst] ;its in the list already - just pass it on
      [(= n 1) ;base cases
        (if (eq? 'sin type) (cons (list (make-idx 'sin 1) (list (tp 1 1 0))) lst)
                            (cons (list (make-idx 'cos 1) (list (tp 1 0 1))) lst))]
      [(= n 0)
        (if (eq? 'sin type) (cons (list (make-idx 'sin 0) (list (tp 1 0 0))) lst)
                            (cons (list (make-idx 'cos 0) (list (tp 1 0 0))) lst))]
      ;i dont know how to structure this better, but this just attaches what we wanted onto the list after calling + calculation 
      [(and (eq? 'sin type) (even? n))
        (define filled (mass-complete lst (list 'sin 'cos) (build-list 2 (λ(x) (quotient n 2)))))
        ;(displayln filled)
        (define asked-val (tp-* (list (tp 2 0 0)) (tp-* (cadr (assoc (make-idx 'sin (quotient n 2)) filled idx=)) 
                                                        (cadr (assoc (make-idx 'cos (quotient n 2)) filled idx=)))))
        (cons (list (make-idx type n) asked-val) filled)]
      [(eq? 'sin type)
        (define filled (mass-complete lst (list 'sin 'cos 'sin 'cos) (append (build-list 2 (λ(x) (quotient n 2))) (build-list 2 (λ(x) (+ 1 (quotient n 2)))))))
        ;(displayln filled)
        (define asked-val (tp-+ (tp-* (cadr (assoc (make-idx 'sin (quotient n 2)) filled idx=)) (cadr (assoc (make-idx 'cos (+ 1 (quotient n 2))) filled idx=))) 
                                (tp-* (cadr (assoc (make-idx 'cos (quotient n 2)) filled idx=)) (cadr (assoc (make-idx 'sin (+ 1 (quotient n 2))) filled idx=)))))
        (cons (list (make-idx type n) asked-val) filled)]
      [(and (eq? 'cos type) (even? n))
        (define filled (mass-complete lst (list 'sin 'cos) (build-list 2 (λ(x) (quotient n 2)))))
        ;(displayln filled)
        (define asked-val (tp-- (tp-exp (cadr (assoc (make-idx 'cos (quotient n 2)) filled idx=)) 2) 
                                (tp-exp (cadr (assoc (make-idx 'sin (quotient n 2)) filled idx=)) 2)))
        (cons (list (make-idx type n) asked-val) filled)]
      [(eq? 'cos type)
        (define filled (mass-complete lst (list 'sin 'cos 'sin 'cos) (append (build-list 2 (λ(x) (quotient n 2))) (build-list 2 (λ(x) (+ 1 (quotient n 2)))))))
        ;(displayln filled)
        (define asked-val (tp-- (tp-* (cadr (assoc (make-idx 'cos (quotient n 2)) filled idx=)) (cadr (assoc (make-idx 'cos (+ 1 (quotient n 2))) filled idx=))) 
                                (tp-* (cadr (assoc (make-idx 'sin (quotient n 2)) filled idx=)) (cadr (assoc (make-idx 'sin (+ 1 (quotient n 2))) filled idx=)))))
        (cons (list (make-idx type n) asked-val) filled)]
    ))
  (cadr (assoc (make-idx type n) (complete-list type n empty) idx=))
)

(define (sin-reduce n) (tp-print (sinx n)))
(define (cos-reduce n) (tp-print (cosx n)))
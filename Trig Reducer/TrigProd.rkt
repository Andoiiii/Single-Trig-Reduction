#lang racket
(provide tp-+ tp-- tp-* tp-exp tp-print make-tp tp tp-coeff tp-sin-deg tp-cos-deg)
;Basic addition and multiplication with trig expressions of form x * sinθ^n * cosθ^m

(define-struct tp (coeff sin-deg cos-deg) #:transparent)

(define (tp-< a b) ;less than for 2 trigprods
    (cond
        [(< (tp-sin-deg a) (tp-sin-deg b)) #t]
        [(> (tp-sin-deg a) (tp-sin-deg b)) #f]
        [(< (tp-cos-deg a) (tp-cos-deg b)) #t]
        [#t #f]))
(define (tp-= a b) (and (not (tp-< a b)) (not (tp-< b a))))

(define (tp-de-0 lst) ;remove all terms with coefficent 0
    (cond
        [(empty? lst) empty]
        [(= 0 (tp-coeff (car lst))) (tp-de-0 (cdr lst))]
        [#t (cons (car lst) (tp-de-0 (cdr lst)))]))

(define (add1-tp e lst) ;adds 1 TrigProd into a list of them, maintains total order
    (cond
        [(empty? lst) (cons e empty)]
        [(tp-= e (car lst)) (cons (make-tp (+ (tp-coeff e) (tp-coeff (car lst))) (tp-sin-deg e) (tp-cos-deg e)) (cdr lst))]
        [(tp-< e (car lst)) (cons e lst)]
        [#t (cons (car lst) (add1-tp e (cdr lst)))]
        ))
(define (tp-+ a b) (tp-de-0 (foldl (λ(x acc) (add1-tp x acc)) b a)))

(define (negate-tp a) (map (λ(x) (make-tp (- 0 (tp-coeff x)) (tp-sin-deg x) (tp-cos-deg x))) a))
(define (tp-- a b) (tp-de-0 (tp-+ a (negate-tp b))))

(define (mul-tp e b) (map (λ(x) (make-tp (* (tp-coeff e) (tp-coeff x)) (+ (tp-sin-deg e) (tp-sin-deg x)) (+ (tp-cos-deg e) (tp-cos-deg x)))) b))
(define (tp-* a b) (tp-de-0 (foldl tp-+ empty (foldl (λ(x acc) (cons (mul-tp x b) acc)) empty a))))

(define (tp-exp t1 n)
    (define (recursor t1 n acc)
      (cond
            [(= n 0) acc] ;return ... 1?
            [#t (recursor t1 (- n 1) (tp-* t1 acc))]
      ))
    (tp-de-0 (recursor t1 n (list (tp 1 0 0)))))

(define (pipe val flist) (foldl (λ(x acc) (x acc)) val flist))
(define (print-single-tp a)
    (define (add-plus a) (cond [(< 0 (tp-coeff a)) (printf "+") a][#t a]))
    (define (print-coeff a) (printf "~a" (tp-coeff a)) a)
    (define (add-sine a) (cond [(not (= 0 (tp-sin-deg a))) (printf "*sin") a][#t a]))
    (define (add-sexp a) (cond [(<= (tp-sin-deg a) 1) a][#t (printf "^~a" (tp-sin-deg a)) a]))
    (define (add-x-s a) (cond [(not (= 0 (tp-sin-deg a))) (printf "x") a][#t a]))
    (define (add-x-c a) (cond [(not (= 0 (tp-cos-deg a))) (printf "x") a][#t a]))
    (define (add-cosn a) (cond [(not (= 0 (tp-cos-deg a))) (printf "*cos") a][#t a]))
    (define (add-cexp a) (cond [(<= (tp-cos-deg a) 1) a][#t (printf "^~a" (tp-cos-deg a)) a]))
    (define (closer a) (printf "\n"))
    (pipe a (list add-plus print-coeff add-sine add-sexp add-x-s add-cosn add-cexp add-x-c closer)))
(define (tp-print a) (if (empty? a) (printf "0") (foldl (λ(x acc) (print-single-tp x)) 'rawruwu a)))
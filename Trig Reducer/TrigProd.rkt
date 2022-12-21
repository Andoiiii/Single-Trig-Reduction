#lang racket
(provide list-trieify trie-listify trig-add trig-sub trig-mul trig-exp trie-invert make-tp tp tp-coeff tp-sin-deg tp-cos-deg)
;Basic addition and multiplication with trig expressions of form x * sinθ^n * cosθ^m

(define-struct tp (coeff sin-deg cos-deg) #:transparent)
(define-struct node (sin coeff cos) #:transparent)

(define (trie-insert e t) ;insert a trigprod into the trie
    (trie-prune (cond
        [(empty? t) (trie-insert e (make-node empty 0 empty))]
        [(and (zero? (tp-sin-deg e)) (zero? (tp-cos-deg e))) 
            (make-node (node-sin t) (+ (tp-coeff e) (node-coeff t)) (node-cos t))]
        [(zero? (tp-sin-deg e)) 
            (make-node (node-sin t) (node-coeff t) 
            (trie-insert (make-tp (tp-coeff e) (tp-sin-deg e) (- (tp-cos-deg e) 1)) (node-cos t)))]
        [#t 
            (make-node (trie-insert (make-tp (tp-coeff e) (- (tp-sin-deg e) 1) (tp-cos-deg e)) (node-sin t)) 
            (node-coeff t) (node-cos t))]
        ))
)

(define (trie-listify t) ;takes a trie and flattens it into a list of trigprods
    (define (actual-list t s c acc)
        (cond
            [(empty? t) acc]
            [(not (zero? (node-coeff t))) 
                (actual-list (node-sin t) (+ s 1) c (cons (make-tp (node-coeff t) s c) (actual-list (node-cos t) s (+ c 1) acc)))]
            [#t (actual-list (node-sin t) (+ s 1) c (actual-list (node-cos t) s (+ c 1) acc))]
        ))
    (actual-list t 0 0 empty)
)
(define (list-trieify lst) ;convert a list of trig-prods into a trie
    (foldl trie-insert empty lst))

(define (trie-prune t)
    (if (and (node? t) (zero? (node-coeff t)) (empty? (node-sin t)) (empty? (node-cos t))) empty t))

(define (trie-invert t)
    (cond
        [(empty? t) empty]
        [#t (make-node (trie-invert (node-sin t)) (- 0 (node-coeff t)) (trie-invert (node-cos t)))]))

(define (trie-mul t tprod) ;makes most sense to listify, do the product, then remake the trie...
    (list-trieify (foldl (λ(x acc) 
            (cons (make-tp (* (tp-coeff x) (tp-coeff tprod)) 
                           (+ (tp-sin-deg x) (tp-sin-deg tprod)) 
                           (+ (tp-cos-deg x) (tp-cos-deg tprod))) acc))
            empty (trie-listify t))))
    
(define (trig-add t1 t2) ;add together 2 TRIEs of TrigProds, returns as a Trie
    (foldl (λ(x acc) (trie-insert x acc)) t1 (trie-listify t2)))
(define (trig-sub t1 t2) ;subtract t1 - t2, returning a trie at the end
    (foldl trie-insert t1 (trie-listify (trie-invert t2))))
(define (trig-mul t1 t2) ;takes 2 tries and multiplies them together... this nessecitates foiling =listify
    (foldl trig-add empty (foldl (λ(x acc) (cons (trie-mul t2 x) acc)) empty (trie-listify t1))))
(define (trig-exp t1 n)
    (define (recursor t1 n acc)
      (cond
            [(= n 0) acc] ;return ... 1?
            [#t (recursor t1 (- n 1) (trig-mul t1 acc))]
      ))
    (recursor t1 n (list-trieify (list (tp 1 0 0)))))
#lang class/0
(require 2htdp/image)
(require class/universe)

; A TerTreeOf<Number> is either:
; -- Node
; -- Leaf

; A Node is a (new node% Number Tree Tree Tree)
(define-class node%
  (fields n left-tree mid-tree right-tree)
  
  ; -> Number
  ; RETURNS: the number of numbers in this Node
  (define (size)
    (+ 1 
       (send (send this left-tree) size)
       (send (send this mid-tree) size)
       (send (send this right-tree) size)))
  
  ; -> Number
  ; RETURNS: the sum of all numbers in this Node
  (define (sum)
    (+ (send this n)
       (send (send this left-tree) sum)
       (send (send this mid-tree) sum)
       (send (send this right-tree) sum)))
  
  ; -> Number
  ; RETURNS: the product of all numbers in this Node
  (define (prod)
    (* (send this n)
       (send (send this left-tree) prod)
       (send (send this mid-tree) prod)
       (send (send this right-tree) prod)))
  
  ; Number -> Boolean
  ; RETURNS: true iff this Node contains the given number
  (define (contains? m)
    (or (= (send this n) m)
         (send (send this left-tree) contains? m)
         (send (send this mid-tree) contains? m)
         (send (send this right-tree) contains? m)))
  
  ; (X -> Y) -> Node<Y>
  ; RETURNS: a Node constructed by applying the given function to every number
  ; of thie Node
  (define (map f)
    (new node%
         (f (send this n))
         (send (send this left-tree) map f)
         (send (send this mid-tree) map f)
         (send (send this right-tree) map f)))    
  
  ; -> Number
  ; RETURNS: the largest Number in this Node
  (define (max-num)
    (max
     (send this n)
     (send (send this left-tree) max-num)
     (send (send this mid-tree) max-num)
     (send (send this right-tree) max-num)))
  )


; A Leaf is a (new leaf% Number)
(define-class leaf%
  (fields n)
  
  ; -> Number
  ; RETURNS: the number of numbers in this Leaf
  (define (size)
    1)
  
  ; -> Number
  ; RETURNS: the sum of all numbers in this Leaf
  (define (sum)
    (send this n))
  
  ; -> Number
  ; RETURNS: the product of all numbers in this Leaf
  (define (prod)
    (send this n))
  
  ; Number -> Boolean
  ; RETURNS: true iff this Leaf contains the given number
  (define (contains? m)
    (= (send this n) m))
  
  ; (X -> ?) -> ?
  ; RETURNS: a Leaf constructed by applying the given function to every number
  ; of thie Leaf
  (define (map f)
    (f (send this n)))
  
  ; -> Number
  ; RETURNS: the largest Number in this Leaf
  (define (max-num)
    (send this n))
  )

; tests
(define l1 (new leaf% 1))
(define l2 (new leaf% 2))
(define l3 (new leaf% 3))
(define n1 (new node% 1 l1 l2 l3))

(check-expect (send n1 size) 4)
(check-expect (send n1 sum) 7)
(check-expect (send n1 prod) 6)
(check-expect (send n1 contains? 5) false)
#;
(check-expect (send n1 map (lambda(n) (* 2 n)))
              (new node% 2 
                   (new leaf% 2)
                   (new leaf% 4)
                   (new leaf% 6)))
(check-expect (send n1 max-num) 3)





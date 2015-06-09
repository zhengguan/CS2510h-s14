#lang class/0
(require "extras.rkt")
(require rackunit)
(require 2htdp/image)
(require class/universe)
(provide block%)


; A Block is a (new block% Number Number Number Number Color)
; REPRESENTS: a rectangular block
(define-class block%
  (fields x y width height color)
  
  ; -> Number
  ; RETURNS: the length of this rectangle's diagonal
  (define (diagonal-length)
    (sqrt (+ (sqr (send this width)) (sqr (send this height)))))
  
  ; -> Image
  ; RETURNS: The image representing this rectangle
  (define (draw)
    (rectangle (send this width) (send this height)
               "solid" (send this color)))
  
  ; random-between : Integer Integer -> Integer
  ; Randomly choose a number between a and b (inclusive)
  (define (random-between a b)
    (+ a (random (+ 1 (- b a)))))  
  
  ; step : -> Block
  ; RETURNS: A Block like this one but with its size or location changed
  (define (step)
    (local ((define n (random-between 0 1)))
      (cond
        [(= n 0) (send this resize)]
        [else (send this move)])))
  
  ; resize : -> Block
  ; RETURNS: A Block like this one but with its size changed
  (define (resize)
    (new block% (send this x)
         (send this y)
         (add1 (send this width))
         (add1 (send this height))
         (send this color)))
  
  ; move : -> Block
  ; RETURNS: A Block like this one but with its location changed
  (define (move)
    (new block% 
         (+ (send this x) (random-between -1 1))
         (+ (send this y) (random-between -1 1))
         (send this width)
         (send this height)
         (send this color)))
  
  )

;; EXAMPLES/TESTS:
(define b1 (new block% 20 20 10 10 "red"))
(begin-for-test
  (check-equal? (send b1 diagonal-length) (* 10 (sqrt 2)))
  (check-equal? (send b1 draw) (rectangle 10 10 "solid" "red"))
  (check-equal? (send b1 resize) (new block% 20 20 11 11 "red"))
  #;(check-equal? (send b1 move) (new block% 21 21 10 10 "red")))
                


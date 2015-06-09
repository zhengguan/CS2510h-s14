#lang class/0
(require "extras.rkt")
(require rackunit)
(require 2htdp/image)
(require class/universe)
(provide ball%)



; A Ball is a (new ball% Number Number Number Color)
(define-class ball%
  (fields x y radius color)
  ;(define speed 1)
 
  ; -> Number
  ; The Ball's area
  (define (area)
    (* pi (sqr (send this radius))))
 
  ; Ball -> Boolean
  ; Do the Balls have the same radius?
  (define (same-radius? b)
    (equal? (send this radius) ; (How to access our own field)
            (send b radius)))  ; (How to access someone else's field)
 
  ; Ball -> Boolean
  ; Do the Balls have the same area?
  (define (same-area? b)
    (equal? (send this area)  ; (How to call our own method)
            (send b area)))   ; (How to call someone else's method)
 
  ; -> Image
  ; The image representing the Ball
  (define (draw)
    (circle (send this radius) "solid" (send this color)))
  
  ; -> Number
  ; RETURNS: this ball's circumference
  (define (circumference)
    (* 2 pi (send this radius)))
  
  ; Ball -> Number
  ; RETURNS: the distance between this ball and the given ball
  (define (distance-to that)
    (sqrt (+ (sqr (- (send this x) (send that x)))
             (sqr (- (send this y) (send that y))))))
  
  ; overlap? : Ball -> Boolean
  ; RETURNS: true iff this ball overlap with the given ball
  (define (overlap? that)
    (<= (send this distance-to that) 
        (+ (send this radius)
           (send that radius))))
  
  ; random-between : Integer Integer -> Integer
  ; Randomly choose a number between a and b (inclusive)
  (define (random-between a b)
    (+ a (random (+ 1 (- b a)))))  
  
  ; step : -> Ball
  ; RETURNS: A new ball like this one but with its size or location changed.
  (define (step)
    (local ((define n (random-between 0 1)))
      (cond
        [(= n 0) (send this resize)]
        [else (send this move)])))
  
  ; resize : -> Ball
  ; RETURNS: A new ball like this one but with its size changed
  (define (resize)
    (new ball% (send this x)
         (send this y)
         (add1 (send this radius))
         (send this color)))
  
  ; move : -> Ball
  ; RETURNS: A new ball like this one but with its location changed
  (define (move)
    (new ball%
         (+ (send this x) (random-between -1 1))
         (+ (send this y) (random-between -1 1))
         (send this radius)
         (send this color)))
  )




(define b1 (new ball% 100 100 10 "red"))
(define b2 (new ball% 120 100 10 "yellow"))

; inexact-equal? : Number Number Number -> Boolean
; GIVEN: three number x, y, percent
; WHERE: (and (<= 0 rate) (< rate 1)) is true
; RETURNS: true iff the difference between x and y is less than the 
; given percent
(define (inexact-equal? x y rate)
  (<= (abs (- x y)) (* y rate)))

(begin-for-test
  (check-true (inexact-equal? 
               (send b1 circumference)
               (* 2 3.1414926 10)
               0.01))
  (check-true (send b1 overlap? b2))
  (check-equal? (send b1 resize) (new ball% 100 100 11 "red"))
  #;(check-equal? (send b1 move) (new ball% 101 101 10 "red")))

   

#lang class/0
(require "extras.rkt")
(require rackunit)
(require 2htdp/image)
(require class/universe)
(require "ball.rkt")
(require "block.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DATA DEFINITIONS
; A Creature is one of:
; -- Ball
; -- Block
; Template:
; creature-fn : Creature -> ?
#;
(define (creature-fn c)
  (cond
    [(ball%? c) ...]
    [(block%? c) ...]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CONSTANT DEFINITIONS

(define EMPTY-SCENE (empty-scene 200 400))

; DATA for Ball
(define BALL-COLOR "red")
(define BALL-RADIUS 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; A World is a (new world% LoCreature)
(define-class world%
  (fields creatures)
  
  ; to-draw : -> Image
  ; RETURNS: A image that depicts this world
  (define (to-draw)
    (local
      ((define (to-draw-helper loc)
         (cond
           [(empty? loc) EMPTY-SCENE]
           [else (local
                   ((define c (first loc)))
                   (place-image (send c draw)
                                (send c x)
                                (send c y)
                                (to-draw-helper (rest loc))))])))
      (to-draw-helper (send this creatures))))
  
  ; on-tick : -> World
  ; RETURNS: the state of this World after one tick
  ; STRATEGY: HOFC
  (define (on-tick)
    (new world% 
         (map
          ; Creature -> Creature
          (lambda(c) (send c step))
          (send this creatures))))
  
  (define (tick-rate) 1)
  
  ; on-mouse : Integer Integer MouseEvent -> World
  ; RETURNS: A new world after the mouse event
  (define (on-mouse x y mev)
    (if (mouse=? mev "button-down")
        (new world% (cons (send this new-creature x y)                          
                          (send this creatures)))
        this))
  
  ; new-creature : Integer Integer -> Shape
  ; RETRUNS: A random creature with random size and color
  (define (new-creature x y)
    (local ((define n (random-between 0 1)))
      (cond
        [(= n 0) (new-ball x y)]
        [else (new-block x y)])))
  
  ; new-ball : Inteer Integer -> Ball
  ; RETURNS: A new ball with random size and color
  (define (new-ball x y)
    (new ball% x y (send this random-between 1 20)
         (send this random-color)))
  
  ; new-block : Integer Integer -> Block
  ; RETURNS: A new block with random size and color
  (define (new-block x y)
    (new block% x y 
         (send this random-between 1 20)
         (send this random-between 1 20)
         (send this random-color)))
  
  
  ; random-between : Integer Integer -> Integer
  ; Randomly choose a number between a and b (inclusive)
  (define (random-between a b)
    (+ a (random (+ 1 (- b a)))))
  
  ; choose : [Listof X] -> X
  ; Randomly choose an element from the list
  (define (choose xs)
    (list-ref xs (random (length xs))))
  
  ; random-color : -> Color
  ; Randomly choose a color from a set of common colors
  (define (random-color)
    (choose (list "red" "blue" "green" "yellow" "orange" "purple" "black")))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EXAMPLES/TESTS:

#;(begin-for-test
  (local 
    ((define w (new world% empty)))
    (check-eq? (send (new world% empty) balls) empty)
    (send w on-mouse 100 100 "button-down")))

(big-bang (new world% empty))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
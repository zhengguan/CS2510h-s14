; CS2510h sp14
; Lab 0

#lang class/0
(require 2htdp/image)
(require class/universe)
(require rackunit)
(require "extras.rkt")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; DATA DEFINITIONS

; A Circle is a (make-circ Integer Color Integer Integer)
(define-struct circ (radius color x-coor y-coor))
; Interpretation:
; -- radius
; -- color
; -- x coordinate
; -- y coordinate
; Template:
; circ-fn : Circle -> ?
#;
(define (circ-fn c)
  (... (circ-radius c)
       (circ-color c)
       (circ-x-coor c)
       (circ-y-coor c)))
; Examples:
(define c1 (make-circ 10 "red" 100 100))
(define c2 (make-circ 10 "blue" 100 100))
(define c3 (make-circ 10 "yellow" 100 121))

(define EMPTY-SCENE (empty-scene 200 200))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FUNCTION DEFINITIONS

;; to-image : Circle -> Image
;; RETURNS: An image that depicts that given circle
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (to-image c1) (circle 10 "solid" "red")))
;; STRATEGY: Structural Decomposition on c : Circle
(define (to-image c)
  (circle (circ-radius c)
          "solid"
          (circ-color c)))

;; draw-on : Circle Scene -> Scene
;; RETURNS: An Scene like the given one but with the given Circle drawn on it
;; EXAMPLES/TESTS:
(begin-for-test
 (check-equal?
  (draw-on c1 EMPTY-SCENE)
  (place-image (circle 10 "solid" "red") 100 100 EMPTY-SCENE)))
;; STRATEGY: Structural Decomposition on c : Circle
(define (draw-on c scene)
  (place-image (to-image c)
               (circ-x-coor c)
               (circ-y-coor c)
               scene))

;; area : Circle -> Number
;; RETURNS: The area of the given Circle
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (area c1) (* 100 pi)))
;; STRATEGY: Structural Decomposition on c : Circle
(define (area c)
  (* pi (sqr (circ-radius c))))

;; move-to : Circle Integer Integer -> Circle
;; GIVEN: A Circle and the coordinates of a position
;; RETURNS: A Circle like the given but centered at the given coordinates
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (move-to c1 150 150) (make-circ 10 "red" 150 150)))
;; STRATEGY: Structural Decomposition on c : Circle
(define (move-to c x-coor y-coor)
  (make-circ (circ-radius c)
             (circ-color c)
             x-coor
             y-coor))

;; move-by : Circle Integer Integer -> Circle
;; GIVEN: A Circle and the coordinates of a distance
;; RETURNS: A Circle like the given one but moved by the given distance
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (move-by c1 -30 20) (make-circ 10 "red" 70 120)))
;; STRATEGY: SD on c : Circle
(define (move-by c x-dist y-dist)
  (make-circ (circ-radius c)
             (circ-color c)
             (+ (circ-x-coor c) x-dist)
             (+ (circ-y-coor c) y-dist)))

;; within? : Circle Integer Integer -> Boolean
;; GIVEN: A Circle and the coordinates of a point
;; RETURNS: true iff the given point is located in the circle(or on its edge)
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (within? c1 90 100) true)
  (check-equal? (within? c1 89 100) false))
;; STRATEGY: SD on c : Circle
(define (within? c x-coor y-coor)
  (<= (distance (circ-x-coor c) (circ-y-coor c)
                x-coor y-coor)
      (circ-radius c)))

;; distance : Integer Integer Integer Integer -> Number
;; GIVEN: the coordinates of two points
;; RETURNS: the distance between these two points
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (distance 0 0 3 4) 5))
;; STRATEGY: FC
(define (distance x1 y1 x2 y2)
  (sqrt (+ (sqr (- x1 x2))
           (sqr (- y1 y2)))))

;; =? : Circle Circle -> Boolean
;; RETURNS: true iff the given two Circles' radiuses and center points are equal
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (=? c1 c2) true))
;; STRATEGY: SD on c1 and c2 : Circle
(define (=? c1 c2)
  (and 
     (= (circ-radius c1) (circ-radius c2))
     (= (circ-x-coor c1) (circ-x-coor c2))
     (= (circ-y-coor c1) (circ-y-coor c2))))

;; stretch : Circle PosNum -> Boolean
;; GIVEN: A Circle and a positive number represents factor
;; RETURNS: A Circle like the given one but stretched by the given factor
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal? (stretch c1 3/2) (make-circ 15 "red" 100 100)))
;; STRATEGY: SD on c : Circle
(define (stretch c n)
  (make-circ (* (circ-radius c) n)
             (circ-color c)
             (circ-x-coor c)
             (circ-y-coor c)))

;; overlap? : Circle Circle -> Boolean
;; RETURNS: true iff the two given Circles overlap
;; EXAMPLES/TESTS:
(begin-for-test
  (check-equal?
   (overlap? c1 c2)
   true)
  (check-equal?
   (overlap? c1 c3)
   false))
;; STRATEGY: SD on c1 and c2 : Circle
(define (overlap? c1 c2)
  (< (distance (circ-x-coor c1) (circ-y-coor c1) 
               (circ-x-coor c2) (circ-y-coor c2))
     (+ (circ-radius c1) (circ-radius c2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A Circle is a (new circ% Integer Color Integer Integer)
;; REPRESENTS: A circle
(define-class circ%
  (fields radius color x-coor y-coor)
  
  ;; to-image :  -> Image
  ;; RETURNS: An image that depicts that this Circle
  (define (to-image)
    (circle (send this radius)
            "solid"
            (send this color)))
  
  ;; draw-on : Scene -> Scene
  ;; RETURNS: An Scene like the given one but with the this Circle drawn on it
  (define (draw-on scene)
    (place-image (send this to-image)
                 (send this x-coor)
                 (send this y-coor)
                 scene))
  
  ;; area : -> Number
  ;; RETURNS: The area of the this Circle
  (define (area)
    (* pi (sqr (send this radius))))
  
  ;; move-to : Integer Integer -> Circle
  ;; GIVEN: The coordinates of a position
  ;; RETURNS: A Circle like the this but centered at the given coordinates
  (define (move-to x-coor y-coor)
    (new circ% (send this radius)
         (send this color)
         x-coor
         y-coor))
  
  ;; move-by : Integer Integer -> Circle
  ;; GIVEN: The coordinates of a distance
  ;; RETURNS: A Circle like the this one but moved by the given distance
  (define (move-by x-dist y-dist)
    (new circ% (send this radius)
         (send this color)
         (+ (send this x-coor) x-dist)
         (+ (send this y-coor) y-dist)))
  
  ;; within? : Integer Integer -> Boolean
  ;; GIVEN: The coordinates of a point
  ;; RETURNS: true iff the given point is located in this circle(or on its edge)
  (define (within? x-coor y-coor)
    (<= (distance (send this x-coor) (send this y-coor)
                  x-coor y-coor)
        (send this radius)))
  
  ;; distance : Integer Integer Integer Integer -> Number
  ;; GIVEN: the coordinates of two points
  ;; RETURNS: the distance between these two points
  ;; STRATEGY: FC
  (define (distance x1 y1 x2 y2)
    (sqrt (+ (sqr (- x1 x2))
             (sqr (- y1 y2)))))
  
  ;; =? : Circle -> Boolean
  ;; RETURNS: true iff the given Circle and this Circle's radiuses and center
  ;; points are equal
  ;; STRATEGY: SD on c1 and c2 : Circle
  (define (=? that)
    (and 
     (= (send this radius) (send that radius))
     (= (send this x-coor) (send that x-coor))
     (= (send this y-coor) (send that y-coor))))
  
  ;; stretch : PosNum -> Boolean
  ;; GIVEN: A positive number represents factor
  ;; RETURNS: A Circle like this one but stretched by the given factor
  (define (stretch n)
    (new circ% (* (send this radius) n)
         (send this color)
         (send this x-coor)
         (send this y-coor)))
  
  ;; overlap? : Circle -> Boolean
  ;; RETURNS: true iff this Circle and the given Circle overlaps  
  (define (overlap? that)
    (<= (distance (send this x-coor) (send this y-coor) 
                 (send that x-coor) (send that y-coor))
       (+ (send this radius) (send that radius))))
  )


;; EXAMPLES/TESTS:
(define c%1 (new circ% 10 "red" 100 100))
(define c%2 (new circ% 10 "blue" 100 100))
(define c%3 (new circ% 10 "yellow" 100 121))

(begin-for-test
  (check-equal? (send c%1 to-image) (circle 10 "solid" "red")))

(begin-for-test
  (check-equal?
   (send c%1 draw-on EMPTY-SCENE)
   (place-image (circle 10 "solid" "red") 100 100 EMPTY-SCENE)))

(begin-for-test
  (check-equal? (send c%1 area) (* 100 pi)))

(begin-for-test
  (check-equal? (send c%1 move-to 150 150) (new circ% 10 "red" 150 150)))

(begin-for-test
  (check-equal? (send c%1 move-by -30 20) (new circ% 10 "red" 70 120)))

(begin-for-test
  (check-equal? (send c%1 within? 90 100) true)
  (check-equal? (send c%1 within? 89 100) false))

(begin-for-test
  (check-equal? (send c%1 distance 0 0 3 4) 5))

(begin-for-test
  (check-equal? (send c%1 =? c%2) true))

(begin-for-test
  (check-equal? (send c%1 stretch 3/2) (new circ% 15 "red" 100 100)))

(begin-for-test
  (check-equal?
   (send c%1 overlap? c%2)
   true)
  (check-equal?
   (send c%1 overlap? c%3)
   false))

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
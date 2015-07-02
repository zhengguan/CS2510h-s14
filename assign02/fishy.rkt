#lang class/0
(require 2htdp/image)
(require class/universe)

(define WIDTH 500)
(define HEIGHT 500)
(define EMPTY-SCENE (empty-scene WIDTH HEIGHT))
; A World is a (new world% Player ListOf<Fish>)
(define-class world%
  (fields player fishes)
  
  ; -> World
  ; RETURNS: the World of next tick
  (define (on-tick)
    (local
      ((define the-player (send this player))
       (define the-fishes (send this fishes))
       (define fishes-can-be-eaten
         (filter
          (lambda(f) (send the-player can-eat? f))
          the-fishes))
       (define fishes-cannot-be-eaten
         (filter
          (lambda(f) (not(send the-player can-eat? f)))
          the-fishes))
       (define new-player
         (send the-player eat-fishes fishes-can-be-eaten)))
      (new world% 
           (send new-player on-tick)
           (map
            ; Fish -> Fish
            (lambda(f) (send f on-tick))
            fishes-cannot-be-eaten))))
  
  ; -> Image
  ; RETURNS: an Image that depicts this World  
  (define (to-draw)
    (local 
      ((define this-player (send this player))
       (define this-fishes (send this fishes))
       (define scene-with-player
         (send this-player to-draw EMPTY-SCENE)))
      (foldr
       ; Fish Image -> Image
       ; RETURNS: an Image like the given one but with the given Fish drawn on it
       (lambda(f rest-scene) 
         (send f to-draw rest-scene))
       scene-with-player
       this-fishes)))
  
  ; KeyEvent -> World
  ; GIVEN: the coordinates of a location and a key event
  ; RETURNS: the World after the given key event of the given location
  (define (on-key kev)
    (new world%
         (send (send this player) on-key kev)
         (send this fishes)))
  
  ; -> Boolean
  ; RETURNS: true iff the player has been eaten by a fish or the player is
  ; the largest one on the screen
  (define (stop-when)
    (local 
      ((define the-player (send this player))
       (define all-fishes (send this fishes)))
      (or
       (andmap 
        ; Fish -> Boolean
        ; RETURNS: true iff the player is larger than the given fish
        (lambda(f) (send the-player larger-than? f))
        all-fishes)
       (ormap
        ; Fish -> Boolean
        ; RETURNS: true iff the player has been eaten by the given fish
        (lambda(f) (send the-player eaten-by? f))
        all-fishes))))
  )

(define PLAYER-COLOR "gold")
(define PLAYER-SPEED 5)
; A Player is a (new player% Location Size)
; REPRESENTS: a fish that is controled by the player
(define-class player%
  (fields location size)
  
  ; -> World
  ; RETURNS: the World of next tick
  (define (on-tick)
    this)
  
  ; -> Number
  ; RETURNS: the x coordinate of this player
  (define (x)
    (send (send this location) x))
  
  ; -> Number
  ; RETURNS: the y coordinates of this player
  (define (y)
    (send (send this location) y))  
  
  ; -> Number
  ; RETURNS: the width of this player
  (define (width)
    (send (send this size) width))
  
  ; -> Number 
  ; RETURNS: the height of this player
  (define (height)
    (send (send this size) height))  
  
  ; Fish -> Boolean
  ; RETURNS: true iff this player is larger than the given fish
  (define (larger-than? f)
    (send (send f size) smaller-than? 
          (send this size)))
  
  ; Fish -> Boolean
  ; RETURNS: true iff this player can eat the given fish
  (define (can-eat? f)
    (and (send this larger-than? f)
         (send this touch-with? f)))
  
  ; Fish -> Boolean
  ; RETURNS: true iff this player got touched with the given fish
  (define (touch-with? f)
    (and
     (<= (abs (- (send this x) (send f x)))
         (/ (+ (send this width) (send f width)) 2))
     (<= (abs (- (send this y) (send f y)))
         (/ (+ (send this height) (send f height)) 2))))
  
  ; Fish -> Boolean
  ; RETURNS: true iff this player has been eaten by the given fish
  (define (eaten-by? f)
    (and (send this smaller-than? f)
         (touch-with? f)))
  
  ; Fish -> Boolean
  ; RETURNS: true iff this player is smaller than the given fish  
  (define (smaller-than? f)
    (send (send this size) smaller-than?
          (send f size)))
  
  
  ; Image -> Image
  ; RETURNS: an Image like the given one but with this player drawn on it
  (define (to-draw scene)
    (local ((define fish-image    
              (ellipse (send this width)
                       (send this height)
                       "solid"
                       PLAYER-COLOR))
            (define x-pos (send this x))
            (define y-pos (send this y)))
      (place-image fish-image (+ x-pos WIDTH) y-pos
                   (place-image fish-image (- x-pos WIDTH) y-pos
                                (place-image fish-image x-pos y-pos
                                             scene)))))
    
  
  ; KeyEvent -> Player
  ; GIVEN: the coordinates of a location and a key event
  ; RETURNS: the Player after the given key event of the given location
  (define (on-key kev)
    (local 
      ((define this-loc (send this location))
       (define this-size (send this size)))
      (new player%
           (cond
             [(key=? kev "up") 
              (send this-loc move-on-y (- PLAYER-SPEED))]
             [(key=? kev "down") 
              (send this-loc move-on-y PLAYER-SPEED)]
             [(key=? kev "left") 
              (send this-loc move-on-x-within-range (- PLAYER-SPEED) 0 WIDTH)]
             [(key=? kev "right") 
              (send this-loc move-on-x-within-range PLAYER-SPEED 0 WIDTH)]
             [else this])
           this-size)))
  
  ; LoFish -> Player
  ; RETURNS: the state of this Player after eaten the given fishes
  (define (eat-fishes lof)
    (foldr
     ; Fish Player -> Player
     ; RETURNS: the Player after eaten the given fish
     (lambda(f p) (send p eat-fish f))
     this
     lof))
  
  ; Fish -> Player
  ; RETURNS: the state of this Player after eaten the given fish
  (define (eat-fish f)
    (new player%
         (send this location)
         (send (send this size) increase-by-size
               (send f size))))
  
  )

(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) x)
 250)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) y)
 100)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) width)
 60)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) height)
 30)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) to-draw EMPTY-SCENE)
 (local ((define fish-image (ellipse 60 30 "solid" PLAYER-COLOR)))
   (place-image fish-image (- 250 WIDTH) 100
                (place-image fish-image (+ 250 WIDTH) 100
                             (place-image fish-image 250 100 EMPTY-SCENE)))))
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) on-key "up")
 (new player% (new location% (make-rectangular 250 (- 100 PLAYER-SPEED)))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) on-key "down")
 (new player% (new location% (make-rectangular 250 (+ 100 PLAYER-SPEED)))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) on-key "left")
 (new player% (new location% (make-rectangular (- 250 PLAYER-SPEED) 100))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) on-key "right")
 (new player% (new location% (make-rectangular (+ 250 PLAYER-SPEED) 100))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% 0+100i) (new size% 60+30i)) on-key "left")
 (new player% (new location% (make-rectangular (modulo (- PLAYER-SPEED) WIDTH) 100))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% (+ WIDTH +100i)) (new size% 60+30i)) on-key "right")
 (new player% (new location% (make-rectangular (modulo (+ WIDTH PLAYER-SPEED) WIDTH) 100))
      (new size% 60+30i)))
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) larger-than?
       (new fish% (new location% 250+100i) (new size% 60+29i) 3 "green"))
 true)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) larger-than?
       (new fish% (new location% 250+100i) (new size% 60+30i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) can-eat?
       (new fish% (new location% 310+125i) (new size% 60+20i) 3 "green"))
 true)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) can-eat?
       (new fish% (new location% 310+126i) (new size% 60+20i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) can-eat?
       (new fish% (new location% 310+125i) (new size% 60+30i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) can-eat?
       (new fish% (new location% 310+126i) (new size% 60+30i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) eaten-by?
       (new fish% (new location% 310+126i) (new size% 60+20i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) eaten-by?
       (new fish% (new location% 310+125i) (new size% 60+20i) 3 "green"))
 false)
(check-expect
 (send (new player% (new location% 250+100i) (new size% 60+30i)) eaten-by?
       (new fish% (new location% 310+125i) (new size% 60+30i) 3 "green"))
 false)



; A Fish is a (new fish% Location Size Number Color)
; REPRESENTS: a usual fish
(define-class fish%
  (fields location size speed color)
  
  ; -> Number
  ; RETURNS: the x coordinate of this player
  (define (x)
    (send (send this location) x))
  
  ; -> Number
  ; RETURNS: the y coordinates of this player
  (define (y)
    (send (send this location) y))  
  
  ; -> Number
  ; RETURNS: the width of this player
  (define (width)
    (send (send this size) width))
  
  ; -> Number 
  ; RETURNS: the height of this player
  (define (height)
    (send (send this size) height))
  
  
  ; -> World
  ; RETURNS: the World of next tick
  (define (on-tick)
    (new fish%
         (send (send this location) move-on-x-within-range
               (send this speed) (- (/ WIDTH 2)) (* WIDTH 3/2))
         (send this size)
         (send this speed)
         (send this color)))
  
    
  ; Image -> Image
  ; RETURNS: an Image like the given one but with this fish drawn on it  
  (define (to-draw scene)
    (place-image
     (ellipse (send this width)
              (send this height)
              "solid"
              (send this color))
     (send this x)
     (send this y)
     scene))
  
  ; KeyEvent -> Fish
  ; GIVEN:  a key event
  ; RETURNS: this Fish after the given key event
  ; STRATEGY: Cases on kev : KeyEvent
  (define (on-key kev)
    this)
  )


(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       x)
 250)
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       y)
 300)
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       to-draw EMPTY-SCENE)
 (place-image (ellipse 60 30 "solid" "black") 250 300 EMPTY-SCENE))
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       on-tick)
 (new fish% (new location% 253+300i) (new size% 60+30i) 3 "black"))
#;
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       on-key "right")
 (new fish% (new location% 253+300i) (new size% 60+30i) 3 "black"))
#;
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       on-key "left")
 (new fish% (new location% 247+300i) (new size% 60+30i) 3 "black"))



; A Location is a (new location% ComplexNum)
; REPRESENTS: a location (x, y) is represented by (new location% x+yi)
(define-class location%
  (fields location)
  
  ; -> Number
  ; RETURNS: the x coordinate of this player
  (define (x)
    (real-part (send this location)))
  
  ; -> Number
  ; RETURNS: the y coordinates of this player
  (define (y)
    (imag-part (send this location)))
  
  ; Velocity -> Location
  ; RETURNS: the Location after moving at the given Velocity
  (define (move v)
    (new location% (+ (send this location) v)))
  
  ; Number -> Location
  ; RETURNS: the Location after moving on y axis at the given distance
  (define (move-on-y dist)
    (send this move (make-rectangular 0 dist)))
  
  ; Number Number Number -> Location 
  ; GIVEN: a Number represents the moving distance, two number end represents
  ; the end of a range [start, end]
  ; RETURNS: the Location after moving on the x-axis at the given distance while
  ; loops around the range
  #;
  (define (move-on-x-within-range dist end)
    (local ((define x-pos (send this x))
            (define y-pos (send this y)))
      (new location%
           (make-rectangular (modulo (+ x-pos dist) end)
                             y-pos))))
  (define (move-on-x-within-range dist start end)
    (local ((define x-pos (send this x))
            (define y-pos (send this y))
            (define range-width (- end start)))
      (new location%
           (make-rectangular
            (+ (modulo (- (+ x-pos dist) start) range-width) start)
            y-pos))))
  )

(check-expect (send (new location% 250+300i) x) 250)
(check-expect (send (new location% 250+300i) y) 300)
(check-expect (send (new location% 250+300i) move -3)
              (new location% 247+300i))
(check-expect (send (new location% 250+300i) move-on-y -3)
              (new location% 250+297i))
(check-expect (send (new location% 250+300i) move-on-x-within-range 3 0 500)
              (new location% 253+300i))
(check-expect (send (new location% 500+300i) move-on-x-within-range 3 0 500)
              (new location% 3+300i))
(check-expect (send (new location% +300i) move-on-x-within-range -3 0 500)
              (new location% 497+300i))
(check-expect (send (new location% -250+300i) move-on-x-within-range -4 -250 750)
              (new location% 746+300i))
(check-expect (send (new location% 750+300i) move-on-x-within-range 4 -250 750)
              (new location% -246+300i))



; A Size is a (new size% ComplexNum)
; REPRESENTS: a size of width*height is represented by (new size% width+height*i)
(define-class size%
  (fields size)
  
  ; -> Number
  ; RETURNS: the width of this size
  (define (width)
    (real-part (send this size)))
  
  ; -> Number
  ; RETURSN: the height of this size
  (define (height)
    (imag-part (send this size)))
  
  ; Size -> Boolean
  ; RETURNS: true iff this Size is small than the given one
  (define (smaller-than? s)
    (< (send this area)
       (send s area)))
  
  ; -> Number
  ; RETURNS: the area of this size
  (define (area)
    (* (send this width)
       (send this height)))
  
  ; Size -> Size
  ; RETURNS: a Size after increasing this Size one the given Size
  (define (increase-by-size s)
    (send this increase-by-value
          (send s area)))
  
  ; Number -> Size
  ; RETURNS: a Size after increasing this Size the given value
  (define (increase-by-value v)
    (send this increase-by-ratio (sqrt (/ v (send this area)))))
  
  ; Number -> Size
  ; RETURNS: the Size after this one increased by the given ration
  (define (increase-by-ratio r)
    (new size%
         (make-rectangular (floor (* (+ r 1) (send this width)))
                           (floor (* (+ r 1) (send this height))))))
    
  )

(check-expect (send (new size% 60+20i) width) 60)
(check-expect (send (new size% 60+20i) height) 20)
(check-expect (send (new size% 60+20i) smaller-than? (new size% 60+20i))
              false)
(check-expect (send (new size% 60+19i) smaller-than? (new size% 60+20i))
              true)
#;
(check-expect 
 (send (new fish% (new location% 250+300i) (new size% 60+30i) 3 "black")
       on-tick)
 (new fish% (new location% 250+300i) (new size% 63+30i) 3 "black"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TEST OF WORLD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; random-initial-world : -> World%
;; RETURNS: A world produced randomly
(define (random-initial-world)
  (new world%
       (random-player)
       (random-fishes (random-between 1 10))))

;; random-player : -> Player
;; RETURNS: a Player produced randomly
(define (random-player)
  (new player%
       (random-location)
       (new size% 20+10i)))

;; random-fishes : Integer -> LoFish
;; RETURNS: a list that contains the given number of random produced 
;; fishes
(define (random-fishes n)
  (cond
    [(zero? n) empty]
    [else (cons (random-fish)
                (random-fishes (- n 1)))]))


;; random-fish : -> Fish
;; RETURNS: a random produced fish
(define (random-fish)
  (new fish%
       (random-location)
       (random-size)
       (random-speed)
       (random-color)))

;; random-location : -> Location
;; RETURNS: a random produced location
(define (random-location)
  (new location% 
       (random-complex 0 WIDTH 0 HEIGHT)))

;; random-size : -> Size
;; RETURNS: a random produced fish size (equal? (/ width height) 2)
(define (random-size)
  (new size%
       (local 
         ((define random-height (random-between 1 50)))
         (make-rectangular (* 2 random-height)
                           random-height))))

;; random-speed : -> Integer
;; RETURNS: a random speed of the fish
(define (random-speed)
  (random-between -5 5))


;; random-complex : Int Int Int Int -> Complex
;; GIVEN: four Ints low-real and high-real, low-imag, high-imag
;; WHERE: high-real >= low-real, high-imag >= low-imag
;; RETURNS: a complex number with real part between [low-real,high-real]
;; and imag part between [low-imag, high-imag]
;; STRATEGY: FC
(define (random-complex low-real high-real low-imag high-imag)
  (make-rectangular (random-between  low-real high-real)
                    (random-between low-imag high-imag)))

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


#;
(big-bang (new world% 
               (new player% (new location% 250+250i) (new size% 30+10i))
               (list 
                (new fish% (new location% 300+300i) (new size% 20+10i) -2 "purple")
                (new fish% (new location% 100+300i) (new size% 40+20i) 2 "purple"))))

(big-bang (random-initial-world))
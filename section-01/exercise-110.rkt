;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise-110) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/part_one.html#%28part._sec~3ainput-errors%29


;; Number -> Number
;; computes the area of a disk with radius r
(define (area-of-disk r)
  (* 3.14 (* r r)))


;; Any -> Number
;; computes the area of a disk with radius v, if v is a number
(define (checked-area-of-disk v)
  (cond
    [(and (number? v) (positive? v)) (area-of-disk v)]
    [else (error "area-of-disk: positive number expected")]))


(checked-area-of-disk 10)


(checked-area-of-disk -10)

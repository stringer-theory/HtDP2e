;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise-124) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/part_one.html#%28part._sec~3asynsem~3avar-defns~7d._%29

;; 1.
(define PRICE 5)
#; (define SALES-TAX (* 0.08 PRICE))
#; (define SALES-TAX (* 0.08 5))
(define SALES-TAX 0.40)
#; (define TOTAL (+ PRICE SALES-TAX))
#; (define TOTAL (+ 5 0.40))
(define TOTAL 5.40)

;; 2. Yes because function fahrenheit->celsius is used before it is defined.

;; 3. No because function f is defined before it is used.

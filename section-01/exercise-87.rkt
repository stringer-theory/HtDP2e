;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise-87) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)


;; http://www.ccs.neu.edu/home/matthias/HtDP2e/part_one.html#%28part._sec~3aedit1%29


;; 1a. DATA DEFINITIONS
(define-struct editor [text index])
;; An Editor is a structure:
;;   (make-editor String Number)
;; interpretation (make-editor s i) describes an editor whose visible text is
;; s with the cursor displayed after position i and before position i+1 in s
;; where 0 indicates the cursor is before the first character in s


;; 1b. CONSTANT DEFINITIONS
(define SCENE_WIDTH 200)
(define SCENE_HEIGHT 20)
(define EMPTY_SCENE (empty-scene SCENE_WIDTH SCENE_HEIGHT))
(define TEXT_SIZE 16)
(define TEXT_COLOR "black")
(define CURSOR (rectangle 1 20 "solid" "red"))
(define MAX_EDITOR_TEXT_IMAGE_LENGTH SCENE_WIDTH)


;; 1c. FUNCTION WISH LIST
;; NAME: before-string
;; SIGNATURE: Editor -> String
;; PURPOSE STATEMENT: Consumes an editor and returns the portion of the string
;; before the cursor.
;; NAME: after-string
;; SIGNATURE: Editor -> String
;; PURPOSE STATEMENT: Consumes an editor and returns the portion of the string
;; after the cursor.
;; NAME: move-cursor-left
;; SIGNATURE: Editor -> Editor
;; PURPOSE STATEMENT: Consumes an editor and updates the cursor position to be
;; one less than the current cursor position.  If the current position is greater
;; that the length of the editor's text, then the cursor position is set to one
;; less than the length of text.
;; NAME: move-cursor-right
;; SIGNATURE: Editor -> Editor
;; PURPOSE STATEMENT: Consumes an editor and updates the cursor position to be
;; one more than the current cursor position or the length of text, which ever is
;; less.
;; NAME: backspace
;; SIGNATURE: Editor -> Editor
;; PURPOSE STATEMENT: Consumes an editor and removes the character at the cursor
;; position and decrements index.
;; NAME: insert
;; SIGNATURE: Editor 1String -> Editor
;; PURPOSE STATEMENT: Consumes an editor and a 1String and returns and editor
;; with the 1String inserted at the index and the index incremented.
;; NAME: compute-new-editor-image-length
;; SIGNATURE: Editor 1String -> Number 
;; PURPOSE STATEMENT: Consumes an editor and a string of length one and returns
;; the length of the editor after the string is inserted in the editor.


;; 2a. FUNCTION SIGNATURE: Editor 1String -> Number 
;; 2b. PURPOSE STATEMENT: Consumes an editor and a string of length one and
;; returns the length of the editor after the string is inserted in the editor.
;; 2c. HEADER
;; (define (compute-new-editor-image-length e 1s) 0)
;; 3a. FUNCTIONAL EXAMPLES
;; Given: {"" ""} "a", Expect: (image-width (text "a" TEXT_SIZE TEXT_COLOR))
;; 3b. TESTS
(check-expect
 (compute-new-editor-image-length (make-editor "" 0) "a")
 (image-width (text "a" TEXT_SIZE TEXT_COLOR)))
(check-expect
 (compute-new-editor-image-length (make-editor "aa" 2) "a")
 (* 3 (image-width (text "a" TEXT_SIZE TEXT_COLOR))))
;; 4. TEMPLATE
;; (define (compute-new-editor-image-length e 1s)
;;   (... (editor-pre e) ... (editor-post e) ... 1s ...))
;; 5. CODE
(define (compute-new-editor-image-length e 1s)
  (+
   (image-width (text (before-string e) TEXT_SIZE TEXT_COLOR))
   (image-width (text (after-string e) TEXT_SIZE TEXT_COLOR))
   (image-width (text 1s TEXT_SIZE TEXT_COLOR))))


;; 2a. FUNCTION SIGNATURE: Editor 1String -> Editor
;; 2b. PURPOSE STATEMENT: Consumes an editor and removes the character at the
;; cursor with the 1String inserted at the index and the index incremented.
;; 2c. HEADER
;; (define (insert e ke) e)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5} " ", Expect: {"hello world" 6}
;; #2: Given: {"helloworld" 10} " ", Expect: {"helloworld " 11}
;; #3: Given: {"helloworld" 100} " ", Expect: {"helloworld " 11}
;; #4: Given: {"helloworld" 0} " ", Expect: {" helloworld" 1}
;; #5: Given: {"helloworld" -1} " ", Expect: {" helloworld" 1}
;; 3b. TESTS
;; Cursor is greater than 0 and less than the text's length.
#;1 (check-expect (insert (make-editor "helloworld" 5) " ")
                  (make-editor "hello world" 6))
;; Cursor is equal to or greater than the text's length.
#;2 (check-expect (insert (make-editor "helloworld" 10) " ")
                  (make-editor "helloworld " 11))
#;3 (check-expect (insert (make-editor "helloworld" 100) " ")
                  (make-editor "helloworld " 11))
;; Cursor is equal to or less than zero.
#;4 (check-expect (insert (make-editor "helloworld" 0) " ")
                  (make-editor " helloworld" 1))
#;5 (check-expect (insert (make-editor "helloworld" -1) " ")
                  (make-editor " helloworld" 1))
;; 4. TEMPLATES
;; (define (insert e ke)
;;   (... (editor-text e) ... (editor-index e) ... ke))
;; 5. CODE
(define (insert e ke)
  (cond
    [(<= (editor-index e) 0) (make-editor (string-append ke (editor-text e)) 1)]
    [(>= (editor-index e) (string-length (editor-text e)))
     (make-editor (string-append (editor-text e) ke)
                  (+ (string-length (editor-text e)) 1))]
    [else (make-editor (string-append (before-string e) ke (after-string e))
                       (+ (editor-index e) 1))]
    )  
  )


;; 2a. FUNCTION SIGNATURE: Editor -> Editor
;; 2b. PURPOSE STATEMENT: Consumes an editor and removes the character at the
;; cursor position and decrements index.
;; 2c. HEADER
;; (define (backspace e) e)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5}, Expect: {"hellworld" 4}
;; #2: Given: {"helloworld" 10}, Expect: {"helloworl" 9}
;; #3: Given: {"helloworld" 100}, Expect: {"helloworl" 9}
;; #4: Given: {"helloworld" 0}, Expect: {"helloworld" 0}
;; #5: Given: {"helloworld" -1}, Expect: {"helloworld" 0}
;; 3b. TESTS
;; Cursor is greater than 0 and less than the text's length.
#;1 (check-expect (backspace (make-editor "helloworld" 5))
                  (make-editor "hellworld" 4))
;; Cursor is equal to or greater than the text's length.
#;2 (check-expect (backspace (make-editor "helloworld" 10))
                  (make-editor "helloworl" 9))
#;3 (check-expect (backspace (make-editor "helloworld" 100))
                  (make-editor "helloworl" 9))
;; Cursor is equal to or less than zero.
#;4 (check-expect (backspace (make-editor "helloworld" 0))
                  (make-editor "helloworld" 0))
#;5 (check-expect (backspace (make-editor "helloworld" -1))
                  (make-editor "helloworld" 0))
;; 4. TEMPLATES
;; (define (backspace e)
;;   (... (editor-text e) ... (editor-index e) ...))
;; 5. CODE
(define (backspace e)
  (cond
    [(<= (editor-index e) 0) (make-editor (editor-text e) 0)]
    [(>= (editor-index e) (string-length (editor-text e)))
     (make-editor (substring
                   (editor-text e) 0 (- (string-length (editor-text e)) 1))
                  (- (string-length (editor-text e)) 1))]
    [else (make-editor (string-append
                        (substring (before-string e) 0 (- (editor-index e) 1))
                        (after-string e))
                       (- (editor-index e) 1))]
    )
  )

;; 2a. FUNCTION SIGNATURE: Editor -> Editor
;; 2b. PURPOSE STATEMENT: Consumes an editor and updates the cursor position to
;; be one more than the current cursor position or the length of text, which ever
;; is less.
;; 2c. HEADER
;; (define (move-cursor-right e) e)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5}, Expect: {"helloworld" 6}
;; #2: Given: {"helloworld" 10}, Expect: {"helloworld" 10}
;; #3: Given: {"helloworld" 100}, Expect: {"helloworld" 10}
;; #4: Given: {"helloworld" 0}, Expect: {"helloworld" 1}
;; #5: Given: {"helloworld" -1}, Expect: {"helloworld" 1}
;; 3b. TESTS
;; Cursor is greater than 0 and less than the text's length.
#;1 (check-expect (move-cursor-right (make-editor "helloworld" 5))
                  (make-editor "helloworld" 6))
;; Cursor is equal to or greater than the text's length.
#;2 (check-expect (move-cursor-right (make-editor "helloworld" 10))
                  (make-editor "helloworld" 10))
#;3 (check-expect (move-cursor-right (make-editor "helloworld" 100))
                  (make-editor "helloworld" 10))
;; Cursor is equal to or less than zero.
#;4 (check-expect (move-cursor-right (make-editor "helloworld" 0))
                  (make-editor "helloworld" 1))
#;5 (check-expect (move-cursor-right (make-editor "helloworld" -1))
                  (make-editor "helloworld" 1))
;; 4. TEMPLATES
;; (define (move-cursor-right e)
;;   (... (editor-text e) ... (editor-index e) ...))
;; 5. CODE
(define (move-cursor-right e)
  (cond
    [(<= (editor-index e) 0) (make-editor (editor-text e) 1)]
    [(>= (editor-index e) (string-length (editor-text e)))
     (make-editor (editor-text e) (string-length (editor-text e)))]
    [else (make-editor (editor-text e) (+ (editor-index e) 1))]
    )
  )


;; 2a. FUNCTION SIGNATURE: Editor -> Editor
;; 2b. PURPOSE STATEMENT: Consumes an editor and updates the cursor position to
;; be one less than the current cursor position.  If the current position is
;; greater that the length of the editor's text, then the cursor position is set to
;; one less than the length of text.
;; 2c. HEADER
;; (define (move-cursor-left e) e)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5}, Expect: {"helloworld" 4}
;; #2: Given: {"helloworld" 10}, Expect: {"helloworld" 9}
;; #3: Given: {"helloworld" 100}, Expect: {"helloworld" 9}
;; #4: Given: {"helloworld" 0}, Expect: {"helloworld" 0}
;; #5: Given: {"helloworld" -1}, Expect: {"helloworld" 0}
;; 3b. TESTS
;; Cursor is greater than 0 and less than the text's length.
#;1 (check-expect (move-cursor-left (make-editor "helloworld" 5))
                  (make-editor "helloworld" 4))
;; Cursor is equal to or greater than the text's length.
#;2 (check-expect (move-cursor-left (make-editor "helloworld" 10))
                  (make-editor "helloworld" 9))
#;3 (check-expect (move-cursor-left (make-editor "helloworld" 100))
                  (make-editor "helloworld" 9))
;; Cursor is equal to or less than zero.
#;4 (check-expect (move-cursor-left (make-editor "helloworld" 0))
                  (make-editor "helloworld" 0))
#;5 (check-expect (move-cursor-left (make-editor "helloworld" -1))
                  (make-editor "helloworld" 0))
;; 4. TEMPLATE
;; (define (move-cursor-left e)
;;   (... (editor-text e) ... (editor-index e) ...))
;; 5. CODE
(define (move-cursor-left e)
  (cond
    [(<= (editor-index e) 0) (make-editor (editor-text e) 0)]
    [(>= (editor-index e) (string-length (editor-text e)))
     (make-editor (editor-text e) (- (string-length (editor-text e)) 1))]
    [else (make-editor (editor-text e) (- (editor-index e) 1))]
    )
  )


;; 2a. FUNCTION SIGNATURE: Editor -> String
;; 2b. PURPOSE STATEMENT: Consumes an editor and returns the portion of the
;; string before the cursor.
;; 2c. HEADER
;; (define (before-string e) "")
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5}, Expect: "hello"
;; #2: Given: {"helloworld" 0}, Expect: ""
;; #3: Given: {"helloworld" <0}, Expect: ""
;; #4: Given: {"helloworld" 10}, Expect: "helloworld"
;; #5: Given: {"helloworld" >10}, Expect: "helloworld"
;; 3b. TESTS
#;1 (check-expect (before-string (make-editor "helloworld" 5)) "hello")
#;2 (check-expect (before-string (make-editor "helloworld" 0)) "")
#;3 (check-expect (before-string (make-editor "helloworld" -1)) "")
#;4 (check-expect (before-string (make-editor "helloworld" 10)) "helloworld")
#;5 (check-expect (before-string (make-editor "helloworld" 100)) "helloworld")
;; 4. TEMPLATE
;; (define (before-string e)
;;   (... (editor-text e) ... (editor-index e) ...))
;; 5. CODE
(define (before-string e)
  (cond
    [(<= (editor-index e) 0) ""]
    [(>= (editor-index e) (string-length (editor-text e))) (editor-text e)]
    [else (substring (editor-text e) 0 (editor-index e))]
    )
  )


;; 2a. FUNCTION SIGNATURE: Editor -> String
;; 2b. PURPOSE STATEMENT: Consumes an editor and returns the portion of the
;; string after the cursor.
;; 2c. HEADER
;; (define (after-string e) "")
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5}, Expect: "world"
;; #2: Given: {"helloworld" 0}, Expect: "helloworld"
;; #3: Given: {"helloworld" <0}, Expect: "helloworld"
;; #4: Given: {"helloworld" 10}, Expect: ""
;; #5: Given: {"helloworld" >10}, Expect: ""
;; 3b. TESTS
#;1 (check-expect (after-string (make-editor "helloworld" 5)) "world")
#;2 (check-expect (after-string (make-editor "helloworld" 0)) "helloworld")
#;3 (check-expect (after-string (make-editor "helloworld" -1)) "helloworld")
#;4 (check-expect (after-string (make-editor "helloworld" 10)) "")
#;5 (check-expect (after-string (make-editor "helloworld" 100)) "")
;; 4. TEMPLATE
;; (define (after-string e)
;;   (... (editor-text e) ... (editor-index e) ...))
;; 5. CODE
(define (after-string e)
  (cond
    [(<= (editor-index e) 0) (editor-text e)]
    [(>= (editor-index e) (string-length (editor-text e))) ""]
    [else
     (substring
      (editor-text e)
      (editor-index e)
      (string-length (editor-text e)))]
    )
  )


;; 2a. FUNCTION SIGNATURE: Editor -> Image
;; 2b. PURPOSE STATEMENT: Which consumes an Editor (e) and produces an image.
;; 2c. HEADER
;; (define (render e) EMPTY_SCENE)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5},
;;     Expect: image with CURSOR between the words o and w
;; #2: Given: {"helloworld" 0}, Expect: image with CURSOR before h
;; #3: Given: {"helloworld" 10}, Expect: image with CURSOR after d
;; #4: Given: {"helloworld" >10}, Expect: image with CURSOR after d
;; 3b. TESTS
#;1 (check-expect (render (make-editor "helloworld" 5))
                  (overlay/align "left" "center"
                                 (beside (text "hello" TEXT_SIZE TEXT_COLOR)
                                         CURSOR
                                         (text "world" TEXT_SIZE TEXT_COLOR))
                                 EMPTY_SCENE))
#;2 (check-expect (render (make-editor "helloworld" 0))
                  (overlay/align "left" "center"
                                 (beside CURSOR
                                         (text "helloworld" TEXT_SIZE TEXT_COLOR))
                                 EMPTY_SCENE))
#;3 (check-expect (render (make-editor "helloworld" 10))
                  (overlay/align "left" "center"
                                 (beside
                                  (text "helloworld" TEXT_SIZE TEXT_COLOR) CURSOR)
                                 EMPTY_SCENE))
#;4 (check-expect (render (make-editor "helloworld" 100))
                  (overlay/align "left" "center"
                                 (beside
                                  (text "helloworld" TEXT_SIZE TEXT_COLOR) CURSOR)
                                 EMPTY_SCENE))
;; 4. TEMPLATE
;; (define (render e)
;;   (... (editor-pre e) ... (editor-post e) ...))
;; 5. CODE
(define (render e)
  (overlay/align "left" "center"
                 (beside (text (before-string e) TEXT_SIZE TEXT_COLOR)
                         CURSOR
                         (text (after-string e) TEXT_SIZE TEXT_COLOR))
                 EMPTY_SCENE))


;; 2a. FUNCTION SIGNATURE: Editor KeyEvent -> Editor 
;; 2b. PURPOSE STATEMENT: Consumes two inputs, an Editor (e) and a KeyEvent (ke),
;; and it produces another editor.
;; 2c. HEADER
;; (define (edit e ke) e)
;; 3a. FUNCTIONAL EXAMPLES
;; #1: Given: {"helloworld" 5} "\t", Expect: {"helloworld" 5}
;; #2: Given: {"helloworld" 0} "\t", Expect: {"helloworld" 0}
;; #3: Given: {"helloworld" 10} "\t", Expect: {"helloworld" 10}
;; #4: Given: {"helloworld" 100} "\t", Expect: {"helloworld" 100}
;; #5: Given: {"" 0} "\t", Expect: {"" 0}
;; #6: Given: {"helloworld" 5} "\r", Expect: {"helloworld" 5}
;; #7: Given: {"helloworld" 0} "\r", Expect: {"helloworld" 0}
;; #8: Given: {"helloworld" 10} "\r", Expect: {"helloworld" 10}
;; #9: Given: {"helloworld" 100} "\r", Expect: {"helloworld" 100}
;; #10: Given: {"" 0} "\r", Expect: {"" 0}
;; #11: Given: {"helloworld" 5} "\b", Expect: {"hellworld" 4}
;; #12: Given: {"helloworld" 0} "\b", Expect: {"helloworld" 0}
;; #13: Given: {"helloworld" 10} "\b", Expect: {"helloworl" 9}
;; #14: Given: {"helloworld" 100} "\b", Expect: {"helloworl" 9}
;; #15: Given: {"" 0} "\b", Expect: {"" 0}
;; #16: Given: {"helloworld" 5} "left", Expect: {"helloworld" 4}
;; #17: Given: {"helloworld" 0} "left", Expect: {"helloworld" 0}
;; #18: Given: {"helloworld" 10} "left", Expect: {"helloworld" 9}
;; #18: Given: {"helloworld" 100} "left", Expect: {"helloworld" 9}
;; 3b. TESTS
#;1 (check-expect (edit (make-editor "helloworld" 5) "\t")
                  (make-editor "helloworld" 5))
#;2 (check-expect (edit (make-editor "helloworld" 0) "\t")
                  (make-editor "helloworld" 0))
#;3 (check-expect (edit (make-editor "helloworld" 10) "\t")
                  (make-editor "helloworld" 10))
#;4 (check-expect (edit (make-editor "helloworld" 100) "\t")
                  (make-editor "helloworld" 100))
#;5 (check-expect (edit (make-editor "" 0) "\t")
                  (make-editor "" 0))
#;6 (check-expect (edit (make-editor "helloworld" 5) "\r")
                  (make-editor "helloworld" 5))
#;7 (check-expect (edit (make-editor "helloworld" 0) "\r")
                  (make-editor "helloworld" 0))
#;8 (check-expect (edit (make-editor "helloworld" 10) "\r")
                  (make-editor "helloworld" 10))
#;9 (check-expect (edit (make-editor "helloworld" 100) "\r")
                  (make-editor "helloworld" 100))
#;10 (check-expect (edit (make-editor "" 0) "\r")
                   (make-editor "" 0))
#;11 (check-expect (edit (make-editor "helloworld" 5) "\b")
                   (make-editor "hellworld" 4))
#;12 (check-expect (edit (make-editor "helloworld" 0) "\b")
                   (make-editor "helloworld" 0))
#;13 (check-expect (edit (make-editor "helloworld" 10) "\b")
                   (make-editor "helloworl" 9))
#;14 (check-expect (edit (make-editor "helloworld" 100) "\b")
                   (make-editor "helloworl" 9))
#;15 (check-expect (edit (make-editor "" 0) "\b")
                   (make-editor "" 0))
#;16 (check-expect (edit (make-editor "" -1) "\b")
                   (make-editor "" 0))
#;17 (check-expect (edit (make-editor "helloworld" 5) "left")
                   (make-editor "helloworld" 4))
#;18 (check-expect (edit (make-editor "helloworld" 10) "left")
                   (make-editor "helloworld" 9))
#;19 (check-expect (edit (make-editor "helloworld" 100) "left")
                   (make-editor "helloworld" 9))
#;20 (check-expect (edit (make-editor "helloworld" 0) "left")
                   (make-editor "helloworld" 0))
#;21 (check-expect (edit (make-editor "helloworld" -1) "left")
                   (make-editor "helloworld" 0))
#;22 (check-expect (edit (make-editor "helloworld" 5) "right")
                   (make-editor "helloworld" 6))
#;23 (check-expect (edit (make-editor "helloworld" 10) "right")
                   (make-editor "helloworld" 10))
#;24 (check-expect (edit (make-editor "helloworld" 100) "right")
                   (make-editor "helloworld" 10))
#;25 (check-expect (edit (make-editor "helloworld" 0) "right")
                   (make-editor "helloworld" 1))
#;26 (check-expect (edit (make-editor "helloworld" -1) "right")
                   (make-editor "helloworld" 1))
#;27 (check-expect (edit (make-editor "helloworld" 5) " ")
                   (make-editor "hello world" 6))
#;28 (check-expect (edit (make-editor "helloworld" 10) " ")
                   (make-editor "helloworld " 11))
#;29 (check-expect (edit (make-editor "helloworld" 100) " ")
                   (make-editor "helloworld " 11))
#;30 (check-expect (edit (make-editor "helloworld" 0) " ")
                   (make-editor " helloworld" 1))
#;31 (check-expect (edit (make-editor "helloworld" -1) " ")
                   (make-editor " helloworld" 1))
#;32 (check-expect (edit (make-editor "WWWWWWWWWWWWW" 0) "X")
                   (make-editor "WWWWWWWWWWWWW" 0))
#;33
(check-expect
 (edit (make-editor "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii" 0) "X")
 (make-editor "iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii" 0))
;; 4. TEMPLATE
;; (define (edit e ke)
;;   (... (editor-text e) ... (editor-index e) ... ke ...))
;; 5. CODE
(define (edit e ke)
  (cond
    [(string=? "\r" ke) e]
    [(string=? "\t" ke) e]
    [(string=? "\b" ke) (backspace e)]
    [(string=? "left" ke) (move-cursor-left e)]
    [(string=? "right" ke) (move-cursor-right e)]
    [(and
      (= (string-length ke) 1)
      (<= (compute-new-editor-image-length e ke) MAX_EDITOR_TEXT_IMAGE_LENGTH))
     (insert e ke)]
    [else e]
    )
  )


;; 2a. FUNCTION SIGNATURE: String -> Editor
;; 2b. PURPOSE STATEMENT: Consumes a string, the pre field of an editor, and
;; launches an interactive editor, using render and edit.
;; 2c. HEADER
;; (define (run s) (make-editor s ""))
;; 3a. FUNCTIONAL EXAMPLES: NA
;; 3b. TESTS: NA
;; 4. TEMPLATE
;; (define (run s)
;;   (... s ...))
;; 5. CODE
(define (run s)
  (big-bang (make-editor s (string-length s))
            [to-draw render]
            [on-key edit]
            )
  )


(run "12345678901234567890")


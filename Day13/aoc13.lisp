; sbcl --script aoc13.lisp

; Day 13 of AOC 2024
(write-line "Day 13 of AOC 2024")

; Part 1
(write-line "Part 1")

(defparameter *filename* "input.txt")

; check prefix
(defun string-prefix-p (prefix string)
    (and (<= (length prefix) (length string))
        (string= prefix (subseq string 0 (length prefix)))
    )
)

; split sequence
(defun split-sequence (delimiter string)
    (let ((start 0)
        (result '()))
        (loop for i = (position delimiter string :start start)
            while i
            do (push (subseq string start i) result)
            (setq start (1+ i))
        )
        (push (subseq string start) result)
        (reverse result)
    )
)

; extract information from a block
(defun extract-block-data (block)
    (let ((prize-x nil)
          (prize-y nil)
          (btn-a-x nil)
          (btn-a-y nil)
          (btn-b-x nil)
          (btn-b-y nil)
         )
    (dolist (line block)
        (cond
            ((string-prefix-p "Button A:" line)
                (let* ((parts (subseq line 9))
                    (coords (split-sequence #\, parts)))
                    (setq btn-a-x (parse-integer (subseq (string-trim " " (car coords)) 2)))
                    (setq btn-a-y (parse-integer (subseq (string-trim " " (cadr coords)) 2)))
                )
            )
            ((string-prefix-p "Button B:" line)
                (let* ((parts (subseq line 9))
                    (coords (split-sequence #\, parts)))
                    (setq btn-b-x (parse-integer (subseq (string-trim " " (car coords)) 2)))
                    (setq btn-b-y (parse-integer (subseq (string-trim " " (cadr coords)) 2)))
                )
            )
            ((string-prefix-p "Prize:" line)
                (let* ((parts (subseq line 6))
                    (coords (split-sequence #\, parts)))
                    (setq prize-x (parse-integer (subseq (string-trim " " (car coords)) 2)))
                    (setq prize-y (parse-integer (subseq (string-trim " " (cadr coords)) 2)))
                )
            )
        )
    )
    (list :prize-x prize-x :prize-y prize-y
          :btn-a-x btn-a-x :btn-a-y btn-a-y
          :btn-b-x btn-b-x :btn-b-y btn-b-y
    ))
)

; parse a block
(defun parse-block (stream)
    (let ((block '()))
        (loop for line = (read-line stream nil)
            while (and line (not (string= line "")))
            do (push line block)
        )
        (reverse block)
    )
)

; parse all blocks
(defun parse-blocks-all (filename)
    (with-open-file (stream filename)
        (let ((blocks '()))
            (loop for block = (parse-block stream)
                while block
                do (push block blocks)
            )
            (reverse blocks)
        )
    )
)

; extract all block data
(defun extract-block-data-all (filename)
    (let ((blocks (parse-blocks-all filename))
        (result '())
    ) (dolist (block blocks)
        (push (extract-block-data block) result)
    )
    (reverse result))
)

; read file parsed in blocks
(defun read-file (filename)
    (let ((data (extract-block-data-all filename)))
        (dolist (block data)
            (format t "Button A: X+~A, Y+~A~%" (getf block :btn-a-x) (getf block :btn-a-y))
            (format t "Button B: X+~A, Y+~A~%" (getf block :btn-b-x) (getf block :btn-b-y))
            (format t "Prize: X=~A, Y=~A~%" (getf block :prize-x) (getf block :prize-y))
            (format t "~%")
        )
    )
)

; calculate the minimum cost
(defun minimum-cost-block (block-data)
    (let* ((prize-x (getf block-data :prize-x))
           (prize-y (getf block-data :prize-y))
           (btn-a-x (getf block-data :btn-a-x))
           (btn-a-y (getf block-data :btn-a-y))
           (btn-b-x (getf block-data :btn-b-x))
           (btn-b-y (getf block-data :btn-b-y))
           (min-cost most-positive-fixnum)
          )
        (loop for a-presses from 0 to 100
            do (loop for b-presses from 0 to 100
                do (let* ((x (+ (* a-presses btn-a-x) (* b-presses btn-b-x)))
                          (y (+ (* a-presses btn-a-y) (* b-presses btn-b-y)))
                          (total-cost (+ (* a-presses 3) (* b-presses 1)))
                   )
                    (when (and (= x prize-x) (= y prize-y))
                        (setq min-cost (min min-cost total-cost))
                        ;(format t "prize reached: (~A, ~A): ~A~%" a-presses b-presses min-cost)
                    )
                )
            )
        )
        (if (= min-cost most-positive-fixnum) nil min-cost)
    )
)

; play the machine
(defun play-machine (filename)
    (let ((data (extract-block-data-all filename))
          (total-cost 0))
        (dolist (block data)
            (let ((min-cost (minimum-cost-block block)))
                ;(if min-cost
                ;    (format t "Minimum cost to reach Prize (~A, ~A): ~A~%" (getf block :prize-x) (getf block :prize-y) min-cost)
                ;    (format t "Cannot reach Prize (~A, ~A)~%" (getf block :prize-x) (getf block :prize-y))
                ;)
                (when min-cost (setq total-cost (+ total-cost min-cost)))
            )
        )
        (format t "Total cost: ~A~%" total-cost)
    )
)

;(read-file *filename*)
(play-machine *filename*)


; Part 2
(write-line "Part 2")


; solve alpha beta
(defun solve-alpha-beta (px py ax ay bx by)
    (let* ((det (- (* ax by) (* ay bx))))
        ;(format t "det: ~a~%" det)

        (let* ((alpha (if (/= det 0)
                (and (integerp (/ (- (* by px) (* bx py)) det))
                     (/ (- (* by px) (* bx py)) det))
                nil))

               (beta (if (/= det 0)
                (and (integerp (/ (- (* ax py) (* ay px)) det))
                     (/ (- (* ax py) (* ay px)) det))
                nil))
              )

            ;(format t "alpha: ~a~%" alpha)
            ;(format t "beta: ~a~%" beta)

            (if (and alpha beta (>= alpha 0) (>= beta 0))
                (list alpha beta)
                nil
            )
        )
    )
)

; calculate the minimum cost, based on linear algebra
(defun minimum-cost-block-fast (block-data)
    (let* ((prize-x (getf block-data :prize-x))
           (prize-y (getf block-data :prize-y))
           (btn-a-x (getf block-data :btn-a-x))
           (btn-a-y (getf block-data :btn-a-y))
           (btn-b-x (getf block-data :btn-b-x))
           (btn-b-y (getf block-data :btn-b-y))
           (result (solve-alpha-beta (+ prize-x 10000000000000) (+ prize-y 10000000000000) btn-a-x btn-a-y btn-b-x btn-b-y))
          )
        (if result
            (let* ((alpha (first result))
                   (beta (second result))
                  )
                (+ (* alpha 3) (* beta 1))
            )
            nil
        )
    )
)

; play the machine (faster)
(defun play-machine-fast (filename)
    (let ((data (extract-block-data-all filename))
          (total-cost 0))
        (dolist (block data)
            (let ((min-cost (minimum-cost-block-fast block)))
                ;(if min-cost
                ;    (format t "Minimum cost to reach Prize (~A, ~A): ~A~%" (getf block :prize-x) (getf block :prize-y) min-cost)
                ;    (format t "Cannot reach Prize (~A, ~A)~%" (getf block :prize-x) (getf block :prize-y))
                ;)
                (when min-cost (setq total-cost (+ total-cost min-cost)))
            )
        )
        (format t "Total cost: ~A~%" total-cost)
    )
)
(play-machine-fast *filename*)















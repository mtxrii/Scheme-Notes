(define (factorial n)
  (if (< n 0) #f
      (if (< n 2) 1
          (* n (factorial (- n 1))))))

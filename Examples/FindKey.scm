

(define (find op var list)
  (cond ((null? list) #f)
        ((op var (car (car list))) (cdr (car list)))
        (else (find op var (cdr list)))))

(find = 3 `((1 2) (3 4) (5 6)))
(find = 3 `((5 6) (7 8)))

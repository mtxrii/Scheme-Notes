(define (reverse list)
        (define (rev in out)
                (if (null? in) out
                    (rev (cdr in) (cons (car in) out))))
        (rev list '()))

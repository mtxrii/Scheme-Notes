(define (fold_left op mod list)
  (if (null? list) mod
      (fold_left op (op mod (car list)) (cdr list))))

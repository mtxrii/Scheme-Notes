## How computers read code
Lets look at normal code in c or something.
```c
x = 3 + 9 * round(20.8 / abs(-10)) - y
```
When our interpreter or compiler reads this, it can't simply traverse it left to right. Theres an order it needs to follow. Like a PEMDAS of sort but also accounting for functions and variables and such. It goes something like:
1. determine outermost operation and evaluate children
2. inside children, identify functions and vars
3. inside functions, repeat process for args
4. outside functions, evaluate each value and operator according to PEMDAS

Once the code is evaluated into a series of nested operations, it can be solved.

So the steps the system would take to evaluate the above example into nested operations might look something like this:

1. `abs(-10)` -> `(abs -10)`
2. `20.8 / (abs -10)` -> `(/ 20.8 (abs -10))`
3. `round(/ 20.8 (abs -10))` -> `(round (/ 20.8 (abs -10)))`
4. `9 * (round (/ 20.8 (abs -10)))` -> `(* 9 (round (/ 20.8 (abs -10))))`
5. `3 + (* 9 (round (/ 20.8 (abs -10))))` -> `(+ 3 (* 9 (round (/ 20.8 (abs -10)))))`
6. `y` -> `(eval y)`
7. `(+ 3 (* 9 (round (/ 20.8 (abs -10))))) - (eval y)` -> `(- (+ 3 (* 9 (round (/ 20.8 (abs -10))))) (eval y))`
8. `x = ...` -> `(set x ...)`
9. `(set x (- (+ 3 (* 9 (round (/ 20.8 (abs -10))))) (eval y)))`

Once this step is complete, our machine can read these nested expressions and solve them.

But what if we skipped this step and just gave our interpreter or compiler the above code? It would take it in and solve it immediately without wasting time evaluating it into nested expressions.

# Scheme
Thats what scheme does. And in a surprisingly human-readable way too.

Lets look at a factorial function in python.
```python
def fact(n):
  if n < 0:
    return False
    
  if n < 2:
    return 1
    
  return n * fact(n - 1)
```
To parse this, python's interpreter would follow similar steps as the ones above. Lets look at the process line by line.
1. `def fact(n):` -> `(define (fact n))`
2. `if n < 0:` -> `(if (< n 0) (do something...))`
3. `return False` -> `(False)`
4. `if n < 2:` -> `(if (< n 2) (do something...))`
5. `return 1` -> `(1)`
6. `else return n * fact(n - 1)` -> `(* n (fact (- n 1)))`

Our end result, and similarly, our code in scheme, would look like this:
```scheme
(define (fact n)
  (if (< n 0) #f
      (if (< n 2) 1
          (* n (fact (- n 1))))))
```
A few notes:
* `#f` means false
* there are indents where an `else` would be
* there is no return, just a value which due to its position is already an endpoint.

## Syntax

Okay let's backtrack a bit. How do we start?

First thing, scheme follows the [polish notation](https://en.wikipedia.org/wiki/Polish_notation) syntax. What this means is that instead of writing expressions like this: `3 + 4` we write them with the operator first, like this: `+ 3 4`. This is because internally this is how computers evaluate functions.

So lets see how to do some stuff.

Math:
```scheme
(+ 3 (- 7 4))
; => 6

(remainder 5 2)
; => 1
```

Defining variables:
```scheme
(define x "Foo")
```
* Variables can hold anything, from a string to a function.

Changing variables:
```scheme
(set! x "Bar")
```

Printing:
```scheme
(display x)
; => "Bar"
```

Pairs (immutable):
```scheme
(cons 3 5)
; => '(3 . 5)
(car (cons 3 5))
; => 3
(cdr (cons 3 5))
; => 5
```
* Create one with `cons`
* Access first and second elements with `car` and `cdr`

Lists (linked-list cons):
```scheme
(cons 1 (cons 2 (cons 3 `() )))
; => '(1 2 3)
```

Shorthand for creating lists:
```scheme
`(4 5 6 7)
; => `(4 5 6 7)
```

Accessing list elements:
```scheme
(define fruit '("Apple" "Orange" "Mango" "Kiwi"))

(car fruit)
; => "Apple"
(cdr fruit)
; => '("Orange" "Mango" "Kiwi")
(cdr (cdr fruit))
; => '("Mango" "Kiwi")
(cdr (cdr (cdr fruit)))
; => '("Kiwi")
```
This is because they are in linked list format. Iterator functions exist however to search for things recursively.

Functions:
```scheme
(define (hello-world)
    ("Hello, World!")
```
This looks a lot like just any variable. That's because it really is. If we call it we get our value
```scheme
(hello-world )
; => "Hello, World!"
```

Now lets add arguments:
```scheme
(define (hello-space planet)
    (string-append "Hello, " planet)

(hello-space "Neptune")
; => "Hello, Neptune"

(hello-space "Venus")
; => "Hello, Venus"
```

If statements:
```scheme
(define n 12)

(if (< n 24)
    ("n is smaller than 24"))
; => "n is smaller than 24"

(if (> n 20)
    (set! n 100)
("still small"))
; => "still small"
```
* The syntax for if statements is: `(if (condition) (do this) (else do this))`

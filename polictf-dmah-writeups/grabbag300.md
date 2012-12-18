# PoliCTF Grab Bag 300

Grab Bag 300 gives you an html file with embedded obfuscted javascript
and a picture of mr.hanky the christmas poo encoded in base64 in the
html file.

The embedded code looks something like:

    eval(function( some parameters ) {
          e = function(c) {  Does some stuff }
          // some more code that returns text
        }(a huge wall of text for parameters));

    )

Running the code causes this:

    Uncaught RangeError: Maximum call stack size exceeded

The function e returns a base(a) encoding of c, where a is another
parameter given to the outside function as a whole, and c is the
parameter passed directly to e.

    e = function (c) {
        return (c < a ? '' : e(parseInt(c / a))) + ((c = c % a) > 35 ? String.fromCharCode(c + 29) : c.toString(36))
    };

Observing in chrome has us notice that e calls e recursively up until
the point it breaks. Replace e with an iterative equivalent.

    e = function (c) {
        if(c == 0)
          return "0";
        remainder = c
        result = ""
        while (remainder > 0) {
            temp = remainder
            result = ((temp = temp % a) > 35 ? String.fromCharCode(temp + 29) : temp.toString(36)) + result;
            remainder = parseInt(remainder / a);
        }
      	return result;
    }

The function call no longer breaks, but the eval on the returned code
causes a similar issue. The call stack size is exceeded, and it is from
e calling e. The eval broke. Take all of the text that the function
returned, and put it in an html file. It has some difference, but
redefines an e that does the same thing. Replace it again, because there
is actually another eval produced from that text.

Do this replacement of e one more time (so it's been replaced three
times total). Send that code through again and witness something totally
different. Now there is code not wrapped in eval that breaks.

    Uncaught ReferenceError: Arrray is not defined 

%s/Arrray/Array/g on the file and open this file:

    69454623829323481e291a32e7b40aa0

I worked this out with five files:

* challenge.html - the original source
* test1.html - A file that only has the script tag from challenge.html.
  Replace recursive e with iterative e
* test2.html - A file that has the text that the anonymous function in
  test1.html returns. Replace recursive e with iterative e
* test3.html - A file that has the text that the anonymous function in
  test2.html returns. Replace recursive e with iterative e
* test4.html - A file that has the text that the anonymous function in
  test3.html returns. Search/Replace Arrray with Array

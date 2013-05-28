# Arity 

Makes sure that JavaScript functions are called with the expected number of parameters.

[![Build Status](https://travis-ci.org/JonAbrams/arity.png)](https://travis-ci.org/JonAbrams/arity)

## Background

Just like in any programming language JavaScript functions take parameters. Unlike many other programming languages, JavaScript does not require functions to be called with the defined number of parameters.

For example:

    function sum(a, b) {
      return a + b;
    }
    sum(1,2); // returns 3
    sum(2); // returns NaN

Depending on the situation, it might be preferred that an error is thrown when the wrong number of parameters are passed in.

## Usage

It's as simple as wrapping your function with `ar`:

    var sum = ar(function (a, b) {
      return a + b;
    });
    sum(1,2); // returns 3
    sum(2); // throws "Wrong number of parameters. Excpected 2, got 1. Params: a, b."

It's even easier in CoffeeScript (isn't everything?):

    sum = ar (a, b) -> a + b
    sum(1,2) // returns 3
    sum(1,2,3) // throws "Wrong number of parameters. Excpected 2, got 3. Params: a, b."

### Variable Number of Parameters

If you want your function to accept a range of number of parameters (e.g. it can take 2 to 4 parameters), the pass in a min or max value as the 1st and/or 2nd value.

To specify just a minimum number (note that this is in CoffeeScript, it was too long to write in JS):

    sum = ar 2, (nums...) -> nums.reduce (t,s) -> t + s
    sum(1,5) # Returns 6
    sum(2) # Throws "Wrong number of parameters. Excpected 2 or more, got 1."

To specify a range:

    sum = ar 2, 4, (nums...) -> nums.reduce (t,s) -> t + s
    sum(1,5) # Returns 6
    sum(2) # Throws "Wrong number of parameters. Excpected 2 or more, got 1."
    sum(2,5,2,7,9) # Throws "Wrong number of parameters. Excpected 2..4, got 5."

## Installing for Node.js

From the command-line:

    npm install arity

From your app:

    var ar = require("arity");

## Installing for the browser

Download `arity.js` and put it in your `js` folder with your project. Then include it like so:

    <script src="js/arity.js"></script>

You now have access to the `ar` function.

## Tests

    npm install # Installs mocha
    make test

## Credit

Created by [Jon Abrams](http://twitter.com/JonathanAbrams).

Inspired by the [rethinkDB's implementation](https://github.com/rethinkdb/rethinkdb/blob/next/drivers/javascript/src/base.coffee#L11).

I Found out about it from [this blog post](http://andrewberls.com/blog/post/javascript-tricks-enforcing-function-arity) written by Andrew Berls.

## License

Use it however you like, a warranty is neither implied nor provided.

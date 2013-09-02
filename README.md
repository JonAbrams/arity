# Arity

Makes sure that JavaScript functions are called with the expected number of parameters.

[![Build Status](https://travis-ci.org/JonAbrams/arity.png?branch=master)](https://travis-ci.org/JonAbrams/arity)

## Background

Just like in any programming language JavaScript functions take parameters. Unlike many other programming languages, JavaScript does not require functions to be called with the defined number of parameters.

For example:

```js
function sum(a, b) {
  return a + b;
}
sum(1, 2); // returns 3
sum(2); // returns NaN
```

Depending on the situation, it might be preferred that an error is thrown when the wrong number of parameters are passed in.

## Usage

It's as simple as wrapping your function with `ar`:

```js
var sum = ar(function (a, b) {
  return a + b;
});
sum(1, 2); // returns 3
sum(2); // throws "Wrong number of parameters. Excpected 2, got 1. Params: a, b."
```

It's even easier in CoffeeScript (isn't everything?):

```coffee
sum = ar (a, b) -> a + b
sum(1, 2) # returns 3
sum(1, 2, 3) # throws "Wrong number of parameters. Excpected 2, got 3. Params: a, b."
```

By default, `ar` will detect the number of parameters your function is expecting an enforce it by throwing an error when it is called with a different number of parameters.

### Variable Number of Parameters

If you want your function to accept a range of number of parameters (e.g. it can take 2 to 4 parameters), the pass in a min or max value as the 1st and/or 2nd value.

To specify just a minimum number (note that this is in CoffeeScript, it was too long to write in JS):

```coffee
sum = ar 2, (nums...) -> nums.reduce (t,s) -> t + s
sum(1, 5) # Returns 6
sum(2) # Throws "Wrong number of parameters. Excpected 2 or more, got 1."
```

To specify a range:

```coffee
sum = ar 2, 4, (nums...) -> nums.reduce (t,s) -> t + s
sum(1, 5) # Returns 6
sum(2) # Throws "Wrong number of parameters. Excpected 2..4, got 1."
sum(2, 5, 2, 7, 9) # Throws "Wrong number of parameters. Excpected 2..4, got 5."
```

### Specifying Parameter Types

If you want, you can easily enforce the type of variables that are passed into your function.

Just pass in the types as strings into `ar` before passing in your function:

```coffee
sum = ar "number", "number", (a, b) -> a + b
sum(1, '2') # Throws "Invalid parameter. Expected parameter 1 to be of type 'Number' but got 'String'."
```

In addition to supporting native JavaScript types like "number", "string", "boolean", "function", and "object", it also supports user defined types/classes).

Example in JavaScript:

```js
function Lannister(name) {
  this.name = name;
}

function Stark(name) {
  this.name = name;
}

var lannisterMotto = ar("Lannister", function (person) {
  return person.name + " always pays his debts.";
});

lannisterMotto( new Lannister("Tyrion") ); // Returns "Tyrion always pays his debts."
lannisterMotto( new Stark("Ned") ); // Throws "Invalid parameter. Expected parameter 0 to be of type 'Lannister' but got 'Stark'."
```

Example in CoffeeScript:

```coffee
class House
  constructor: (@name) ->

class Lannister extends House
class Stark extends House

lannisterMotto = ar "Lannister", (person) ->
  "#{person.name} always pays his debts."

lannisterMotto( new Lannister("Tyrion") ); # Returns "Tyrion always pays his debts."
lannisterMotto( new Stark("Ned") ); # "Throws Invalid parameter. Expected parameter 0 to be of type 'Lannister' but got 'Stark'."
```

### Enforcing object structure

In JS, you'll often have a bunch of parameters passed in via an object literal. The contents of these can also be checked for type.

Example in CoffeeScript:

```coffee
# Example 1
magicNumSchema = i: "number", r: "number"
# iSum is a function that takes two imaginary numbers and sums them
iSum = ar magicNumSchema, magicNumSchema, (a,b) -> i: a.i + b.i, r: a.r + b.r
magic1 = i: 5, r: 3
magic2 = i: 2, r: '7'
iSum(magic1, magic2) # Throws an exception since 'magic[r]' is of the wrong type

# Example 2
magic1 = i: 5, r: 3, comment: "This will be ignored since it isn't in magicNumSchema"
magic2 = i: 2, r: 7
iSum(magic1, magic2) # Returns { i: 7, r: 10 }
```

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

I found out about it from [this blog post](http://andrewberls.com/blog/post/javascript-tricks-enforcing-function-arity) written by Andrew Berls.

## License

The MIT License (MIT)

Copyright (c) 2013 Jonathan Abrams

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

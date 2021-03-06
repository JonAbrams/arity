should = require("should")
ar = require("../arity")

describe 'ar', ->
  describe "just a function is provided", ->
    it 'throws when there are too many parameters', ->
      (->
        func = ar ->
        func("param1")
      ).should.throw("Wrong number of parameters. Excpected 0, but got 1.")

    it 'throw when there are too few parameters', ->
      (->
        func = ar (a, b) ->
        func()
      ).should.throw("Wrong number of parameters. Excpected 2, but got 0. Params: a, b.")

    it 'mentions the parameters when throwing an error', ->
      (->
        func = ar (a, b) ->
        func()
      ).should.throw("Wrong number of parameters. Excpected 2, but got 0. Params: a, b.")

    it 'mentions the function\'s name when throwing an error', ->
      (->
        func = ar `function myFunc (a, b) { }`
        func()
      ).should.throw("Wrong number of parameters when calling 'myFunc'. Excpected 2, but got 0. Params: a, b.")

    it 'throws when a function isn\'t passed in', ->
      (->
        ar(1)
      ).should.throw("Invalid parameter. Function required.")

    it 'runs the function when the right number of parameters are passed in', ->
      obj = {
        sum: ar (a,b) -> a + b
      }
      obj.sum(2, 3).should.eql 5

  describe "Minimum value provided", ->
    it 'throws if the min value isn\'t a positive number', ->
      (->
        ar -1, (a,b) -> a + b
      ).should.throw("Invalid minimum value. Expected positive integer, but got -1.")

    it 'throws if the min value isn\'t an integer', ->
      (->
        ar 1.5, (a,b) -> a + b
      ).should.throw("Invalid minimum value. Expected positive integer, but got 1.5.")

    it 'throws if fewer than the minimum number of parameters are passed', ->
      (->
        func = ar 3, (args...) -> args.length
        func(1,2)
      ).should.throw("Wrong number of parameters. Excpected 3 or more, but got 2.")

    it 'runs the function when the min number of parameters are passed in', ->
      func = ar 3, (args...) -> args.length
      func(1,2,3,4).should.eql 4

  describe "Maximum and minimum value provided", ->
    it 'throws if the max value isn\'t a number', ->
      (->
        ar 1, "oops", (a,b) -> a + b
      ).should.throw("Invalid maximum value. Expected positive integer, but got oops.")

    it 'throws if the max value isn\'t a positive number', ->
      (->
        ar 1, -3, (a,b) -> a + b
      ).should.throw("The max parameter must be greater than or equal to the min.")

    it 'throws if the max value isn\'t an integer', ->
      (->
        ar 1, 3.2, (a,b) -> a + b
      ).should.throw("Invalid maximum value. Expected positive integer, but got 3.2.")

    it 'throws if the max value is less than the min value', ->
      (->
        ar 5, 3, (a,b) -> a + b
      ).should.throw("The max parameter must be greater than or equal to the min.")

    it 'throws if more than the maximum number of parameters are passed', ->
      (->
        func = ar 0, 3, (args...) -> args.length
        func()
        func(1,2,3,4)
      ).should.throw("Wrong number of parameters. Excpected 0..3, but got 4.")

    it 'runs the function when the correct number of parameters are passed in', ->
      func = ar 2, 4, (args...) -> args.length
      func(1,2,3,4).should.eql 4

  describe "Type Mode", ->
    it 'throws if a value is passed not matching the specified type', ->
      (->
        func = ar "number", "number", (a,b) -> a + b
        func(1, '2')
      ).should.throw("Invalid parameter. Expected parameter 1 to be of type 'Number' but got 'String'.")

    it 'should succeed if the right value types are passed in', ->
      func = ar "number", "number", (a,b) -> a + b
      func(1,2).should.eql 3

    it 'works with user-defined classes', ->
      class Lannister
      tyrion = new Lannister()
      lannisterMotto = ar "Lannister", (person) ->
        "A Lannister always pays his debts."
      lannisterMotto(tyrion).should.eql "A Lannister always pays his debts."

    it 'throws when wrong user-defined class is used', ->
      class Stark
      aria = new Stark()
      lannisterMotto = ar "Lannister", (person) ->
        "A Lannister always pays his debts."
      (->
        lannisterMotto aria
      ).should.throw("Invalid parameter. Expected parameter 0 to be of type 'Lannister' but got 'Stark'.")

    it 'allows anything if a wildcard is used', ->
      # Assign key/value if it doesn't exist
      safeInserter = (obj, key, value) ->
        obj[key] = value if key not of obj
      safeInserter = ar "object", "string", "*", safeInserter

      person = { name: "Jon" }
      safeInserter person, "name", "Julie"
      safeInserter person, "age", 30
      person.should.eql { name: "Jon", age: 30 }

  describe "Object Testing", ->
    it 'throws if an object doesnt\'t match up', ->
      (->
        magicNumSchema = i: "number", r: "number"
        iSum = ar magicNumSchema, magicNumSchema, (a,b) -> i: a.i + b.i, r: a.r + b.r
        magic1 = i: 5, r: 3
        magic2 = i: 2, r: '7'
        iSum(magic1, magic2)
      ).should.throw 'Invalid parameter. Expected parameter 1 to match `{ "i": "number", "r": "number" }` but got `{ "i": 2, "r": "7" }`.'

    it 'succeeds when the object does match up', ->
      magicNumSchema = i: "number", r: "number"
      iSum = ar magicNumSchema, magicNumSchema, (a,b) -> i: a.i + b.i, r: a.r + b.r
      magic1 = i: 5, r: 3, comment: "This key/value shouldn't matter"
      magic2 = i: 2, r: 7
      iSum(magic1, magic2).should.eql { i: 7, r: 10 }


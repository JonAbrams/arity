should = require("should")
ar = require("../arity")

describe 'ar', ->
  describe "when just a function is provided", ->
    it 'throws when there are too many parameters', ->
      (->
        func = ar ->
        func("param1")
      ).should.throw()

    it 'throw when there are too few parameters', ->
      (->
        func = ar (a, b) ->
        func()
      ).should.throw()

    it 'mentions the parameters when throwing an error', ->
      (->
        func = ar (a, b) ->
        func()
      ).should.throw(/.*a, b.*/)

    it 'mentions the function\'s name when throwing an error', ->
      (->
        func = ar `function myFunc (a, b) { }`
        func()
      ).should.throw(/.*myFunc.*/)

    it 'throws when a function isn\'t passed in', ->
      (->
        ar(1)
      ).should.throw()

    it 'runs the function when the right number of parameters are passed in', ->
      obj = {
        sum: ar (a,b) -> a + b
      }
      obj.sum(2, 3).should.eql 5

  describe "Minimum value provided", ->
    it 'throws if the min value isn\'t a number', ->
      (->
        ar "oops", (a,b) -> a + b
      ).should.throw()

    it 'throws if the min value isn\'t a positive number', ->
      (->
        ar -1, (a,b) -> a + b
      ).should.throw()

    it 'throws if the min value isn\'t an integer', ->
      (->
        ar 1.5, (a,b) -> a + b
      ).should.throw()

    it 'throws if fewer than the minimum number of parameters are passed', ->
      (->
        func = ar 3, (args...) -> args.length
        func(1,2)
      ).should.throw()

    it 'runs the function when the min number of parameters are passed in', ->
      func = ar 3, (args...) -> args.length
      func(1,2,3,4).should.eql 4

  describe "Maximum value provided", ->
    it 'throws if the max value isn\'t a number', ->
      (->
        ar 1, "oops", (a,b) -> a + b
      ).should.throw()

    it 'throws if the max value isn\'t a positive number', ->
      (->
        ar 1, -3, (a,b) -> a + b
      ).should.throw()

    it 'throws if the max value isn\'t an integer', ->
      (->
        ar 1, 3.2, (a,b) -> a + b
      ).should.throw()

    it 'throws if the max value is less than the min value', ->
      (->
        ar 5, 3, (a,b) -> a + b
      ).should.throw()

    it 'throws if more than the maximum number of parameters are passed', ->
      (->
        func = ar 0, 3, (args...) -> args.length
        func()
        func(1,2,3,4)
      ).should.throw()

    it 'runs the function when the correct number of parameters are passed in', ->
      func = ar 2, 4, (args...) -> args.length
      func(1,2,3,4).should.eql 4

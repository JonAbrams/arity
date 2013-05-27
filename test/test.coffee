should = require("should")
ar = require("../arity")

describe 'ar', ->
  it 'catches too many parameters', ->
    obj = {
      func: ar ->
    }
    (->
      obj.func("param1")
    ).should.throw()

  it 'catches too few parameters', ->
    obj = {
      func: ar (a, b) ->
    }
    (->
      obj.func()
    ).should.throw()

  it 'mentions the parameters when throwing an error', ->
    obj = {
      func: ar (a, b) ->
    }
    (->
      obj.func()
    ).should.throw(/.*a, b.*/)

  it 'mentions the function\'s name when throwing an error', ->
    obj = {
      func: ar `function myFunc (a, b) { }`
    }
    (->
      obj.func()
    ).should.throw(/.*myFunc.*/)

  it 'runs the function when the right number of parameters are passed in', ->
    obj = {
      sum: ar (a,b) -> a + b
    }
    obj.sum(2, 3).should.eql 5

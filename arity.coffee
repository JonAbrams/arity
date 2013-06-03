# Given a function, returns an array of the function's name and parameters
parseFunc = (func) ->
  [ match, funcName, paramStr ] = /^function (.*)\((.*)\)/.exec func
  return [ funcName, paramStr.split(/\s*,\s*/)... ]

# Given a variable, return its class as a string
getClass = (arg) ->
  return "null" unless arg?
  (/^function (.*)\(/.exec arg.constructor)[1]

titleize = (str) -> str[0].toUpperCase() + str[1..]

nativeTypes = [
  "number"
  "boolean"
  "string"
  "function"
  "object"
]

nativeClasses = titleize(type) for type in nativeTypes

ar = (topArgs...) ->
  min = max = null
  classes = null

  # A function is always expected as the last parameter
  func = topArgs[topArgs.length - 1]
  if typeof func isnt "function"
    throw new Error "Invalid parameter. Function required."

  switch typeof topArgs[0]
    when "function" then null
    when "string"
      classes = topArgs[0...-1]
      for type in classes when typeof type isnt "string"
        throw new Error "Invalid parameter. When first parameter is a string, " +
          "all subsequent parameters must also be a string, with the " +
          "exception of the final parameter, which must be a function."

      # if a lowercase primitive type is passed in, convert it to a titleized
      # class version
      classes = for type in classes
        if type in nativeTypes then titleize(type) else type
    when "number"
      # Ranged Mode: A minimum and/or maximum value are passed in
      switch topArgs.length
        when 2
          min = topArgs[0]
        when 3
          min = topArgs[0]
          max = topArgs[1]
          if max < min
            throw new Error "The max parameter must be greater than or equal to the min."
        else
          throw new Error "Invalid number of parameters. Expected 1..3, but got #{topArgs.length}"
    else
      throw new Error "Invalid parameter. Expected 'number', 'string', or " +
                      "'function' as the first parameter."

  if min? and typeof min isnt "number" or min < 0 or min % 1 != 0
    throw new Error "Invalid minimum value. " +
      "Expected positive integer, but got #{min}."

  if max? and typeof max isnt "number" or max < 0 or max % 1 != 0
    throw new Error "Invalid maximum value set. " +
      "Expected positive integer, got #{max}."

  [ funcName, paramNames... ] = parseFunc(func)

  (args...) =>
    if min?
      max ?= args.length
    else
      min = max = func.length

    # Check that the number of parameters passed in are within the expected
    # range
    if args.length < min or args.length > max
      funcNameStr = paramNameStr = ""
      if funcName
        funcNameStr = " when calling '#{funcName}'"
      if paramNames[0]
        paramNameStr = " Params: #{paramNames.join(', ')}."
      expected = switch
        when min == topArgs[0] and max == topArgs[1]
          "#{min}..#{max}"
        when min == topArgs[0] then "#{min} or more"
        else numParams
      throw new Error "Wrong number of parameters#{funcNameStr}. " +
        "Excpected #{expected}, but got #{args.length}.#{paramNameStr}"

    # Check that the parameters are of the expected type
    if classes?
      for arg, index in args[0...classes.length]
        paramClass = getClass arg
        if paramClass isnt classes[index]
          throw new Error "Invalid parameter. Expected parameter #{index} to " +
            "be of type '#{classes[index]}' but got '#{paramClass}'."
    func.apply this, args

if module?
  # Loaded by require.js
  module.exports = ar
else
  # Loaded the old fashioned way in the browser
  window.ar = ar

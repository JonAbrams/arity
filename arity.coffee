# Given a function, returns an array of the function's name and parameters
parseFunc = (func) ->
  [ match, funcName, paramStr ] = /^function (.*)\((.*)\)/.exec func
  return [ funcName, paramStr.split(/\s*,\s*/)... ]

ar = (topArgs...) ->
  min = max = null
  func = switch topArgs.length
    when 1
      topArgs[0]
    when 2
      min = topArgs[0]
      topArgs[1]
    when 3
      min = topArgs[0]
      max = topArgs[1]
      if max < min
        throw new Error "The max parameter must be greater than or equal to the min."
      topArgs[2]
    else
      throw new Error "Invalid number of parameters. Expected 1..3, got #{topArgs.length}"

  if typeof func isnt "function"
    throw new Error "Invalid parameter. Function required."

  if min? and typeof min isnt "number" or min < 0 or min % 1 != 0
    throw new Error "Invalid minimum value set. " +
      "Expected positive integer, got #{min}."

  if max? and typeof max isnt "number" or max < 0 or max % 1 != 0
    throw new Error "Invalid maximum value set. " +
      "Expected positive integer, got #{min}."

  numParams = func.length
  [ funcName, paramNames... ] = parseFunc(func)

  (args...) =>
    if min?
      max ?= args.length
    else
      min = max = func.length

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
        else args.length
      throw new Error "Wrong number of parameters#{funcNameStr}. " +
        "Excpected #{expected}, got #{args.length}.#{paramNameStr}"
    func.apply this, args

if module?
  # Loaded by require.js
  module.exports = ar
else
  # Loaded the old fashioned way in the browser
  window.ar = ar

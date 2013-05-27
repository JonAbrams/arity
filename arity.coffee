# Given a function, returns an array of the function's name and parameters
parseFunc = (func) ->
  [ match, funcName, paramStr ] = /^function (.*)\((.*)\)/.exec func
  return [ funcName, paramStr.split(/\s*,\s*/)... ]

ar = (func) ->
  if typeof func isnt "function"
    throw new Error "Invalid parameter. Function required."

  numParams = func.length
  [ funcName, paramNames... ] = parseFunc(func)

  (args...) =>
    if args.length != numParams
      funcNameStr = paramStr = ""
      if funcName
        funcNameStr = " when calling '#{funcName}'"
      if paramNames[0]
        paramNameStr = " Params: #{paramNames.join(', ')}."
      throw new Error "Wrong number of parameters#{funcNameStr}. " +
        "Excpected #{numParams}, got #{args.length}.#{paramNameStr}"
    func.apply this, args

if module?
  # Loaded by require.js
  module.exports = ar
else
  # Loaded the old fashioned way in the browser
  window.ar = ar

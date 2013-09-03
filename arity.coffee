# Given a function, returns an array of the function's name and parameters
parseFunc = (func) ->
  [ match, funcName, paramStr ] = /^function (.*)\((.*)\)/.exec func
  return [ funcName, paramStr.split(/\s*,\s*/)... ]

# Given a variable, return its class as a string
getClass = (arg) ->
  return "null" unless arg?
  (/^function (.*)\(/.exec arg.constructor)[1]

titleize = (str) -> str[0].toUpperCase() + str[1..]

printable = (obj) -> JSON.stringify(obj).replace(/\{|:|,/g, "$& ").replace(/}/, " }")

nativeTypes = [
  "number"
  "boolean"
  "string"
  "function"
  "object"
]

nativeClasses = (titleize(type) for type in nativeTypes)

checkClass = (template, obj, argIndex) ->
  top_template = template
  top_obj = obj
  do checkClass_rec = (template, obj) ->
    templateClass = getClass template
    paramClass = getClass obj
    if templateClass is "Object" and paramClass is "Object"
      for key of template
        unless key of obj
          throw new Error "Invalid parameter. Expected parameter #{argIndex} to " +
            "match #{JSON.stringify(template)}."
        checkClass_rec template[key], obj[key], argIndex
    else if paramClass isnt template
      unless paramClass in nativeClasses and paramClass is titleize(template)
        if getClass(top_template) is "Object"
          throw new Error "Invalid parameter. Expected parameter 1 to match " +
            "`#{ printable(top_template) }` but got `#{ printable(top_obj) }`."
        else
          throw new Error "Invalid parameter. Expected parameter #{argIndex} to " +
            "be of type '#{titleize(template)}' but got '#{paramClass}'."

ar = (topArgs...) ->
  min = max = null
  classes = null

  # A function is always expected as the last parameter
  func = topArgs[topArgs.length - 1]
  if typeof func isnt "function"
    throw new Error "Invalid parameter. Function required."

  # This decides what type of parameter checking will be enforced. It all depends
  # on the type of the first parameter
  switch typeof topArgs[0]
    # If the first parameter is a function, then ar will automatically figure out
    # and enforce the number of parameters that the function was defined with.
    when "function" then null
    when "string", "object"
      classes = topArgs[0...-1]
      for type, index in classes when typeof type isnt "string" and getClass(type) isnt "Object"
        throw new Error "Parameter #{index} is an invalid type."

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
    throw new Error "Invalid maximum value. " +
      "Expected positive integer, but got #{max}."

  [ funcName, paramNames... ] = parseFunc(func)

  # Return a new function that enforces the number and/or types of parameters passed
  # in.
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
        else func.length
      throw new Error "Wrong number of parameters#{funcNameStr}. " +
        "Excpected #{expected}, but got #{args.length}.#{paramNameStr}"

    # Check that the parameters are of the expected type
    if classes?
      if args.length isnt classes.length
        throw Error "Wrong number of parameters. Expected #{classes.length} " +
          "but got #{args.length}"
      for arg, index in args
        # Throws error if the argument doesn't match the specified template
        checkClass classes[index], arg, index
    func.apply this, args

if module?
  # Loaded by require.js
  module.exports = ar
else
  # Loaded the old fashioned way in the browser
  window.ar = ar

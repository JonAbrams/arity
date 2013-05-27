// Generated by CoffeeScript 1.5.0
(function() {
  var ar, parseFunc,
    __slice = [].slice;

  parseFunc = function(func) {
    var funcName, match, paramStr, _ref;
    _ref = /^function (.*)\((.*)\)/.exec(func), match = _ref[0], funcName = _ref[1], paramStr = _ref[2];
    return [funcName].concat(__slice.call(paramStr.split(/\s*,\s*/)));
  };

  ar = function(func) {
    var funcName, numParams, paramNames, _ref,
      _this = this;
    if (typeof func !== "function") {
      throw new Error("Invalid parameter. Function required.");
    }
    numParams = func.length;
    _ref = parseFunc(func), funcName = _ref[0], paramNames = 2 <= _ref.length ? __slice.call(_ref, 1) : [];
    return function() {
      var args, funcNameStr, paramNameStr, paramStr;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (args.length !== numParams) {
        funcNameStr = paramStr = "";
        if (funcName) {
          funcNameStr = " when calling '" + funcName + "'";
        }
        if (paramNames[0]) {
          paramNameStr = " Params: " + (paramNames.join(', ')) + ".";
        }
        throw new Error(("Wrong number of parameters" + funcNameStr + ". ") + ("Excpected " + numParams + ", got " + args.length + "." + paramNameStr));
      }
      return func.apply(_this, args);
    };
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = ar;
  } else {
    window.ar = ar;
  }

}).call(this);

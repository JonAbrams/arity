// Generated by CoffeeScript 1.6.2
(function() {
  var ar, getClass, nativeClasses, nativeTypes, parseFunc, titleize, type, _i, _len,
    __slice = [].slice,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  parseFunc = function(func) {
    var funcName, match, paramStr, _ref;

    _ref = /^function (.*)\((.*)\)/.exec(func), match = _ref[0], funcName = _ref[1], paramStr = _ref[2];
    return [funcName].concat(__slice.call(paramStr.split(/\s*,\s*/)));
  };

  getClass = function(arg) {
    if (arg == null) {
      return "null";
    }
    return (/^function (.*)\(/.exec(arg.constructor))[1];
  };

  titleize = function(str) {
    return str[0].toUpperCase() + str.slice(1);
  };

  nativeTypes = ["number", "boolean", "string", "function", "object"];

  for (_i = 0, _len = nativeTypes.length; _i < _len; _i++) {
    type = nativeTypes[_i];
    nativeClasses = titleize(type);
  }

  ar = function() {
    var classes, func, funcName, max, min, paramNames, topArgs, _j, _len1, _ref,
      _this = this;

    topArgs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    min = max = null;
    classes = null;
    func = topArgs[topArgs.length - 1];
    if (typeof func !== "function") {
      throw new Error("Invalid parameter. Function required.");
    }
    switch (typeof topArgs[0]) {
      case "function":
        null;
        break;
      case "string":
        classes = topArgs.slice(0, -1);
        for (_j = 0, _len1 = classes.length; _j < _len1; _j++) {
          type = classes[_j];
          if (typeof type !== "string") {
            throw new Error("Invalid parameter. When first parameter is a string, " + "all subsequent parameters must also be a string, with the " + "exception of the final parameter, which must be a function.");
          }
        }
        classes = (function() {
          var _k, _len2, _results;

          _results = [];
          for (_k = 0, _len2 = classes.length; _k < _len2; _k++) {
            type = classes[_k];
            if (__indexOf.call(nativeTypes, type) >= 0) {
              _results.push(titleize(type));
            } else {
              _results.push(type);
            }
          }
          return _results;
        })();
        break;
      case "number":
        switch (topArgs.length) {
          case 2:
            min = topArgs[0];
            break;
          case 3:
            min = topArgs[0];
            max = topArgs[1];
            if (max < min) {
              throw new Error("The max parameter must be greater than or equal to the min.");
            }
            break;
          default:
            throw new Error("Invalid number of parameters. Expected 1..3, but got " + topArgs.length);
        }
        break;
      default:
        throw new Error("Invalid parameter. Expected 'number', 'string', or " + "'function' as the first parameter.");
    }
    if ((min != null) && typeof min !== "number" || min < 0 || min % 1 !== 0) {
      throw new Error("Invalid minimum value. " + ("Expected positive integer, but got " + min + "."));
    }
    if ((max != null) && typeof max !== "number" || max < 0 || max % 1 !== 0) {
      throw new Error("Invalid maximum value set. " + ("Expected positive integer, got " + max + "."));
    }
    _ref = parseFunc(func), funcName = _ref[0], paramNames = 2 <= _ref.length ? __slice.call(_ref, 1) : [];
    return function() {
      var arg, args, expected, funcNameStr, index, paramClass, paramNameStr, _k, _len2, _ref1;

      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (min != null) {
        if (max == null) {
          max = args.length;
        }
      } else {
        min = max = func.length;
      }
      if (args.length < min || args.length > max) {
        funcNameStr = paramNameStr = "";
        if (funcName) {
          funcNameStr = " when calling '" + funcName + "'";
        }
        if (paramNames[0]) {
          paramNameStr = " Params: " + (paramNames.join(', ')) + ".";
        }
        expected = (function() {
          switch (false) {
            case !(min === topArgs[0] && max === topArgs[1]):
              return "" + min + ".." + max;
            case min !== topArgs[0]:
              return "" + min + " or more";
            default:
              return numParams;
          }
        })();
        throw new Error(("Wrong number of parameters" + funcNameStr + ". ") + ("Excpected " + expected + ", but got " + args.length + "." + paramNameStr));
      }
      if (classes != null) {
        _ref1 = args.slice(0, classes.length);
        for (index = _k = 0, _len2 = _ref1.length; _k < _len2; index = ++_k) {
          arg = _ref1[index];
          paramClass = getClass(arg);
          if (paramClass !== classes[index]) {
            throw new Error(("Invalid parameter. Expected parameter " + index + " to ") + ("be of type '" + classes[index] + "' but got '" + paramClass + "'."));
          }
        }
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

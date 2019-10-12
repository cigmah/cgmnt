(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === elm$core$Basics$EQ ? 0 : ord === elm$core$Basics$LT ? -1 : 1;
	}));
});



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = elm$core$Set$toList(x);
		y = elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (typeof x.$ === 'undefined')
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? elm$core$Basics$LT : n ? elm$core$Basics$GT : elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File === 'function' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[94m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.aI.ae === region.aR.ae)
	{
		return 'on line ' + region.aI.ae;
	}
	return 'on lines ' + region.aI.ae + ' through ' + region.aR.ae;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return word
		? elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? elm$core$Maybe$Nothing
		: elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? elm$core$Maybe$Just(n) : elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




/**_UNUSED/
function _Json_errorToString(error)
{
	return elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? elm$core$Result$Ok(value)
		: (value instanceof String)
			? elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!elm$core$Result$isOk(result))
					{
						return elm$core$Result$Err(A2(elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return elm$core$Result$Ok(elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if (elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return elm$core$Result$Err(elm$json$Json$Decode$OneOf(elm$core$List$reverse(errors)));

		case 1:
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!elm$core$Result$isOk(result))
		{
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList === 'function' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2(elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bG,
		impl.b_,
		impl.bW,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	elm$core$Result$isOk(result) || _Debug_crash(2 /**_UNUSED/, _Json_errorToString(result.a) /**/);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_dispatchEffects(managers, result.b, subscriptions(model));
	}

	_Platform_dispatchEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				p: bag.n,
				q: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.q)
		{
			x = temp.p(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		r: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		r: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**/
	var node = args['node'];
	//*/
	/**_UNUSED/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2(elm$json$Json$Decode$map, func, handler.a)
				:
			A3(elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		C: func(record.C),
		aK: record.aK,
		aG: record.aG
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		((key !== 'value' && key !== 'checked') || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		typeof value !== 'undefined'
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		typeof value !== 'undefined'
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.C;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.aK;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.aG) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		var newMatch = undefined;
		var oldMatch = undefined;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}




// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bG,
		impl.b_,
		impl.bW,
		function(sendToApp, initialModel) {
			var view = impl.b1;
			/**/
			var domNode = args['node'];
			//*/
			/**_UNUSED/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.bG,
		impl.b_,
		impl.bW,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.am && impl.am(sendToApp)
			var view = impl.b1;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.bp);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.bY) && (_VirtualDom_doc.title = title = doc.bY);
			});
		}
	);
});



// ANIMATION


var _Browser_cancelAnimationFrame =
	typeof cancelAnimationFrame !== 'undefined'
		? cancelAnimationFrame
		: function(id) { clearTimeout(id); };

var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { return setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.bO;
	var onUrlRequest = impl.bP;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		am: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.hasAttribute('download'))
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.a8 === next.a8
							&& curr.aW === next.aW
							&& curr.a4.a === next.a4.a
						)
							? elm$browser$Browser$Internal(next)
							: elm$browser$Browser$External(href)
					));
				}
			});
		},
		bG: function(flags)
		{
			return A3(impl.bG, flags, _Browser_getUrl(), key);
		},
		b1: impl.b1,
		b_: impl.b_,
		bW: impl.bW
	});
}

function _Browser_getUrl()
{
	return elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return elm$core$Result$isOk(result) ? elm$core$Maybe$Just(result.a) : elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { bE: 'hidden', bq: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { bE: 'mozHidden', bq: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { bE: 'msHidden', bq: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { bE: 'webkitHidden', bq: 'webkitvisibilitychange' }
		: { bE: 'hidden', bq: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = _Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			_Browser_cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail(elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		bT: _Browser_getScene(),
		b2: {
			j: _Browser_window.pageXOffset,
			k: _Browser_window.pageYOffset,
			bl: _Browser_doc.documentElement.clientWidth,
			aV: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		bl: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		aV: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			bT: {
				bl: node.scrollWidth,
				aV: node.scrollHeight
			},
			b2: {
				j: node.scrollLeft,
				k: node.scrollTop,
				bl: node.clientWidth,
				aV: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			bT: _Browser_getScene(),
			b2: {
				j: x,
				k: y,
				bl: _Browser_doc.documentElement.clientWidth,
				aV: _Browser_doc.documentElement.clientHeight
			},
			bw: {
				j: x + rect.left,
				k: y + rect.top,
				bl: rect.width,
				aV: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2(elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}
var author$project$Main$Normal = 0;
var author$project$Main$Stopped = 1;
var author$project$Main$baseSpeed = 1;
var author$project$Main$InertTaker = F3(
	function (startFrame, angleRadians, proportion) {
		return {ax: angleRadians, z: proportion, d: startFrame};
	});
var author$project$Main$framerate = 20;
var author$project$Main$inertTakerLongevity = author$project$Main$framerate;
var elm$core$Basics$EQ = 1;
var elm$core$Basics$GT = 2;
var elm$core$Basics$LT = 0;
var elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var elm$core$List$cons = _List_cons;
var elm$core$Dict$toList = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var elm$core$Dict$keys = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var elm$core$Set$toList = function (_n0) {
	var dict = _n0;
	return elm$core$Dict$keys(dict);
};
var elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var elm$core$Array$foldr = F3(
	function (func, baseCase, _n0) {
		var tree = _n0.c;
		var tail = _n0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3(elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			elm$core$Elm$JsArray$foldr,
			helper,
			A3(elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var elm$core$Array$toList = function (array) {
	return A3(elm$core$Array$foldr, elm$core$List$cons, _List_Nil, array);
};
var elm$core$Basics$add = _Basics_add;
var elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var elm$core$Basics$mul = _Basics_mul;
var elm$random$Random$next = function (_n0) {
	var state0 = _n0.a;
	var incr = _n0.b;
	return A2(elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var elm$random$Random$initialSeed = function (x) {
	var _n0 = elm$random$Random$next(
		A2(elm$random$Random$Seed, 0, 1013904223));
	var state1 = _n0.a;
	var incr = _n0.b;
	var state2 = (state1 + x) >>> 0;
	return elm$random$Random$next(
		A2(elm$random$Random$Seed, state2, incr));
};
var author$project$Main$initialSeed = elm$random$Random$initialSeed(0);
var elm$core$Basics$fdiv = _Basics_fdiv;
var elm$core$Basics$pow = _Basics_pow;
var elm$core$Basics$sub = _Basics_sub;
var elm$core$Basics$toFloat = _Basics_toFloat;
var author$project$Main$makeInertTakerProportion = function (age) {
	return (A2(elm$core$Basics$pow, author$project$Main$inertTakerLongevity / 2, 2) - A2(elm$core$Basics$pow, age - (author$project$Main$inertTakerLongevity / 2), 2)) / 100;
};
var author$project$Main$numInertTaker = 10;
var elm$core$Basics$lt = _Utils_lt;
var elm$core$Basics$negate = function (n) {
	return -n;
};
var elm$core$Basics$abs = function (n) {
	return (n < 0) ? (-n) : n;
};
var elm$core$Basics$identity = function (x) {
	return x;
};
var elm$core$Bitwise$and = _Bitwise_and;
var elm$random$Random$Generator = elm$core$Basics$identity;
var elm$core$Bitwise$xor = _Bitwise_xor;
var elm$random$Random$peel = function (_n0) {
	var state = _n0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var elm$random$Random$float = F2(
	function (a, b) {
		return function (seed0) {
			var seed1 = elm$random$Random$next(seed0);
			var range = elm$core$Basics$abs(b - a);
			var n1 = elm$random$Random$peel(seed1);
			var n0 = elm$random$Random$peel(seed0);
			var lo = (134217727 & n1) * 1.0;
			var hi = (67108863 & n0) * 1.0;
			var val = ((hi * 1.34217728e8) + lo) / 9.007199254740992e15;
			var scaled = (val * range) + a;
			return _Utils_Tuple2(
				scaled,
				elm$random$Random$next(seed1));
		};
	});
var author$project$Main$randFloat = A2(elm$random$Random$float, 0, 1);
var elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var elm$core$Basics$round = _Basics_round;
var elm$core$Basics$gt = _Utils_gt;
var elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var elm$core$List$reverse = function (list) {
	return A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, list);
};
var elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							elm$core$List$foldl,
							fn,
							acc,
							elm$core$List$reverse(r4)) : A4(elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4(elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var elm$core$List$map3 = _List_map3;
var elm$core$Basics$le = _Utils_le;
var elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2(elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var elm$core$List$range = F2(
	function (lo, hi) {
		return A3(elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var elm$random$Random$listHelp = F4(
	function (revList, n, gen, seed) {
		listHelp:
		while (true) {
			if (n < 1) {
				return _Utils_Tuple2(revList, seed);
			} else {
				var _n0 = gen(seed);
				var value = _n0.a;
				var newSeed = _n0.b;
				var $temp$revList = A2(elm$core$List$cons, value, revList),
					$temp$n = n - 1,
					$temp$gen = gen,
					$temp$seed = newSeed;
				revList = $temp$revList;
				n = $temp$n;
				gen = $temp$gen;
				seed = $temp$seed;
				continue listHelp;
			}
		}
	});
var elm$random$Random$list = F2(
	function (n, _n0) {
		var gen = _n0;
		return function (seed) {
			return A4(elm$random$Random$listHelp, _List_Nil, n, gen, seed);
		};
	});
var elm$random$Random$step = F2(
	function (_n0, seed) {
		var generator = _n0;
		return generator(seed);
	});
var author$project$Main$inertTakerListInit = function () {
	var startFrames = A2(
		elm$core$List$map,
		function (x) {
			return elm$core$Basics$round(x / (author$project$Main$inertTakerLongevity / author$project$Main$numInertTaker));
		},
		A2(elm$core$List$range, 0 - author$project$Main$numInertTaker, 0));
	var proportions = A2(
		elm$core$List$map,
		function (x) {
			return author$project$Main$makeInertTakerProportion(0 - x);
		},
		startFrames);
	var _n0 = A2(
		elm$random$Random$step,
		A2(elm$random$Random$list, author$project$Main$numInertTaker, author$project$Main$randFloat),
		author$project$Main$initialSeed);
	var angleRadians = _n0.a;
	return A4(elm$core$List$map3, author$project$Main$InertTaker, startFrames, angleRadians, proportions);
}();
var author$project$Main$Lipase = function (positionRadians) {
	return {T: positionRadians};
};
var author$project$Main$numLipase = 48;
var elm$core$Basics$pi = _Basics_pi;
var author$project$Main$lipaseInit = A2(
	elm$core$List$map,
	author$project$Main$Lipase,
	A2(
		elm$core$List$map,
		function (x) {
			return x * ((2 * elm$core$Basics$pi) / author$project$Main$numLipase);
		},
		A2(elm$core$List$range, 0, author$project$Main$numLipase)));
var author$project$Main$circuitRadius = 200;
var author$project$Main$liverX = 0 - author$project$Main$circuitRadius;
var author$project$Main$liverY = 0;
var elm$core$Maybe$Nothing = {$: 1};
var author$project$Main$liverInit = {a: author$project$Main$liverX, b: author$project$Main$liverY, s: elm$core$Maybe$Nothing};
var elm$core$Basics$False = 1;
var elm$core$Basics$True = 0;
var elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var elm$core$Array$branchFactor = 32;
var elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var elm$core$Basics$ceiling = _Basics_ceiling;
var elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var elm$core$Array$shiftStep = elm$core$Basics$ceiling(
	A2(elm$core$Basics$logBase, 2, elm$core$Array$branchFactor));
var elm$core$Elm$JsArray$empty = _JsArray_empty;
var elm$core$Array$empty = A4(elm$core$Array$Array_elm_builtin, 0, elm$core$Array$shiftStep, elm$core$Elm$JsArray$empty, elm$core$Elm$JsArray$empty);
var elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodes);
			var node = _n0.a;
			var remainingNodes = _n0.b;
			var newAcc = A2(
				elm$core$List$cons,
				elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var elm$core$Basics$eq = _Utils_equal;
var elm$core$Tuple$first = function (_n0) {
	var x = _n0.a;
	return x;
};
var elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = elm$core$Basics$ceiling(nodeListSize / elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2(elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var elm$core$Basics$floor = _Basics_floor;
var elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var elm$core$Elm$JsArray$length = _JsArray_length;
var elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.e) {
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.f),
				elm$core$Array$shiftStep,
				elm$core$Elm$JsArray$empty,
				builder.f);
		} else {
			var treeLen = builder.e * elm$core$Array$branchFactor;
			var depth = elm$core$Basics$floor(
				A2(elm$core$Basics$logBase, elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? elm$core$List$reverse(builder.g) : builder.g;
			var tree = A2(elm$core$Array$treeFromBuilder, correctNodeList, builder.e);
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.f) + treeLen,
				A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep),
				tree,
				builder.f);
		}
	});
var elm$core$Basics$idiv = _Basics_idiv;
var elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					elm$core$Array$builderToArray,
					false,
					{g: nodeList, e: (len / elm$core$Array$branchFactor) | 0, f: tail});
			} else {
				var leaf = elm$core$Array$Leaf(
					A3(elm$core$Elm$JsArray$initialize, elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2(elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var elm$core$Basics$remainderBy = _Basics_remainderBy;
var elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return elm$core$Array$empty;
		} else {
			var tailLen = len % elm$core$Array$branchFactor;
			var tail = A3(elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - elm$core$Array$branchFactor;
			return A5(elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var elm$core$Basics$and = _Basics_and;
var elm$core$Basics$append = _Utils_append;
var elm$core$Basics$or = _Basics_or;
var elm$core$Char$toCode = _Char_toCode;
var elm$core$Char$isLower = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var elm$core$Char$isUpper = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var elm$core$Char$isAlpha = function (_char) {
	return elm$core$Char$isLower(_char) || elm$core$Char$isUpper(_char);
};
var elm$core$Char$isDigit = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var elm$core$Char$isAlphaNum = function (_char) {
	return elm$core$Char$isLower(_char) || (elm$core$Char$isUpper(_char) || elm$core$Char$isDigit(_char));
};
var elm$core$List$length = function (xs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var elm$core$List$map2 = _List_map2;
var elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$map2,
			f,
			A2(
				elm$core$List$range,
				0,
				elm$core$List$length(xs) - 1),
			xs);
	});
var elm$core$String$all = _String_all;
var elm$core$String$fromInt = _String_fromNumber;
var elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var elm$core$String$uncons = _String_uncons;
var elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var elm$json$Json$Decode$indent = function (str) {
	return A2(
		elm$core$String$join,
		'\n    ',
		A2(elm$core$String$split, '\n', str));
};
var elm$json$Json$Encode$encode = _Json_encode;
var elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + (elm$core$String$fromInt(i + 1) + (') ' + elm$json$Json$Decode$indent(
			elm$json$Json$Decode$errorToString(error))));
	});
var elm$json$Json$Decode$errorToString = function (error) {
	return A2(elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 0:
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _n1 = elm$core$String$uncons(f);
						if (_n1.$ === 1) {
							return false;
						} else {
							var _n2 = _n1.a;
							var _char = _n2.a;
							var rest = _n2.b;
							return elm$core$Char$isAlpha(_char) && A2(elm$core$String$all, elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 1:
					var i = error.a;
					var err = error.b;
					var indexName = '[' + (elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 2:
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									elm$core$String$join,
									'',
									elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										elm$core$String$join,
										'',
										elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + (elm$core$String$fromInt(
								elm$core$List$length(errors)) + ' ways:'));
							return A2(
								elm$core$String$join,
								'\n\n',
								A2(
									elm$core$List$cons,
									introduction,
									A2(elm$core$List$indexedMap, elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								elm$core$String$join,
								'',
								elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + (elm$json$Json$Decode$indent(
						A2(elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var elm$core$Platform$Cmd$batch = _Platform_batch;
var elm$core$Platform$Cmd$none = elm$core$Platform$Cmd$batch(_List_Nil);
var author$project$Main$init = _Utils_Tuple2(
	{t: author$project$Main$baseSpeed, F: _List_Nil, ar: elm$core$Maybe$Nothing, x: 0, ac: author$project$Main$inertTakerListInit, I: _List_Nil, ad: elm$core$Maybe$Nothing, af: author$project$Main$lipaseInit, ag: author$project$Main$liverInit, L: 0, M: 1, r: 0},
	elm$core$Platform$Cmd$none);
var author$project$Main$TickFrame = function (a) {
	return {$: 1, a: a};
};
var elm$browser$Browser$AnimationManager$Time = function (a) {
	return {$: 0, a: a};
};
var elm$browser$Browser$AnimationManager$State = F3(
	function (subs, request, oldTime) {
		return {aE: oldTime, bb: request, bg: subs};
	});
var elm$core$Task$succeed = _Scheduler_succeed;
var elm$browser$Browser$AnimationManager$init = elm$core$Task$succeed(
	A3(elm$browser$Browser$AnimationManager$State, _List_Nil, elm$core$Maybe$Nothing, 0));
var elm$browser$Browser$External = function (a) {
	return {$: 1, a: a};
};
var elm$browser$Browser$Internal = function (a) {
	return {$: 0, a: a};
};
var elm$browser$Browser$Dom$NotFound = elm$core$Basics$identity;
var elm$core$Basics$never = function (_n0) {
	never:
	while (true) {
		var nvr = _n0;
		var $temp$_n0 = nvr;
		_n0 = $temp$_n0;
		continue never;
	}
};
var elm$core$Task$Perform = elm$core$Basics$identity;
var elm$core$Task$init = elm$core$Task$succeed(0);
var elm$core$Task$andThen = _Scheduler_andThen;
var elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return A2(
					elm$core$Task$andThen,
					function (b) {
						return elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var elm$core$Task$sequence = function (tasks) {
	return A3(
		elm$core$List$foldr,
		elm$core$Task$map2(elm$core$List$cons),
		elm$core$Task$succeed(_List_Nil),
		tasks);
};
var elm$core$Platform$sendToApp = _Platform_sendToApp;
var elm$core$Task$spawnCmd = F2(
	function (router, _n0) {
		var task = _n0;
		return _Scheduler_spawn(
			A2(
				elm$core$Task$andThen,
				elm$core$Platform$sendToApp(router),
				task));
	});
var elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			elm$core$Task$map,
			function (_n0) {
				return 0;
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Task$spawnCmd(router),
					commands)));
	});
var elm$core$Task$onSelfMsg = F3(
	function (_n0, _n1, _n2) {
		return elm$core$Task$succeed(0);
	});
var elm$core$Task$cmdMap = F2(
	function (tagger, _n0) {
		var task = _n0;
		return A2(elm$core$Task$map, tagger, task);
	});
_Platform_effectManagers['Task'] = _Platform_createManager(elm$core$Task$init, elm$core$Task$onEffects, elm$core$Task$onSelfMsg, elm$core$Task$cmdMap);
var elm$core$Task$command = _Platform_leaf('Task');
var elm$core$Task$perform = F2(
	function (toMessage, task) {
		return elm$core$Task$command(
			A2(elm$core$Task$map, toMessage, task));
	});
var elm$json$Json$Decode$map = _Json_map1;
var elm$json$Json$Decode$map2 = _Json_map2;
var elm$json$Json$Decode$succeed = _Json_succeed;
var elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		default:
			return 3;
	}
};
var elm$core$String$length = _String_length;
var elm$core$String$slice = _String_slice;
var elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			elm$core$String$slice,
			n,
			elm$core$String$length(string),
			string);
	});
var elm$core$String$startsWith = _String_startsWith;
var elm$url$Url$Http = 0;
var elm$url$Url$Https = 1;
var elm$core$String$indexes = _String_indexes;
var elm$core$String$isEmpty = function (string) {
	return string === '';
};
var elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(elm$core$String$slice, 0, n, string);
	});
var elm$core$String$contains = _String_contains;
var elm$core$String$toInt = _String_toInt;
var elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {aT: fragment, aW: host, a1: path, a4: port_, a8: protocol, a9: query};
	});
var elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if (elm$core$String$isEmpty(str) || A2(elm$core$String$contains, '@', str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, ':', str);
			if (!_n0.b) {
				return elm$core$Maybe$Just(
					A6(elm$url$Url$Url, protocol, str, elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_n0.b.b) {
					var i = _n0.a;
					var _n1 = elm$core$String$toInt(
						A2(elm$core$String$dropLeft, i + 1, str));
					if (_n1.$ === 1) {
						return elm$core$Maybe$Nothing;
					} else {
						var port_ = _n1;
						return elm$core$Maybe$Just(
							A6(
								elm$url$Url$Url,
								protocol,
								A2(elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return elm$core$Maybe$Nothing;
				}
			}
		}
	});
var elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '/', str);
			if (!_n0.b) {
				return A5(elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _n0.a;
				return A5(
					elm$url$Url$chompBeforePath,
					protocol,
					A2(elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '?', str);
			if (!_n0.b) {
				return A4(elm$url$Url$chompBeforeQuery, protocol, elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _n0.a;
				return A4(
					elm$url$Url$chompBeforeQuery,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '#', str);
			if (!_n0.b) {
				return A3(elm$url$Url$chompBeforeFragment, protocol, elm$core$Maybe$Nothing, str);
			} else {
				var i = _n0.a;
				return A3(
					elm$url$Url$chompBeforeFragment,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$fromString = function (str) {
	return A2(elm$core$String$startsWith, 'http://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		0,
		A2(elm$core$String$dropLeft, 7, str)) : (A2(elm$core$String$startsWith, 'https://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		1,
		A2(elm$core$String$dropLeft, 8, str)) : elm$core$Maybe$Nothing);
};
var elm$browser$Browser$AnimationManager$now = _Browser_now(0);
var elm$browser$Browser$AnimationManager$rAF = _Browser_rAF(0);
var elm$core$Platform$sendToSelf = _Platform_sendToSelf;
var elm$core$Process$kill = _Scheduler_kill;
var elm$core$Process$spawn = _Scheduler_spawn;
var elm$browser$Browser$AnimationManager$onEffects = F3(
	function (router, subs, _n0) {
		var request = _n0.bb;
		var oldTime = _n0.aE;
		var _n1 = _Utils_Tuple2(request, subs);
		if (_n1.a.$ === 1) {
			if (!_n1.b.b) {
				var _n2 = _n1.a;
				return elm$browser$Browser$AnimationManager$init;
			} else {
				var _n4 = _n1.a;
				return A2(
					elm$core$Task$andThen,
					function (pid) {
						return A2(
							elm$core$Task$andThen,
							function (time) {
								return elm$core$Task$succeed(
									A3(
										elm$browser$Browser$AnimationManager$State,
										subs,
										elm$core$Maybe$Just(pid),
										time));
							},
							elm$browser$Browser$AnimationManager$now);
					},
					elm$core$Process$spawn(
						A2(
							elm$core$Task$andThen,
							elm$core$Platform$sendToSelf(router),
							elm$browser$Browser$AnimationManager$rAF)));
			}
		} else {
			if (!_n1.b.b) {
				var pid = _n1.a.a;
				return A2(
					elm$core$Task$andThen,
					function (_n3) {
						return elm$browser$Browser$AnimationManager$init;
					},
					elm$core$Process$kill(pid));
			} else {
				return elm$core$Task$succeed(
					A3(elm$browser$Browser$AnimationManager$State, subs, request, oldTime));
			}
		}
	});
var elm$time$Time$Posix = elm$core$Basics$identity;
var elm$time$Time$millisToPosix = elm$core$Basics$identity;
var elm$browser$Browser$AnimationManager$onSelfMsg = F3(
	function (router, newTime, _n0) {
		var subs = _n0.bg;
		var oldTime = _n0.aE;
		var send = function (sub) {
			if (!sub.$) {
				var tagger = sub.a;
				return A2(
					elm$core$Platform$sendToApp,
					router,
					tagger(
						elm$time$Time$millisToPosix(newTime)));
			} else {
				var tagger = sub.a;
				return A2(
					elm$core$Platform$sendToApp,
					router,
					tagger(newTime - oldTime));
			}
		};
		return A2(
			elm$core$Task$andThen,
			function (pid) {
				return A2(
					elm$core$Task$andThen,
					function (_n1) {
						return elm$core$Task$succeed(
							A3(
								elm$browser$Browser$AnimationManager$State,
								subs,
								elm$core$Maybe$Just(pid),
								newTime));
					},
					elm$core$Task$sequence(
						A2(elm$core$List$map, send, subs)));
			},
			elm$core$Process$spawn(
				A2(
					elm$core$Task$andThen,
					elm$core$Platform$sendToSelf(router),
					elm$browser$Browser$AnimationManager$rAF)));
	});
var elm$browser$Browser$AnimationManager$Delta = function (a) {
	return {$: 1, a: a};
};
var elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var elm$browser$Browser$AnimationManager$subMap = F2(
	function (func, sub) {
		if (!sub.$) {
			var tagger = sub.a;
			return elm$browser$Browser$AnimationManager$Time(
				A2(elm$core$Basics$composeL, func, tagger));
		} else {
			var tagger = sub.a;
			return elm$browser$Browser$AnimationManager$Delta(
				A2(elm$core$Basics$composeL, func, tagger));
		}
	});
_Platform_effectManagers['Browser.AnimationManager'] = _Platform_createManager(elm$browser$Browser$AnimationManager$init, elm$browser$Browser$AnimationManager$onEffects, elm$browser$Browser$AnimationManager$onSelfMsg, 0, elm$browser$Browser$AnimationManager$subMap);
var elm$browser$Browser$AnimationManager$subscription = _Platform_leaf('Browser.AnimationManager');
var elm$browser$Browser$AnimationManager$onAnimationFrame = function (tagger) {
	return elm$browser$Browser$AnimationManager$subscription(
		elm$browser$Browser$AnimationManager$Time(tagger));
};
var elm$browser$Browser$Events$onAnimationFrame = elm$browser$Browser$AnimationManager$onAnimationFrame;
var elm$core$Platform$Sub$batch = _Platform_batch;
var elm$core$Platform$Sub$none = elm$core$Platform$Sub$batch(_List_Nil);
var author$project$Main$subscriptions = function (model) {
	var _n0 = model.M;
	if (!_n0) {
		return elm$browser$Browser$Events$onAnimationFrame(author$project$Main$TickFrame);
	} else {
		return elm$core$Platform$Sub$none;
	}
};
var author$project$Main$GotRandomFloat = function (a) {
	return {$: 6, a: a};
};
var author$project$Main$Pathological = 1;
var author$project$Main$Running = 0;
var author$project$Main$cMicronLongevity = 20;
var author$project$Main$maxCMicronSize = 16;
var author$project$Main$cMicronSizeModifier = author$project$Main$cMicronLongevity / author$project$Main$maxCMicronSize;
var author$project$Main$cMicronInit = function (startFrame) {
	return {a: 400, b: 200, s: elm$core$Maybe$Nothing, d: startFrame, c: author$project$Main$cMicronLongevity / author$project$Main$cMicronSizeModifier};
};
var author$project$Main$lProteinAppearDelay = 0;
var author$project$Main$secondsPerCircuit = 16;
var author$project$Main$degreesPerFrame = 360 / (author$project$Main$secondsPerCircuit * author$project$Main$framerate);
var elm$core$Basics$degrees = function (angleInDegrees) {
	return (angleInDegrees * elm$core$Basics$pi) / 180;
};
var author$project$Main$baseRadiansPerFrame = elm$core$Basics$degrees(author$project$Main$degreesPerFrame);
var author$project$Main$lProteinRadiansPerFrame = author$project$Main$baseRadiansPerFrame;
var author$project$Main$maxLProteinSize = 12;
var author$project$Main$lProteinInit = function (startFrame) {
	return {a: author$project$Main$liverX, b: author$project$Main$liverY, s: elm$core$Maybe$Nothing, ak: author$project$Main$lProteinRadiansPerFrame, d: startFrame, c: author$project$Main$maxLProteinSize};
};
var author$project$Main$lProteinMaxTime = 60;
var author$project$Main$ldlThreshold = 5;
var author$project$Main$lipaseRadiansPerFrame = author$project$Main$baseRadiansPerFrame;
var author$project$Main$Pulse = F3(
	function (startFrame, currentRadius, color) {
		return {bs: color, P: currentRadius, d: startFrame};
	});
var avh4$elm_color$Color$RgbaSpace = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var avh4$elm_color$Color$lightGrey = A4(avh4$elm_color$Color$RgbaSpace, 238 / 255, 238 / 255, 236 / 255, 1.0);
var author$project$Main$cMicronPulseColor = avh4$elm_color$Color$lightGrey;
var author$project$Main$cMicronRadiansPerFrame = author$project$Main$baseRadiansPerFrame;
var author$project$Main$cMicronReductionRate = 1 / author$project$Main$cMicronSizeModifier;
var author$project$Main$inCircuit = F2(
	function (x, y) {
		return ((_Utils_cmp(
			A2(elm$core$Basics$pow, x, 2) + A2(elm$core$Basics$pow, y, 2),
			A2(elm$core$Basics$pow, author$project$Main$circuitRadius - 5.0e-3, 2)) > 0) && (_Utils_cmp(
			A2(elm$core$Basics$pow, x, 2) + A2(elm$core$Basics$pow, y, 2),
			A2(elm$core$Basics$pow, author$project$Main$circuitRadius + 5.0e-3, 2)) < 0)) ? true : false;
	});
var elm$core$Basics$acos = _Basics_acos;
var elm$core$Basics$cos = _Basics_cos;
var elm$core$Basics$sin = _Basics_sin;
var author$project$Main$makeNextXY = F2(
	function (_n0, radiansPerFrame) {
		var prevX = _n0.a;
		var prevY = _n0.b;
		var currentAngle = function () {
			var baseAngle = elm$core$Basics$acos(prevX / author$project$Main$circuitRadius);
			var _n2 = _Utils_Tuple2(prevX < 0, prevY < 0);
			_n2$2:
			while (true) {
				if (_n2.a) {
					if (_n2.b) {
						return elm$core$Basics$pi + (elm$core$Basics$pi - baseAngle);
					} else {
						break _n2$2;
					}
				} else {
					if (_n2.b) {
						return (2 * elm$core$Basics$pi) - baseAngle;
					} else {
						break _n2$2;
					}
				}
			}
			return baseAngle;
		}();
		var nextAngle = currentAngle + radiansPerFrame;
		var baseY = author$project$Main$circuitRadius * elm$core$Basics$sin(nextAngle);
		var baseX = author$project$Main$circuitRadius * elm$core$Basics$cos(nextAngle);
		var _n1 = _Utils_Tuple2(baseX, baseY);
		var cx = _n1.a;
		var cy = _n1.b;
		return _Utils_Tuple2(cx, cy);
	});
var author$project$Main$pxPerFrame = ((2 * elm$core$Basics$pi) * author$project$Main$circuitRadius) / (author$project$Main$secondsPerCircuit * author$project$Main$framerate);
var author$project$Main$trackHalfWidth = 32;
var elm$core$Basics$modBy = _Basics_modBy;
var elm_community$easing_functions$Ease$flip = F2(
	function (easing, time) {
		return 1 - easing(1 - time);
	});
var elm_community$easing_functions$Ease$inExpo = function (time) {
	return (time === 0.0) ? 0.0 : A2(elm$core$Basics$pow, 2, 10 * (time - 1));
};
var elm_community$easing_functions$Ease$outExpo = elm_community$easing_functions$Ease$flip(elm_community$easing_functions$Ease$inExpo);
var author$project$Main$makeNextCMicron = F2(
	function (f, data) {
		var currentlyInCircuit = A2(author$project$Main$inCircuit, data.a, data.b);
		var pulse = function () {
			var _n2 = _Utils_Tuple2(currentlyInCircuit, data.s);
			if (_n2.a) {
				if (!_n2.b.$) {
					var pulseData = _n2.b.a;
					return (_Utils_cmp(pulseData.P, author$project$Main$trackHalfWidth - 1.0e-2) > 0) ? elm$core$Maybe$Nothing : elm$core$Maybe$Just(
						_Utils_update(
							pulseData,
							{
								P: author$project$Main$trackHalfWidth * elm_community$easing_functions$Ease$outExpo((f - pulseData.d) / author$project$Main$framerate)
							}));
				} else {
					var _n3 = _n2.b;
					var _n4 = A2(elm$core$Basics$modBy, author$project$Main$framerate, f);
					if (!_n4) {
						return elm$core$Maybe$Just(
							A3(author$project$Main$Pulse, f, data.c, author$project$Main$cMicronPulseColor));
					} else {
						return elm$core$Maybe$Nothing;
					}
				}
			} else {
				return elm$core$Maybe$Nothing;
			}
		}();
		var triglycerideSize = function () {
			var _n1 = _Utils_Tuple2(
				currentlyInCircuit,
				A2(elm$core$Basics$modBy, author$project$Main$framerate, f));
			if (_n1.a && (!_n1.b)) {
				return data.c - author$project$Main$cMicronReductionRate;
			} else {
				return data.c;
			}
		}();
		var _n0 = currentlyInCircuit ? A2(
			author$project$Main$makeNextXY,
			_Utils_Tuple2(data.a, data.b),
			author$project$Main$cMicronRadiansPerFrame) : _Utils_Tuple2(data.a - author$project$Main$pxPerFrame, data.b);
		var nextCx = _n0.a;
		var nextCy = _n0.b;
		return _Utils_update(
			data,
			{a: nextCx, b: nextCy, s: pulse, c: triglycerideSize});
	});
var author$project$Main$halfFramerate = (author$project$Main$framerate / 2) | 0;
var author$project$Main$lProteinLongevity = 1 * author$project$Main$secondsPerCircuit;
var author$project$Main$lProteinPulseColor = avh4$elm_color$Color$lightGrey;
var author$project$Main$lProteinSizeModifier = author$project$Main$lProteinLongevity / ((author$project$Main$maxLProteinSize - author$project$Main$ldlThreshold) + 0.47);
var author$project$Main$lProteinReductionRate = 1 / author$project$Main$lProteinSizeModifier;
var elm$core$Basics$ge = _Utils_ge;
var author$project$Main$makeNextLProtein = F3(
	function (f, state, data) {
		var triglycerideSize = function () {
			if (!state) {
				return _Utils_eq(
					A2(elm$core$Basics$modBy, author$project$Main$framerate, f),
					author$project$Main$halfFramerate) ? (data.c - author$project$Main$lProteinReductionRate) : data.c;
			} else {
				return (_Utils_cmp(f - data.d, author$project$Main$lProteinLongevity * author$project$Main$framerate) > -1) ? data.c : (_Utils_eq(
					A2(elm$core$Basics$modBy, author$project$Main$framerate, f),
					author$project$Main$halfFramerate) ? (data.c - author$project$Main$lProteinReductionRate) : data.c);
			}
		}();
		var pulse = function () {
			var _n2 = _Utils_Tuple2(state, data.s);
			if (!_n2.b.$) {
				var pulseData = _n2.b.a;
				return (_Utils_cmp(pulseData.P, author$project$Main$trackHalfWidth - 1.0e-2) > 0) ? elm$core$Maybe$Nothing : elm$core$Maybe$Just(
					_Utils_update(
						pulseData,
						{
							P: author$project$Main$trackHalfWidth * elm_community$easing_functions$Ease$outExpo((f - pulseData.d) / author$project$Main$framerate)
						}));
			} else {
				if (!_n2.a) {
					var _n3 = _n2.a;
					var _n4 = _n2.b;
					return _Utils_eq(
						A2(elm$core$Basics$modBy, author$project$Main$framerate, f),
						author$project$Main$halfFramerate) ? elm$core$Maybe$Just(
						A3(author$project$Main$Pulse, f, data.c, author$project$Main$lProteinPulseColor)) : elm$core$Maybe$Nothing;
				} else {
					var _n5 = _n2.a;
					var _n6 = _n2.b;
					return (_Utils_eq(
						A2(elm$core$Basics$modBy, author$project$Main$framerate, f),
						author$project$Main$halfFramerate) && (_Utils_cmp(f - data.d, author$project$Main$lProteinLongevity * author$project$Main$framerate) < 1)) ? elm$core$Maybe$Just(
						A3(author$project$Main$Pulse, f, data.c, author$project$Main$lProteinPulseColor)) : elm$core$Maybe$Nothing;
				}
			}
		}();
		var _n0 = function () {
			if (!state) {
				return A2(
					author$project$Main$makeNextXY,
					_Utils_Tuple2(data.a, data.b),
					data.ak);
			} else {
				var radiansModifier = ((author$project$Main$lProteinMaxTime * author$project$Main$framerate) - (f - data.d)) / (author$project$Main$lProteinMaxTime * author$project$Main$framerate);
				return (_Utils_cmp(f - data.d, author$project$Main$lProteinLongevity * author$project$Main$framerate) > -1) ? A2(
					author$project$Main$makeNextXY,
					_Utils_Tuple2(data.a, data.b),
					data.ak * radiansModifier) : A2(
					author$project$Main$makeNextXY,
					_Utils_Tuple2(data.a, data.b),
					data.ak);
			}
		}();
		var nextCx = _n0.a;
		var nextCy = _n0.b;
		return _Utils_update(
			data,
			{a: nextCx, b: nextCy, s: pulse, c: triglycerideSize});
	});
var author$project$Main$Taker = F4(
	function (startFrame, takeX, takeY, proportion) {
		return {z: proportion, d: startFrame, bi: takeX, bj: takeY};
	});
var author$project$Main$takerDuration = author$project$Main$framerate;
var elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2(elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var elm$core$Basics$sqrt = _Basics_sqrt;
var elm_community$easing_functions$Ease$outCirc = function (time) {
	return elm$core$Basics$sqrt(
		1 - A2(elm$core$Basics$pow, time - 1, 2));
};
var author$project$Main$makeTaker = F3(
	function (frame, prevTakers, removalList) {
		var filtered = function () {
			if (!prevTakers.$) {
				var takers = prevTakers.a;
				return A2(
					elm$core$List$filter,
					function (t) {
						return t.z > 0;
					},
					takers);
			} else {
				return _List_Nil;
			}
		}();
		var proportioned = A2(
			elm$core$List$map,
			function (t) {
				return _Utils_update(
					t,
					{
						z: elm_community$easing_functions$Ease$outCirc(1 - ((frame - t.d) / author$project$Main$takerDuration))
					});
			},
			filtered);
		var _n0 = _Utils_Tuple2(prevTakers, removalList);
		if (!_n0.a.$) {
			if (!_n0.b.b) {
				var takers = _n0.a.a;
				return elm$core$Maybe$Just(proportioned);
			} else {
				var takers = _n0.a.a;
				var rs = _n0.b;
				return elm$core$Maybe$Just(
					_Utils_ap(
						proportioned,
						A2(
							elm$core$List$map,
							function (r) {
								return A4(author$project$Main$Taker, frame, r.a, r.b, 1.0);
							},
							rs)));
			}
		} else {
			if (!_n0.b.b) {
				var _n1 = _n0.a;
				return elm$core$Maybe$Nothing;
			} else {
				var _n2 = _n0.a;
				var rs = _n0.b;
				return elm$core$Maybe$Just(
					A2(
						elm$core$List$map,
						function (r) {
							return A4(author$project$Main$Taker, frame, r.a, r.b, 1.0);
						},
						rs));
			}
		}
	});
var author$project$Main$updateFrame = F2(
	function (frame, model) {
		var nextLProteinList = function () {
			var phase = A2(
				elm$core$Basics$modBy,
				elm$core$Basics$round((author$project$Main$framerate * 6) / 5),
				frame);
			return (_Utils_eq(phase, author$project$Main$framerate) && (_Utils_cmp(frame, author$project$Main$lProteinAppearDelay * author$project$Main$framerate) > 0)) ? A2(
				elm$core$List$cons,
				author$project$Main$lProteinInit(frame),
				A2(
					elm$core$List$map,
					A2(author$project$Main$makeNextLProtein, frame, model.r),
					model.I)) : A2(
				elm$core$List$map,
				A2(author$project$Main$makeNextLProtein, frame, model.r),
				model.I);
		}();
		var nextValidLProteinList = function () {
			var _n4 = model.r;
			if (!_n4) {
				return A2(
					elm$core$List$filter,
					function (lp) {
						return _Utils_cmp(lp.c, author$project$Main$ldlThreshold) > 0;
					},
					nextLProteinList);
			} else {
				return A2(
					elm$core$List$filter,
					function (lp) {
						return _Utils_cmp(frame - lp.d, author$project$Main$framerate * author$project$Main$lProteinMaxTime) < 1;
					},
					nextLProteinList);
			}
		}();
		var removeLProtein = function () {
			var _n3 = model.r;
			if (!_n3) {
				return A2(
					elm$core$List$filter,
					function (lp) {
						return _Utils_cmp(lp.c, author$project$Main$ldlThreshold) < 1;
					},
					nextLProteinList);
			} else {
				return _List_Nil;
			}
		}();
		var nextCMicronList = function () {
			var _n2 = A2(
				elm$core$Basics$modBy,
				elm$core$Basics$round((author$project$Main$framerate * 6) / 5),
				frame);
			if (!_n2) {
				return A2(
					elm$core$List$cons,
					author$project$Main$cMicronInit(frame),
					A2(
						elm$core$List$map,
						author$project$Main$makeNextCMicron(frame),
						model.F));
			} else {
				return A2(
					elm$core$List$map,
					author$project$Main$makeNextCMicron(frame),
					model.F);
			}
		}();
		var nextValidCMicronList = A2(
			elm$core$List$filter,
			function (cm) {
				return cm.c > 0;
			},
			nextCMicronList);
		var removeCMicron = A2(
			elm$core$List$filter,
			function (cm) {
				return cm.c <= 0;
			},
			nextCMicronList);
		var lipase = A2(
			elm$core$List$map,
			function (x) {
				return author$project$Main$Lipase(x.T - author$project$Main$lipaseRadiansPerFrame);
			},
			model.af);
		var lProteinTakerList = function () {
			var _n1 = model.r;
			if (!_n1) {
				return A3(author$project$Main$makeTaker, frame, model.ad, removeLProtein);
			} else {
				return elm$core$Maybe$Nothing;
			}
		}();
		var inertTakerList = function () {
			var modified = A2(
				elm$core$List$map,
				function (x) {
					return _Utils_update(
						x,
						{
							z: author$project$Main$makeInertTakerProportion(frame - x.d)
						});
				},
				model.ac);
			var additional = function () {
				var _n0 = A2(elm$core$Basics$modBy, (author$project$Main$framerate / author$project$Main$numInertTaker) | 0, frame);
				if (!_n0) {
					return _List_fromArray(
						[
							A3(author$project$Main$InertTaker, frame, (2 * elm$core$Basics$pi) * model.L, 0)
						]);
				} else {
					return _List_Nil;
				}
			}();
			return _Utils_ap(
				additional,
				A2(
					elm$core$List$filter,
					function (x) {
						return _Utils_cmp(frame - x.d, author$project$Main$inertTakerLongevity) < 1;
					},
					modified));
		}();
		var cMicronTakerList = A3(author$project$Main$makeTaker, frame, model.ar, removeCMicron);
		return _Utils_update(
			model,
			{F: nextValidCMicronList, ar: cMicronTakerList, x: model.x + 1, ac: inertTakerList, I: nextValidLProteinList, ad: lProteinTakerList, af: lipase, ag: model.ag});
	});
var elm$random$Random$Generate = elm$core$Basics$identity;
var elm$time$Time$Name = function (a) {
	return {$: 0, a: a};
};
var elm$time$Time$Offset = function (a) {
	return {$: 1, a: a};
};
var elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var elm$time$Time$customZone = elm$time$Time$Zone;
var elm$time$Time$now = _Time_now(elm$time$Time$millisToPosix);
var elm$time$Time$posixToMillis = function (_n0) {
	var millis = _n0;
	return millis;
};
var elm$random$Random$init = A2(
	elm$core$Task$andThen,
	function (time) {
		return elm$core$Task$succeed(
			elm$random$Random$initialSeed(
				elm$time$Time$posixToMillis(time)));
	},
	elm$time$Time$now);
var elm$random$Random$onEffects = F3(
	function (router, commands, seed) {
		if (!commands.b) {
			return elm$core$Task$succeed(seed);
		} else {
			var generator = commands.a;
			var rest = commands.b;
			var _n1 = A2(elm$random$Random$step, generator, seed);
			var value = _n1.a;
			var newSeed = _n1.b;
			return A2(
				elm$core$Task$andThen,
				function (_n2) {
					return A3(elm$random$Random$onEffects, router, rest, newSeed);
				},
				A2(elm$core$Platform$sendToApp, router, value));
		}
	});
var elm$random$Random$onSelfMsg = F3(
	function (_n0, _n1, seed) {
		return elm$core$Task$succeed(seed);
	});
var elm$random$Random$map = F2(
	function (func, _n0) {
		var genA = _n0;
		return function (seed0) {
			var _n1 = genA(seed0);
			var a = _n1.a;
			var seed1 = _n1.b;
			return _Utils_Tuple2(
				func(a),
				seed1);
		};
	});
var elm$random$Random$cmdMap = F2(
	function (func, _n0) {
		var generator = _n0;
		return A2(elm$random$Random$map, func, generator);
	});
_Platform_effectManagers['Random'] = _Platform_createManager(elm$random$Random$init, elm$random$Random$onEffects, elm$random$Random$onSelfMsg, elm$random$Random$cmdMap);
var elm$random$Random$command = _Platform_leaf('Random');
var elm$random$Random$generate = F2(
	function (tagger, generator) {
		return elm$random$Random$command(
			A2(elm$random$Random$map, tagger, generator));
	});
var author$project$Main$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 1:
				return _Utils_Tuple2(
					A2(author$project$Main$updateFrame, model.x, model),
					A2(elm$random$Random$generate, author$project$Main$GotRandomFloat, author$project$Main$randFloat));
			case 2:
				var _n1 = model.r;
				if (!_n1) {
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{r: 1}),
						elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{r: 0}),
						elm$core$Platform$Cmd$none);
				}
			case 3:
				var _n2 = model.M;
				if (!_n2) {
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{M: 1}),
						elm$core$Platform$Cmd$none);
				} else {
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{M: 0}),
						elm$core$Platform$Cmd$none);
				}
			case 4:
				return (model.t < 2) ? _Utils_Tuple2(
					_Utils_update(
						model,
						{t: model.t * 2}),
					elm$core$Platform$Cmd$none) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
			case 5:
				return (model.t > 0.5) ? _Utils_Tuple2(
					_Utils_update(
						model,
						{t: model.t / 2}),
					elm$core$Platform$Cmd$none) : _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
			case 6:
				var _float = msg.a;
				return _Utils_Tuple2(
					_Utils_update(
						model,
						{L: _float}),
					elm$core$Platform$Cmd$none);
			default:
				return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
		}
	});
var author$project$Main$ToggleRunState = {$: 3};
var author$project$Main$ToggleState = {$: 2};
var avh4$elm_color$Color$darkGray = A4(avh4$elm_color$Color$RgbaSpace, 186 / 255, 189 / 255, 182 / 255, 1.0);
var avh4$elm_color$Color$hsla = F4(
	function (hue, sat, light, alpha) {
		var _n0 = _Utils_Tuple3(hue, sat, light);
		var h = _n0.a;
		var s = _n0.b;
		var l = _n0.c;
		var m2 = (l <= 0.5) ? (l * (s + 1)) : ((l + s) - (l * s));
		var m1 = (l * 2) - m2;
		var hueToRgb = function (h__) {
			var h_ = (h__ < 0) ? (h__ + 1) : ((h__ > 1) ? (h__ - 1) : h__);
			return ((h_ * 6) < 1) ? (m1 + (((m2 - m1) * h_) * 6)) : (((h_ * 2) < 1) ? m2 : (((h_ * 3) < 2) ? (m1 + (((m2 - m1) * ((2 / 3) - h_)) * 6)) : m1));
		};
		var b = hueToRgb(h - (1 / 3));
		var g = hueToRgb(h);
		var r = hueToRgb(h + (1 / 3));
		return A4(avh4$elm_color$Color$RgbaSpace, r, g, b, alpha);
	});
var elm_community$easing_functions$Ease$inOut = F3(
	function (e1, e2, time) {
		return (time < 0.5) ? (e1(time * 2) / 2) : (0.5 + (e2((time - 0.5) * 2) / 2));
	});
var elm_community$easing_functions$Ease$outSine = function (time) {
	return elm$core$Basics$sin(time * (elm$core$Basics$pi / 2));
};
var elm_community$easing_functions$Ease$inSine = elm_community$easing_functions$Ease$flip(elm_community$easing_functions$Ease$outSine);
var elm_community$easing_functions$Ease$inOutSine = A2(elm_community$easing_functions$Ease$inOut, elm_community$easing_functions$Ease$inSine, elm_community$easing_functions$Ease$outSine);
var joakin$elm_canvas$Canvas$Circle = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var joakin$elm_canvas$Canvas$circle = F2(
	function (pos, radius) {
		return A2(joakin$elm_canvas$Canvas$Circle, pos, radius);
	});
var joakin$elm_canvas$Canvas$Fill = function (a) {
	return {$: 1, a: a};
};
var joakin$elm_canvas$Canvas$SettingDrawOp = function (a) {
	return {$: 2, a: a};
};
var joakin$elm_canvas$Canvas$fill = function (color) {
	return joakin$elm_canvas$Canvas$SettingDrawOp(
		joakin$elm_canvas$Canvas$Fill(color));
};
var joakin$elm_canvas$Canvas$Rotate = function (a) {
	return {$: 0, a: a};
};
var joakin$elm_canvas$Canvas$rotate = joakin$elm_canvas$Canvas$Rotate;
var joakin$elm_canvas$Canvas$Scale = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var joakin$elm_canvas$Canvas$scale = joakin$elm_canvas$Canvas$Scale;
var joakin$elm_canvas$Canvas$DrawableShapes = function (a) {
	return {$: 1, a: a};
};
var joakin$elm_canvas$Canvas$NotSpecified = {$: 0};
var joakin$elm_canvas$Canvas$Renderable = elm$core$Basics$identity;
var joakin$elm_canvas$Canvas$FillAndStroke = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var joakin$elm_canvas$Canvas$Stroke = function (a) {
	return {$: 2, a: a};
};
var joakin$elm_canvas$Canvas$mergeDrawOp = F2(
	function (op1, op2) {
		var _n0 = _Utils_Tuple2(op1, op2);
		_n0$7:
		while (true) {
			switch (_n0.b.$) {
				case 3:
					var _n1 = _n0.b;
					var c = _n1.a;
					var sc = _n1.b;
					return A2(joakin$elm_canvas$Canvas$FillAndStroke, c, sc);
				case 1:
					switch (_n0.a.$) {
						case 1:
							var c = _n0.b.a;
							return joakin$elm_canvas$Canvas$Fill(c);
						case 2:
							var c1 = _n0.a.a;
							var c2 = _n0.b.a;
							return A2(joakin$elm_canvas$Canvas$FillAndStroke, c2, c1);
						case 3:
							var _n2 = _n0.a;
							var c = _n2.a;
							var sc = _n2.b;
							var c2 = _n0.b.a;
							return A2(joakin$elm_canvas$Canvas$FillAndStroke, c2, sc);
						default:
							break _n0$7;
					}
				case 2:
					switch (_n0.a.$) {
						case 2:
							var c = _n0.b.a;
							return joakin$elm_canvas$Canvas$Stroke(c);
						case 1:
							var c1 = _n0.a.a;
							var c2 = _n0.b.a;
							return A2(joakin$elm_canvas$Canvas$FillAndStroke, c1, c2);
						case 3:
							var _n3 = _n0.a;
							var c = _n3.a;
							var sc = _n3.b;
							var sc2 = _n0.b.a;
							return A2(joakin$elm_canvas$Canvas$FillAndStroke, c, sc2);
						default:
							break _n0$7;
					}
				default:
					if (!_n0.a.$) {
						break _n0$7;
					} else {
						var whatever = _n0.a;
						var _n5 = _n0.b;
						return whatever;
					}
			}
		}
		var _n4 = _n0.a;
		var whatever = _n0.b;
		return whatever;
	});
var joakin$elm_canvas$Canvas$addSettingsToRenderable = F2(
	function (settings, renderable) {
		var addSetting = F2(
			function (setting, _n1) {
				var r = _n1;
				switch (setting.$) {
					case 0:
						var cmd = setting.a;
						return _Utils_update(
							r,
							{
								G: A2(elm$core$List$cons, cmd, r.G)
							});
					case 1:
						var cmds = setting.a;
						return _Utils_update(
							r,
							{
								G: A3(elm$core$List$foldl, elm$core$List$cons, r.G, cmds)
							});
					case 3:
						var f = setting.a;
						return _Utils_update(
							r,
							{
								ab: f(r.ab)
							});
					default:
						var op = setting.a;
						return _Utils_update(
							r,
							{
								aa: A2(joakin$elm_canvas$Canvas$mergeDrawOp, r.aa, op)
							});
				}
			});
		return A3(elm$core$List$foldl, addSetting, renderable, settings);
	});
var joakin$elm_canvas$Canvas$shapes = F2(
	function (settings, ss) {
		return A2(
			joakin$elm_canvas$Canvas$addSettingsToRenderable,
			settings,
			{
				G: _List_Nil,
				aa: joakin$elm_canvas$Canvas$NotSpecified,
				ab: joakin$elm_canvas$Canvas$DrawableShapes(ss)
			});
	});
var joakin$elm_canvas$Canvas$stroke = function (color) {
	return joakin$elm_canvas$Canvas$SettingDrawOp(
		joakin$elm_canvas$Canvas$Stroke(color));
};
var joakin$elm_canvas$Canvas$SettingCommands = function (a) {
	return {$: 1, a: a};
};
var elm$json$Json$Encode$float = _Json_wrap;
var elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(0),
				entries));
	});
var elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			elm$core$List$foldl,
			F2(
				function (_n0, obj) {
					var k = _n0.a;
					var v = _n0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(0),
			pairs));
};
var elm$json$Json$Encode$string = _Json_wrap;
var joakin$elm_canvas$Canvas$Internal$fn = F2(
	function (name, args) {
		return elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'type',
					elm$json$Json$Encode$string('function')),
					_Utils_Tuple2(
					'name',
					elm$json$Json$Encode$string(name)),
					_Utils_Tuple2(
					'args',
					A2(elm$json$Json$Encode$list, elm$core$Basics$identity, args))
				]));
	});
var joakin$elm_canvas$Canvas$Internal$rotate = function (angle) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$fn,
		'rotate',
		_List_fromArray(
			[
				elm$json$Json$Encode$float(angle)
			]));
};
var joakin$elm_canvas$Canvas$Internal$scale = F2(
	function (x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'scale',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$transform = F6(
	function (a, b, c, d, e, f) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'transform',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(a),
					elm$json$Json$Encode$float(b),
					elm$json$Json$Encode$float(c),
					elm$json$Json$Encode$float(d),
					elm$json$Json$Encode$float(e),
					elm$json$Json$Encode$float(f)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$translate = F2(
	function (x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'translate',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$transform = function (transforms) {
	return joakin$elm_canvas$Canvas$SettingCommands(
		A2(
			elm$core$List$map,
			function (t) {
				switch (t.$) {
					case 0:
						var angle = t.a;
						return joakin$elm_canvas$Canvas$Internal$rotate(angle);
					case 1:
						var x = t.a;
						var y = t.b;
						return A2(joakin$elm_canvas$Canvas$Internal$scale, x, y);
					case 2:
						var x = t.a;
						var y = t.b;
						return A2(joakin$elm_canvas$Canvas$Internal$translate, x, y);
					default:
						var m11 = t.a.bI;
						var m12 = t.a.bJ;
						var m21 = t.a.bK;
						var m22 = t.a.bL;
						var dx = t.a.bu;
						var dy = t.a.bv;
						return A6(joakin$elm_canvas$Canvas$Internal$transform, m11, m12, m21, m22, dx, dy);
				}
			},
			transforms));
};
var joakin$elm_canvas$Canvas$Translate = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var joakin$elm_canvas$Canvas$translate = joakin$elm_canvas$Canvas$Translate;
var author$project$Main$cMicronView = F3(
	function (t, frame, data) {
		var phase = function (modifier) {
			return elm_community$easing_functions$Ease$inOutSine(
				A2(
					elm$core$Basics$modBy,
					author$project$Main$framerate,
					(frame + elm$core$Basics$round(modifier * author$project$Main$framerate)) - data.d) / (author$project$Main$framerate * 2));
		};
		var cMicronCircle = F2(
			function (widthTransform, rotation) {
				return A2(
					joakin$elm_canvas$Canvas$shapes,
					_List_fromArray(
						[
							joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$darkGray),
							joakin$elm_canvas$Canvas$fill(
							A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0)),
							joakin$elm_canvas$Canvas$transform(
							_List_fromArray(
								[
									A2(joakin$elm_canvas$Canvas$translate, t.j + data.a, t.k + data.b),
									joakin$elm_canvas$Canvas$rotate(rotation),
									A2(joakin$elm_canvas$Canvas$scale, widthTransform, 1)
								]))
						]),
					_List_fromArray(
						[
							A2(
							joakin$elm_canvas$Canvas$circle,
							_Utils_Tuple2(0, 0),
							data.c)
						]));
			});
		var cMicronCircles = function () {
			var widthTransforms = A2(
				elm$core$List$map,
				function (x) {
					return (phase(x / 3) * 2) - 1;
				},
				A2(elm$core$List$range, 0, 4));
			return _Utils_ap(
				A2(
					elm$core$List$map,
					function (x) {
						return A2(cMicronCircle, x, 0);
					},
					widthTransforms),
				A2(
					elm$core$List$map,
					function (x) {
						return A2(
							cMicronCircle,
							x,
							elm$core$Basics$degrees(70));
					},
					widthTransforms));
		}();
		return cMicronCircles;
	});
var author$project$Main$inertTakerRadius = 48;
var author$project$Main$makeTakerCircle = F2(
	function (endX, endY) {
		return A2(
			joakin$elm_canvas$Canvas$circle,
			_Utils_Tuple2(endX, endY),
			4);
	});
var joakin$elm_canvas$Canvas$LineTo = function (a) {
	return {$: 2, a: a};
};
var joakin$elm_canvas$Canvas$lineTo = function (point) {
	return joakin$elm_canvas$Canvas$LineTo(point);
};
var joakin$elm_canvas$Canvas$Path = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var joakin$elm_canvas$Canvas$path = F2(
	function (startingPoint, segments) {
		return A2(joakin$elm_canvas$Canvas$Path, startingPoint, segments);
	});
var author$project$Main$makeTakerLine = F3(
	function (t, endX, endY) {
		return A2(
			joakin$elm_canvas$Canvas$path,
			_Utils_Tuple2(t.j + author$project$Main$liverX, t.k + author$project$Main$liverY),
			_List_fromArray(
				[
					joakin$elm_canvas$Canvas$lineTo(
					_Utils_Tuple2(endX, endY))
				]));
	});
var avh4$elm_color$Color$grey = A4(avh4$elm_color$Color$RgbaSpace, 211 / 255, 215 / 255, 207 / 255, 1.0);
var joakin$elm_canvas$Canvas$SettingCommand = function (a) {
	return {$: 0, a: a};
};
var joakin$elm_canvas$Canvas$Internal$field = F2(
	function (name, value) {
		return elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'type',
					elm$json$Json$Encode$string('field')),
					_Utils_Tuple2(
					'name',
					elm$json$Json$Encode$string(name)),
					_Utils_Tuple2('value', value)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$lineWidth = function (value) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$field,
		'lineWidth',
		elm$json$Json$Encode$float(value));
};
var joakin$elm_canvas$Canvas$lineWidth = function (width) {
	return joakin$elm_canvas$Canvas$SettingCommand(
		joakin$elm_canvas$Canvas$Internal$lineWidth(width));
};
var author$project$Main$inertTakerView = F3(
	function (t, state, data) {
		var endY = t.k + (author$project$Main$liverY + (elm$core$Basics$sin(data.ax) * (author$project$Main$inertTakerRadius * data.z)));
		var endX = t.j + (author$project$Main$liverX + (elm$core$Basics$cos(data.ax) * (author$project$Main$inertTakerRadius * data.z)));
		var takerCircle = A2(author$project$Main$makeTakerCircle, endX, endY);
		var takerLine = A3(author$project$Main$makeTakerLine, t, endX, endY);
		if (!state) {
			return A2(
				joakin$elm_canvas$Canvas$shapes,
				_List_fromArray(
					[
						joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$grey),
						joakin$elm_canvas$Canvas$lineWidth(2),
						joakin$elm_canvas$Canvas$fill(
						A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0))
					]),
				_List_fromArray(
					[takerLine, takerCircle]));
		} else {
			return A2(
				joakin$elm_canvas$Canvas$shapes,
				_List_fromArray(
					[
						joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$grey),
						joakin$elm_canvas$Canvas$lineWidth(2),
						joakin$elm_canvas$Canvas$fill(
						A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0))
					]),
				_List_fromArray(
					[takerLine]));
		}
	});
var avh4$elm_color$Color$red = A4(avh4$elm_color$Color$RgbaSpace, 204 / 255, 0 / 255, 0 / 255, 1.0);
var author$project$Main$lProteinView = F4(
	function (t, random, frame, data) {
		var phase = function (modifier) {
			return elm_community$easing_functions$Ease$inOutSine(
				A2(
					elm$core$Basics$modBy,
					author$project$Main$framerate,
					(frame + elm$core$Basics$round(modifier * author$project$Main$framerate)) - data.d) / (author$project$Main$framerate * 2));
		};
		var lProteinCircle = F2(
			function (widthTransform, rotation) {
				return A2(
					joakin$elm_canvas$Canvas$shapes,
					_List_fromArray(
						[
							joakin$elm_canvas$Canvas$stroke(
							A4(avh4$elm_color$Color$hsla, 0, 0, 0.8, 0.8)),
							joakin$elm_canvas$Canvas$fill(
							A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0)),
							joakin$elm_canvas$Canvas$transform(
							_List_fromArray(
								[
									A2(joakin$elm_canvas$Canvas$translate, t.j + data.a, t.k + data.b),
									joakin$elm_canvas$Canvas$rotate(rotation),
									A2(joakin$elm_canvas$Canvas$scale, widthTransform, 1)
								]))
						]),
					_List_fromArray(
						[
							A2(
							joakin$elm_canvas$Canvas$circle,
							_Utils_Tuple2(0, 0),
							data.c)
						]));
			});
		var lProteinCircles = function () {
			var widthTransforms = A2(
				elm$core$List$map,
				function (x) {
					return (phase(x / 2) * 2) - 1;
				},
				A2(elm$core$List$range, 0, 3));
			return _Utils_ap(
				A2(
					elm$core$List$map,
					function (x) {
						return A2(lProteinCircle, x, 0);
					},
					widthTransforms),
				A2(
					elm$core$List$map,
					function (x) {
						return A2(lProteinCircle, x, 90);
					},
					widthTransforms));
		}();
		var _n0 = A2(
			elm$random$Random$step,
			A2(elm$random$Random$float, 0.75, 1.25),
			elm$random$Random$initialSeed(
				elm$core$Basics$round(random * 1000)));
		var cholesterolSizeModifier = _n0.a;
		var cholesterolCircle = A2(
			joakin$elm_canvas$Canvas$shapes,
			_List_fromArray(
				[
					joakin$elm_canvas$Canvas$fill(avh4$elm_color$Color$red)
				]),
			_List_fromArray(
				[
					A2(
					joakin$elm_canvas$Canvas$circle,
					_Utils_Tuple2(t.j + data.a, t.k + data.b),
					(author$project$Main$ldlThreshold - 2) * cholesterolSizeModifier)
				]));
		return A2(elm$core$List$cons, cholesterolCircle, lProteinCircles);
	});
var author$project$Main$makeLipase = F3(
	function (t, x, y) {
		return A2(
			joakin$elm_canvas$Canvas$circle,
			_Utils_Tuple2(t.j + x, t.k + y),
			1);
	});
var author$project$Main$lipaseView = F2(
	function (t, data) {
		var yOuter = elm$core$Basics$sin(data.T) * (author$project$Main$circuitRadius + author$project$Main$trackHalfWidth);
		var yInner = elm$core$Basics$sin(data.T) * (author$project$Main$circuitRadius - author$project$Main$trackHalfWidth);
		var xOuter = elm$core$Basics$cos(data.T) * (author$project$Main$circuitRadius + author$project$Main$trackHalfWidth);
		var xInner = elm$core$Basics$cos(data.T) * (author$project$Main$circuitRadius - author$project$Main$trackHalfWidth);
		var lipaseOuter = A3(author$project$Main$makeLipase, t, xOuter, yOuter);
		var lipaseInner = A3(author$project$Main$makeLipase, t, xInner, yInner);
		return _List_fromArray(
			[lipaseInner, lipaseOuter]);
	});
var author$project$Main$liverRadius = 32;
var elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3(elm$core$List$foldr, elm$core$List$cons, ys, xs);
		}
	});
var elm$core$List$concat = function (lists) {
	return A3(elm$core$List$foldr, elm$core$List$append, _List_Nil, lists);
};
var author$project$Main$liverView = F3(
	function (t, random, data) {
		var liverCircle = F2(
			function (rotation, widthTransform) {
				return A2(
					joakin$elm_canvas$Canvas$shapes,
					_List_fromArray(
						[
							joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$grey),
							joakin$elm_canvas$Canvas$lineWidth(10),
							joakin$elm_canvas$Canvas$fill(
							A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0)),
							joakin$elm_canvas$Canvas$transform(
							_List_fromArray(
								[
									A2(joakin$elm_canvas$Canvas$translate, t.j + data.a, t.k + data.b),
									joakin$elm_canvas$Canvas$rotate(rotation),
									A2(joakin$elm_canvas$Canvas$scale, widthTransform, 1)
								]))
						]),
					_List_fromArray(
						[
							A2(
							joakin$elm_canvas$Canvas$circle,
							_Utils_Tuple2(0, 0),
							author$project$Main$liverRadius)
						]));
			});
		var _n0 = A2(
			elm$random$Random$step,
			A2(
				elm$random$Random$list,
				5,
				A2(elm$random$Random$float, 0, 1)),
			elm$random$Random$initialSeed(
				elm$core$Basics$round(random * 1000)));
		var noise = _n0.a;
		var s2 = _n0.b;
		var _n1 = A2(
			elm$random$Random$step,
			A2(elm$random$Random$float, 0, elm$core$Basics$pi),
			s2);
		var rotationValue = _n1.a;
		var s3 = _n1.b;
		var _n2 = A2(
			elm$random$Random$step,
			A2(elm$random$Random$float, 0.75, 1.25),
			s3);
		var coreModifier = _n2.a;
		var liverCore = A2(
			joakin$elm_canvas$Canvas$shapes,
			_List_fromArray(
				[
					joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$grey),
					joakin$elm_canvas$Canvas$fill(avh4$elm_color$Color$grey)
				]),
			_List_fromArray(
				[
					A2(
					joakin$elm_canvas$Canvas$circle,
					_Utils_Tuple2(t.j + data.a, t.k + data.b),
					(author$project$Main$liverRadius / 3) * coreModifier)
				]));
		return A2(
			elm$core$List$cons,
			liverCore,
			elm$core$List$concat(
				_List_fromArray(
					[
						A2(
						elm$core$List$map,
						liverCircle(0),
						noise),
						A2(
						elm$core$List$map,
						liverCircle(rotationValue),
						noise)
					])));
	});
var elm_community$easing_functions$Ease$inQuad = function (time) {
	return A2(elm$core$Basics$pow, time, 2);
};
var joakin$elm_canvas$Canvas$Internal$globalAlpha = function (alpha) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$field,
		'globalAlpha',
		elm$json$Json$Encode$float(alpha));
};
var joakin$elm_canvas$Canvas$alpha = function (a) {
	return joakin$elm_canvas$Canvas$SettingCommand(
		joakin$elm_canvas$Canvas$Internal$globalAlpha(a));
};
var author$project$Main$pulseView = F4(
	function (t, pulseColor, frame, data) {
		var pulseRender = function (object) {
			var _n0 = object.s;
			if (!_n0.$) {
				var pulseData = _n0.a;
				var alphaValue = elm_community$easing_functions$Ease$inQuad(1 - ((frame - pulseData.d) / (author$project$Main$framerate * 1)));
				return A2(
					joakin$elm_canvas$Canvas$shapes,
					_List_fromArray(
						[
							joakin$elm_canvas$Canvas$transform(
							_List_fromArray(
								[
									A2(joakin$elm_canvas$Canvas$translate, t.j, t.k)
								])),
							joakin$elm_canvas$Canvas$stroke(pulseColor),
							joakin$elm_canvas$Canvas$alpha(alphaValue),
							joakin$elm_canvas$Canvas$fill(
							A4(avh4$elm_color$Color$hsla, 0, 0, 0, 0))
						]),
					_List_fromArray(
						[
							A2(
							joakin$elm_canvas$Canvas$circle,
							_Utils_Tuple2(object.a, object.b),
							pulseData.P)
						]));
			} else {
				return A2(
					joakin$elm_canvas$Canvas$shapes,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							joakin$elm_canvas$Canvas$circle,
							_Utils_Tuple2(object.a, object.b),
							0)
						]));
			}
		};
		return A2(elm$core$List$map, pulseRender, data);
	});
var author$project$Main$takerView = F2(
	function (t, data) {
		var endY = (t.k + author$project$Main$liverY) + (data.z * (data.bj - author$project$Main$liverY));
		var endX = (t.j + author$project$Main$liverX) + (data.z * (data.bi - author$project$Main$liverX));
		var takerCircle = A2(author$project$Main$makeTakerCircle, endX, endY);
		var takerLine = A3(author$project$Main$makeTakerLine, t, endX, endY);
		return A2(
			joakin$elm_canvas$Canvas$shapes,
			_List_fromArray(
				[
					joakin$elm_canvas$Canvas$stroke(avh4$elm_color$Color$grey),
					joakin$elm_canvas$Canvas$lineWidth(2),
					joakin$elm_canvas$Canvas$fill(avh4$elm_color$Color$red)
				]),
			_List_fromArray(
				[takerLine, takerCircle]));
	});
var avh4$elm_color$Color$gray = A4(avh4$elm_color$Color$RgbaSpace, 211 / 255, 215 / 255, 207 / 255, 1.0);
var avh4$elm_color$Color$scaleFrom255 = function (c) {
	return c / 255;
};
var avh4$elm_color$Color$rgb255 = F3(
	function (r, g, b) {
		return A4(
			avh4$elm_color$Color$RgbaSpace,
			avh4$elm_color$Color$scaleFrom255(r),
			avh4$elm_color$Color$scaleFrom255(g),
			avh4$elm_color$Color$scaleFrom255(b),
			1.0);
	});
var elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var joakin$elm_canvas$Canvas$Rect = F3(
	function (a, b, c) {
		return {$: 0, a: a, b: b, c: c};
	});
var joakin$elm_canvas$Canvas$rect = F3(
	function (pos, width, height) {
		return A3(joakin$elm_canvas$Canvas$Rect, pos, width, height);
	});
var author$project$Main$animationCanvas = F3(
	function (model, canvasWidth, canvasHeight) {
		var translator = {j: canvasWidth / 2, k: canvasHeight / 2};
		return elm$core$List$concat(
			_List_fromArray(
				[
					_List_fromArray(
					[
						A2(
						joakin$elm_canvas$Canvas$shapes,
						_List_fromArray(
							[
								joakin$elm_canvas$Canvas$transform(
								_List_fromArray(
									[
										A2(joakin$elm_canvas$Canvas$translate, translator.j, translator.k)
									])),
								joakin$elm_canvas$Canvas$fill(
								A3(avh4$elm_color$Color$rgb255, 34, 41, 47))
							]),
						_List_fromArray(
							[
								A3(
								joakin$elm_canvas$Canvas$rect,
								_Utils_Tuple2(0 - ((canvasWidth / 2) | 0), 0 - ((canvasHeight / 2) | 0)),
								canvasWidth,
								canvasHeight)
							]))
					]),
					A4(author$project$Main$pulseView, translator, author$project$Main$cMicronPulseColor, model.x, model.F),
					A4(author$project$Main$pulseView, translator, author$project$Main$lProteinPulseColor, model.x, model.I),
					elm$core$List$concat(
					A2(
						elm$core$List$map,
						A2(author$project$Main$cMicronView, translator, model.x),
						model.F)),
					elm$core$List$concat(
					A2(
						elm$core$List$map,
						A3(author$project$Main$lProteinView, translator, model.L, model.x),
						model.I)),
					A3(author$project$Main$liverView, translator, model.L, model.ag),
					A2(
					elm$core$List$map,
					author$project$Main$takerView(translator),
					A2(elm$core$Maybe$withDefault, _List_Nil, model.ad)),
					A2(
					elm$core$List$map,
					A2(author$project$Main$inertTakerView, translator, model.r),
					model.ac),
					_List_fromArray(
					[
						A2(
						joakin$elm_canvas$Canvas$shapes,
						_List_fromArray(
							[
								joakin$elm_canvas$Canvas$fill(avh4$elm_color$Color$gray)
							]),
						elm$core$List$concat(
							A2(
								elm$core$List$map,
								author$project$Main$lipaseView(translator),
								model.af)))
					])
				]));
	});
var elm$core$Basics$not = _Basics_not;
var elm$html$Html$br = _VirtualDom_node('br');
var elm$html$Html$button = _VirtualDom_node('button');
var elm$html$Html$div = _VirtualDom_node('div');
var elm$html$Html$span = _VirtualDom_node('span');
var elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var elm$html$Html$text = elm$virtual_dom$VirtualDom$text;
var elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			elm$json$Json$Encode$string(string));
	});
var elm$html$Html$Attributes$class = elm$html$Html$Attributes$stringProperty('className');
var elm$core$Tuple$second = function (_n0) {
	var y = _n0.b;
	return y;
};
var elm$html$Html$Attributes$classList = function (classes) {
	return elm$html$Html$Attributes$class(
		A2(
			elm$core$String$join,
			' ',
			A2(
				elm$core$List$map,
				elm$core$Tuple$first,
				A2(elm$core$List$filter, elm$core$Tuple$second, classes))));
};
var elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 0, a: a};
};
var elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var elm$html$Html$Events$onClick = function (msg) {
	return A2(
		elm$html$Html$Events$on,
		'click',
		elm$json$Json$Decode$succeed(msg));
};
var elm$virtual_dom$VirtualDom$lazy5 = _VirtualDom_lazy5;
var elm$html$Html$Lazy$lazy5 = elm$virtual_dom$VirtualDom$lazy5;
var elm$html$Html$canvas = _VirtualDom_node('canvas');
var elm$virtual_dom$VirtualDom$node = function (tag) {
	return _VirtualDom_node(
		_VirtualDom_noScript(tag));
};
var elm$html$Html$node = elm$virtual_dom$VirtualDom$node;
var elm$html$Html$Attributes$height = function (n) {
	return A2(
		_VirtualDom_attribute,
		'height',
		elm$core$String$fromInt(n));
};
var elm$html$Html$Attributes$width = function (n) {
	return A2(
		_VirtualDom_attribute,
		'width',
		elm$core$String$fromInt(n));
};
var joakin$elm_canvas$Canvas$Internal$arcTo = F5(
	function (x1, y1, x2, y2, radius) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'arcTo',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x1),
					elm$json$Json$Encode$float(y1),
					elm$json$Json$Encode$float(x2),
					elm$json$Json$Encode$float(y2),
					elm$json$Json$Encode$float(radius)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$bezierCurveTo = F6(
	function (cp1x, cp1y, cp2x, cp2y, x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'bezierCurveTo',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(cp1x),
					elm$json$Json$Encode$float(cp1y),
					elm$json$Json$Encode$float(cp2x),
					elm$json$Json$Encode$float(cp2y),
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$lineTo = F2(
	function (x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'lineTo',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$moveTo = F2(
	function (x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'moveTo',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$quadraticCurveTo = F4(
	function (cpx, cpy, x, y) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'quadraticCurveTo',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(cpx),
					elm$json$Json$Encode$float(cpy),
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y)
				]));
	});
var joakin$elm_canvas$Canvas$renderLineSegment = F2(
	function (segment, cmds) {
		switch (segment.$) {
			case 0:
				var _n1 = segment.a;
				var x = _n1.a;
				var y = _n1.b;
				var _n2 = segment.b;
				var x2 = _n2.a;
				var y2 = _n2.b;
				var radius = segment.c;
				return A2(
					elm$core$List$cons,
					A5(joakin$elm_canvas$Canvas$Internal$arcTo, x, y, x2, y2, radius),
					cmds);
			case 1:
				var _n3 = segment.a;
				var cp1x = _n3.a;
				var cp1y = _n3.b;
				var _n4 = segment.b;
				var cp2x = _n4.a;
				var cp2y = _n4.b;
				var _n5 = segment.c;
				var x = _n5.a;
				var y = _n5.b;
				return A2(
					elm$core$List$cons,
					A6(joakin$elm_canvas$Canvas$Internal$bezierCurveTo, cp1x, cp1y, cp2x, cp2y, x, y),
					cmds);
			case 2:
				var _n6 = segment.a;
				var x = _n6.a;
				var y = _n6.b;
				return A2(
					elm$core$List$cons,
					A2(joakin$elm_canvas$Canvas$Internal$lineTo, x, y),
					cmds);
			case 3:
				var _n7 = segment.a;
				var x = _n7.a;
				var y = _n7.b;
				return A2(
					elm$core$List$cons,
					A2(joakin$elm_canvas$Canvas$Internal$moveTo, x, y),
					cmds);
			default:
				var _n8 = segment.a;
				var cpx = _n8.a;
				var cpy = _n8.b;
				var _n9 = segment.b;
				var x = _n9.a;
				var y = _n9.b;
				return A2(
					elm$core$List$cons,
					A4(joakin$elm_canvas$Canvas$Internal$quadraticCurveTo, cpx, cpy, x, y),
					cmds);
		}
	});
var elm$json$Json$Encode$bool = _Json_wrap;
var joakin$elm_canvas$Canvas$Internal$arc = F6(
	function (x, y, radius, startAngle, endAngle, anticlockwise) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'arc',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y),
					elm$json$Json$Encode$float(radius),
					elm$json$Json$Encode$float(startAngle),
					elm$json$Json$Encode$float(endAngle),
					elm$json$Json$Encode$bool(anticlockwise)
				]));
	});
var joakin$elm_canvas$Canvas$Internal$circle = F3(
	function (x, y, r) {
		return A6(joakin$elm_canvas$Canvas$Internal$arc, x, y, r, 0, 2 * elm$core$Basics$pi, false);
	});
var joakin$elm_canvas$Canvas$Internal$rect = F4(
	function (x, y, w, h) {
		return A2(
			joakin$elm_canvas$Canvas$Internal$fn,
			'rect',
			_List_fromArray(
				[
					elm$json$Json$Encode$float(x),
					elm$json$Json$Encode$float(y),
					elm$json$Json$Encode$float(w),
					elm$json$Json$Encode$float(h)
				]));
	});
var joakin$elm_canvas$Canvas$renderShape = F2(
	function (shape, cmds) {
		switch (shape.$) {
			case 0:
				var _n1 = shape.a;
				var x = _n1.a;
				var y = _n1.b;
				var w = shape.b;
				var h = shape.c;
				return A2(
					elm$core$List$cons,
					A4(joakin$elm_canvas$Canvas$Internal$rect, x, y, w, h),
					A2(
						elm$core$List$cons,
						A2(joakin$elm_canvas$Canvas$Internal$moveTo, x, y),
						cmds));
			case 1:
				var _n2 = shape.a;
				var x = _n2.a;
				var y = _n2.b;
				var r = shape.b;
				return A2(
					elm$core$List$cons,
					A3(joakin$elm_canvas$Canvas$Internal$circle, x, y, r),
					A2(
						elm$core$List$cons,
						A2(joakin$elm_canvas$Canvas$Internal$moveTo, x + r, y),
						cmds));
			case 2:
				var _n3 = shape.a;
				var x = _n3.a;
				var y = _n3.b;
				var segments = shape.b;
				return A3(
					elm$core$List$foldl,
					joakin$elm_canvas$Canvas$renderLineSegment,
					A2(
						elm$core$List$cons,
						A2(joakin$elm_canvas$Canvas$Internal$moveTo, x, y),
						cmds),
					segments);
			default:
				var _n4 = shape.a;
				var x = _n4.a;
				var y = _n4.b;
				var radius = shape.b;
				var startAngle = shape.c;
				var endAngle = shape.d;
				var anticlockwise = shape.e;
				return A2(
					elm$core$List$cons,
					A6(joakin$elm_canvas$Canvas$Internal$arc, x, y, radius, startAngle, endAngle, anticlockwise),
					A2(
						elm$core$List$cons,
						A2(
							joakin$elm_canvas$Canvas$Internal$moveTo,
							x + elm$core$Basics$cos(startAngle),
							y + elm$core$Basics$sin(startAngle)),
						cmds));
		}
	});
var avh4$elm_color$Color$black = A4(avh4$elm_color$Color$RgbaSpace, 0 / 255, 0 / 255, 0 / 255, 1.0);
var joakin$elm_canvas$Canvas$Internal$NonZero = 0;
var joakin$elm_canvas$Canvas$Internal$fillRuleToString = function (fillRule) {
	if (!fillRule) {
		return 'nonzero';
	} else {
		return 'evenodd';
	}
};
var joakin$elm_canvas$Canvas$Internal$fill = function (fillRule) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$fn,
		'fill',
		_List_fromArray(
			[
				elm$json$Json$Encode$string(
				joakin$elm_canvas$Canvas$Internal$fillRuleToString(fillRule))
			]));
};
var elm$core$String$concat = function (strings) {
	return A2(elm$core$String$join, '', strings);
};
var elm$core$String$fromFloat = _String_fromNumber;
var avh4$elm_color$Color$toCssString = function (_n0) {
	var r = _n0.a;
	var g = _n0.b;
	var b = _n0.c;
	var a = _n0.d;
	var roundTo = function (x) {
		return elm$core$Basics$round(x * 1000) / 1000;
	};
	var pct = function (x) {
		return elm$core$Basics$round(x * 10000) / 100;
	};
	return elm$core$String$concat(
		_List_fromArray(
			[
				'rgba(',
				elm$core$String$fromFloat(
				pct(r)),
				'%,',
				elm$core$String$fromFloat(
				pct(g)),
				'%,',
				elm$core$String$fromFloat(
				pct(b)),
				'%,',
				elm$core$String$fromFloat(
				roundTo(a)),
				')'
			]));
};
var joakin$elm_canvas$Canvas$Internal$fillStyle = function (color) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$field,
		'fillStyle',
		elm$json$Json$Encode$string(
			avh4$elm_color$Color$toCssString(color)));
};
var joakin$elm_canvas$Canvas$renderShapeFill = F2(
	function (c, cmds) {
		return A2(
			elm$core$List$cons,
			joakin$elm_canvas$Canvas$Internal$fill(0),
			A2(
				elm$core$List$cons,
				joakin$elm_canvas$Canvas$Internal$fillStyle(c),
				cmds));
	});
var joakin$elm_canvas$Canvas$Internal$stroke = A2(joakin$elm_canvas$Canvas$Internal$fn, 'stroke', _List_Nil);
var joakin$elm_canvas$Canvas$Internal$strokeStyle = function (color) {
	return A2(
		joakin$elm_canvas$Canvas$Internal$field,
		'strokeStyle',
		elm$json$Json$Encode$string(
			avh4$elm_color$Color$toCssString(color)));
};
var joakin$elm_canvas$Canvas$renderShapeStroke = F2(
	function (c, cmds) {
		return A2(
			elm$core$List$cons,
			joakin$elm_canvas$Canvas$Internal$stroke,
			A2(
				elm$core$List$cons,
				joakin$elm_canvas$Canvas$Internal$strokeStyle(c),
				cmds));
	});
var joakin$elm_canvas$Canvas$renderShapeDrawOp = F2(
	function (drawOp, cmds) {
		switch (drawOp.$) {
			case 0:
				return A2(joakin$elm_canvas$Canvas$renderShapeFill, avh4$elm_color$Color$black, cmds);
			case 1:
				var c = drawOp.a;
				return A2(joakin$elm_canvas$Canvas$renderShapeFill, c, cmds);
			case 2:
				var c = drawOp.a;
				return A2(joakin$elm_canvas$Canvas$renderShapeStroke, c, cmds);
			default:
				var fc = drawOp.a;
				var sc = drawOp.b;
				return A2(
					joakin$elm_canvas$Canvas$renderShapeStroke,
					sc,
					A2(joakin$elm_canvas$Canvas$renderShapeFill, fc, cmds));
		}
	});
var joakin$elm_canvas$Canvas$Internal$fillText = F4(
	function (text, x, y, maybeMaxWidth) {
		if (maybeMaxWidth.$ === 1) {
			return A2(
				joakin$elm_canvas$Canvas$Internal$fn,
				'fillText',
				_List_fromArray(
					[
						elm$json$Json$Encode$string(text),
						elm$json$Json$Encode$float(x),
						elm$json$Json$Encode$float(y)
					]));
		} else {
			var maxWidth = maybeMaxWidth.a;
			return A2(
				joakin$elm_canvas$Canvas$Internal$fn,
				'fillText',
				_List_fromArray(
					[
						elm$json$Json$Encode$string(text),
						elm$json$Json$Encode$float(x),
						elm$json$Json$Encode$float(y),
						elm$json$Json$Encode$float(maxWidth)
					]));
		}
	});
var joakin$elm_canvas$Canvas$renderTextFill = F5(
	function (txt, x, y, color, cmds) {
		return A2(
			elm$core$List$cons,
			A4(joakin$elm_canvas$Canvas$Internal$fillText, txt.aw, x, y, txt.ah),
			A2(
				elm$core$List$cons,
				joakin$elm_canvas$Canvas$Internal$fillStyle(color),
				cmds));
	});
var joakin$elm_canvas$Canvas$Internal$strokeText = F4(
	function (text, x, y, maybeMaxWidth) {
		if (maybeMaxWidth.$ === 1) {
			return A2(
				joakin$elm_canvas$Canvas$Internal$fn,
				'strokeText',
				_List_fromArray(
					[
						elm$json$Json$Encode$string(text),
						elm$json$Json$Encode$float(x),
						elm$json$Json$Encode$float(y)
					]));
		} else {
			var maxWidth = maybeMaxWidth.a;
			return A2(
				joakin$elm_canvas$Canvas$Internal$fn,
				'strokeText',
				_List_fromArray(
					[
						elm$json$Json$Encode$string(text),
						elm$json$Json$Encode$float(x),
						elm$json$Json$Encode$float(y),
						elm$json$Json$Encode$float(maxWidth)
					]));
		}
	});
var joakin$elm_canvas$Canvas$renderTextStroke = F5(
	function (txt, x, y, color, cmds) {
		return A2(
			elm$core$List$cons,
			A4(joakin$elm_canvas$Canvas$Internal$strokeText, txt.aw, x, y, txt.ah),
			A2(
				elm$core$List$cons,
				joakin$elm_canvas$Canvas$Internal$strokeStyle(color),
				cmds));
	});
var joakin$elm_canvas$Canvas$renderTextDrawOp = F3(
	function (drawOp, txt, cmds) {
		var _n0 = txt.aF;
		var x = _n0.a;
		var y = _n0.b;
		switch (drawOp.$) {
			case 0:
				return A5(joakin$elm_canvas$Canvas$renderTextFill, txt, x, y, avh4$elm_color$Color$black, cmds);
			case 1:
				var c = drawOp.a;
				return A5(joakin$elm_canvas$Canvas$renderTextFill, txt, x, y, c, cmds);
			case 2:
				var c = drawOp.a;
				return A5(joakin$elm_canvas$Canvas$renderTextStroke, txt, x, y, c, cmds);
			default:
				var fc = drawOp.a;
				var sc = drawOp.b;
				return A5(
					joakin$elm_canvas$Canvas$renderTextStroke,
					txt,
					x,
					y,
					sc,
					A5(joakin$elm_canvas$Canvas$renderTextFill, txt, x, y, fc, cmds));
		}
	});
var joakin$elm_canvas$Canvas$renderText = F3(
	function (drawOp, txt, cmds) {
		return A3(joakin$elm_canvas$Canvas$renderTextDrawOp, drawOp, txt, cmds);
	});
var joakin$elm_canvas$Canvas$Internal$beginPath = A2(joakin$elm_canvas$Canvas$Internal$fn, 'beginPath', _List_Nil);
var joakin$elm_canvas$Canvas$renderDrawable = F3(
	function (drawable, drawOp, cmds) {
		if (!drawable.$) {
			var txt = drawable.a;
			return A3(joakin$elm_canvas$Canvas$renderText, drawOp, txt, cmds);
		} else {
			var ss = drawable.a;
			return A2(
				joakin$elm_canvas$Canvas$renderShapeDrawOp,
				drawOp,
				A3(
					elm$core$List$foldl,
					joakin$elm_canvas$Canvas$renderShape,
					A2(elm$core$List$cons, joakin$elm_canvas$Canvas$Internal$beginPath, cmds),
					ss));
		}
	});
var joakin$elm_canvas$Canvas$Internal$restore = A2(joakin$elm_canvas$Canvas$Internal$fn, 'restore', _List_Nil);
var joakin$elm_canvas$Canvas$Internal$save = A2(joakin$elm_canvas$Canvas$Internal$fn, 'save', _List_Nil);
var joakin$elm_canvas$Canvas$renderOne = F2(
	function (_n0, cmds) {
		var data = _n0;
		var commands = data.G;
		var drawable = data.ab;
		var drawOp = data.aa;
		return A2(
			elm$core$List$cons,
			joakin$elm_canvas$Canvas$Internal$restore,
			A3(
				joakin$elm_canvas$Canvas$renderDrawable,
				drawable,
				drawOp,
				_Utils_ap(
					commands,
					A2(elm$core$List$cons, joakin$elm_canvas$Canvas$Internal$save, cmds))));
	});
var joakin$elm_canvas$Canvas$Internal$empty = _List_Nil;
var joakin$elm_canvas$Canvas$render = function (entities) {
	return A3(elm$core$List$foldl, joakin$elm_canvas$Canvas$renderOne, joakin$elm_canvas$Canvas$Internal$empty, entities);
};
var elm$virtual_dom$VirtualDom$property = F2(
	function (key, value) {
		return A2(
			_VirtualDom_property,
			_VirtualDom_noInnerHtmlOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var elm$html$Html$Attributes$property = elm$virtual_dom$VirtualDom$property;
var joakin$elm_canvas$Canvas$Internal$commands = function (list) {
	return A2(
		elm$html$Html$Attributes$property,
		'cmds',
		A2(elm$json$Json$Encode$list, elm$core$Basics$identity, list));
};
var joakin$elm_canvas$Canvas$toHtml = F3(
	function (_n0, attrs, entities) {
		var w = _n0.a;
		var h = _n0.b;
		return A3(
			elm$html$Html$node,
			'elm-canvas',
			_List_fromArray(
				[
					joakin$elm_canvas$Canvas$Internal$commands(
					joakin$elm_canvas$Canvas$render(entities))
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$canvas,
					A2(
						elm$core$List$cons,
						elm$html$Html$Attributes$height(h),
						A2(
							elm$core$List$cons,
							elm$html$Html$Attributes$width(w),
							attrs)),
					_List_Nil)
				]));
	});
var author$project$Main$view = function (model) {
	var runButtonTextValue = function () {
		var _n4 = model.M;
		if (!_n4) {
			return 'STOP';
		} else {
			return 'START';
		}
	}();
	var isSlowDisabledValue = model.t <= 5.0e-2;
	var isFastDisabledValue = model.t >= 2;
	var disabledButtonClass = 'bg-black small-text rounded border-grey-darkest border py-1 px-2 text-grey cursor-not-allowed mr-2';
	var bottomButtonClass = 'bg-black small-text border-grey-darkest rounded border py-1 px-2 text-grey-lightest hover:bg-grey-darkest';
	var _n0 = A2(
		elm$random$Random$step,
		A2(elm$random$Random$float, 0, 1),
		elm$random$Random$initialSeed(
			elm$core$Basics$round(model.L * 100)));
	var random2 = _n0.a;
	var _n1 = function () {
		var _n2 = model.r;
		if (!_n2) {
			return _Utils_Tuple2('State: Normal', true);
		} else {
			return _Utils_Tuple2('State: Pathological', false);
		}
	}();
	var buttonTextValue = _n1.a;
	var isNormalValue = _n1.b;
	var centerInfo = F5(
		function (isSlowDisabled, isFastDisabled, buttonText, runButtonText, isNormal) {
			return A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('h-screen flex-col flex items-center align-center justify-center absolute w-full')
					]),
				_List_fromArray(
					[
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('w-16 md:w-32')
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$div,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class('hidden md:block w-full p-1 mb-2 text-grey')
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class(' font-hairline small-text')
											]),
										_List_fromArray(
											[
												elm$html$Html$text('CIGMAH CGMNT')
											])),
										A2(
										elm$html$Html$br,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('')
											]),
										_List_Nil),
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class(' font-sans small-text')
											]),
										_List_fromArray(
											[
												elm$html$Html$text('Metabolic Mayhem')
											])),
										A2(elm$html$Html$br, _List_Nil, _List_Nil)
									])),
								A2(
								elm$html$Html$button,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class('w-full p-1 pb-2 bg-black border rounded hover:bg-grey-darkest   '),
										elm$html$Html$Attributes$classList(
										_List_fromArray(
											[
												_Utils_Tuple2('text-grey border-grey-darkest ', isNormalValue),
												_Utils_Tuple2('text-red-light border-red-light ', !isNormalValue)
											])),
										elm$html$Html$Events$onClick(author$project$Main$ToggleState)
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('small-text')
											]),
										_List_fromArray(
											[
												elm$html$Html$text(buttonText)
											])),
										A2(elm$html$Html$br, _List_Nil, _List_Nil),
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('text-xs smaller-text')
											]),
										_List_fromArray(
											[
												elm$html$Html$text('(Click to Toggle)')
											]))
									])),
								A2(
								elm$html$Html$div,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class('mt-2 w-full')
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$button,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class(bottomButtonClass + ' w-full '),
												elm$html$Html$Events$onClick(author$project$Main$ToggleRunState)
											]),
										_List_fromArray(
											[
												elm$html$Html$text(runButtonText)
											]))
									]))
							]))
					]));
		});
	var _n3 = _Utils_Tuple2(600, 600);
	var canvasWidth = _n3.a;
	var canvasHeight = _n3.b;
	return A2(
		elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('h-screen absolute w-full flex items-center align-center justify-center bg-black')
					]),
				_List_fromArray(
					[
						A3(
						joakin$elm_canvas$Canvas$toHtml,
						_Utils_Tuple2(canvasWidth, canvasHeight),
						_List_Nil,
						A3(author$project$Main$animationCanvas, model, canvasWidth, canvasHeight)),
						A6(elm$html$Html$Lazy$lazy5, centerInfo, isSlowDisabledValue, isFastDisabledValue, buttonTextValue, runButtonTextValue, isNormalValue)
					]))
			]));
};
var elm$browser$Browser$element = _Browser_element;
var author$project$Main$main = elm$browser$Browser$element(
	{
		bG: function (_n0) {
			return author$project$Main$init;
		},
		bW: author$project$Main$subscriptions,
		b_: author$project$Main$update,
		b1: author$project$Main$view
	});
_Platform_export({'Main':{'init':author$project$Main$main(
	elm$json$Json$Decode$succeed(0))(0)}});}(this));
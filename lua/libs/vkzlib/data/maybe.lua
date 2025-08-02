---@enum Maybe.Types
local _TYPES = {
  ---@alias Maybe.Types.Nothing "Maybe.Nothing"
  ---@type Maybe.Types.Nothing
  NOTHING = "Maybe.Nothing",
  ---@alias Maybe.Types.Just "Maybe.Just"
  ---@type Maybe.Types.Just
  JUST = "Maybe.Just",
}

---@class Maybe.Nothing
local _Nothing = {}

---@return Maybe.Nothing
function _Nothing.get()
  return _Nothing
end

---@return Maybe.Types.Nothing
function _Nothing.type()
  return _TYPES.NOTHING
end

---@class Maybe.Just<T>: { val: T }
local _Just = { val = nil }

---@generic T
---@param val T
---@return Maybe.Just<T>
function _Just:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@generic T
---@return T
function _Just:get()
	return self.val
end

---@return Maybe.Types.Just
function _Just.type()
  return _TYPES.JUST
end

---@class Maybe<T>: { val: Maybe.Just<T> | Maybe.Nothing }
local Maybe = { val = nil }

---@private
---@generic T
---@param val Maybe.Just<T> | Maybe.Nothing
---@return Maybe<T>
function Maybe:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@private
---@generic T
---@return Maybe.Just<T> | Maybe.Nothing
function Maybe:get()
	return self.val
end

---@generic T
---@type Maybe<T>
local Nothing = Maybe:new(_Nothing)

---@generic T
---@param x T
---@return Maybe<T>
local function Just(x)
	return Maybe:new(_Just:new(x))
end

---@generic T, R
---@param on_just fun(x: T): R
---@param on_nothing fun(): R
---@return R
function Maybe:match(on_just, on_nothing)
	local VAL = self:get()
	if VAL:type() == _TYPES.NOTHING then
    ---@cast VAL Maybe.Nothing
		return on_nothing()
  elseif VAL:type() == _TYPES.JUST then
    ---@cast VAL Maybe.Just
	  return on_just(VAL:get())
  else
    error("Maybe.match: Not a Maybe")
  end
end

---@return boolean
function Maybe:is_nothing()
	return self:get() == _Nothing
end

---@return boolean
function Maybe:is_just()
	return not self:is_nothing()
end

---@generic T
---@param x T
---@param m Maybe<T>
---@return T
local function from_maybe(x, m)
	return m:match(function(val)
		return val
	end, function()
		return x
	end)
end

---@generic T
---@param m Maybe<T>
---@return T
local function from_just(m)
	return m:match(function(x)
		return x
	end, function()
		return error("from_just: Nothing")
	end)
end

---@generic T, R
---@param f fun(x: T): R
---@param m Maybe<T>
---@return Maybe<R>
local function map(f, m)
	return m:match(function(x)
		return Just(f(x))
	end, function()
		return Nothing
	end)
end

---@generic T, R
---@param mf Maybe<fun(x: T): R>
---@param ma Maybe<T>
---@return Maybe<R>
local function ap(mf, ma)
	return mf:match(function(f)
		return map(f, ma)
	end, function()
		return Nothing
	end)
end

---@generic T1, T2, R
---@param f fun(x: T1, y: T2): R
---@param ma Maybe<T1>
---@param mb Maybe<T2>
local function liftA2(f, ma, mb)
	local curried = function(x)
		return function(y)
			return f(x, y)
		end
	end
	return ap(map(curried, ma), mb)
end

---@generic T, R
---@param a R
---@param f fun(x: T): R
---@param m Maybe<T>
---@return R
local function maybe(a, f, m)
  return from_maybe(a, map(f, m))
end

return {
	Nothing = Nothing,
	Just = Just,
	match = Maybe.match,
	is_nothing = Maybe.is_nothing,
	is_just = Maybe.is_just,
	from_maybe = from_maybe,
	from_just = from_just,
	map = map,
	ap = ap,
  liftA2 = liftA2,
  maybe = maybe,
}

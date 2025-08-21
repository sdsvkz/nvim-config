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

---@class Maybe.Just<T> : { val: T }
local _Just = {}

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
---@param self Maybe.Just<T>
---@return T
function _Just:get()
	return self.val
end

---@return Maybe.Types.Just
function _Just.type()
  return _TYPES.JUST
end

---@class Maybe<T> : { val: Maybe.Just<T> | Maybe.Nothing, __t: T }
local Maybe = {}

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
---@param self Maybe<T>
---@return Maybe.Just<T> | Maybe.Nothing
function Maybe:get()
	return self.val
end

---@generic T
---@type Maybe<T>
Maybe.Nothing = Maybe:new(_Nothing)

---@generic T
---@param x T
---@return Maybe<T>
function Maybe.Just(x)
	return Maybe:new(_Just:new(x))
end

---@generic T, R
---@param self Maybe<T>
---@param onJust fun(x: T): R
---@param onNothing fun(): R
---@return R
function Maybe:match(onJust, onNothing)
	local VAL = self:get()
	if VAL:type() == _TYPES.NOTHING then
		return onNothing()
  elseif VAL:type() == _TYPES.JUST then
	  return onJust(VAL:get())
  else
    error("Maybe.match: Not a Maybe")
  end
end

---@generic T
---@param self Maybe<T>
---@return boolean
function Maybe:isNothing()
	return self:get() == _Nothing
end

---@generic T
---@param self Maybe<T>
---@return boolean
function Maybe:isJust()
	return not self:isNothing()
end

---@generic T
---@param self Maybe<T>
---@param x T
---@return T
function Maybe:fromMaybe(x)
	return self:match(function(val)
		return val
	end, function()
		return x
	end)
end

---@generic T
---@param self Maybe<T>
---@return T
function Maybe:fromJust()
	return self:match(function(x)
		return x
	end, function()
		return error("from_just: Nothing")
	end)
end

---@generic T, R
---@param f fun(x: T): R
---@param self Maybe<T>
---@return Maybe<R>
function Maybe:map(f)
	return self:match(function(x)
		return Maybe.Just(f(x))
	end, function()
		return Maybe.Nothing
	end)
end

---@generic T, R
---@param self Maybe<T>
---@param mf Maybe<fun(x: T): R>
---@return Maybe<R>
function Maybe:ap(mf)
	return mf:match(function(f)
		return self:map(f)
	end, function()
		return Maybe.Nothing
	end)
end

---@generic T1, T2, R
---@param f fun(x: T1, y: T2): R
---@param ma Maybe<T1>
---@param mb Maybe<T2>
---@return Maybe<R>
function Maybe.liftA2(f, ma, mb)
	local curried = function(x)
		return function(y)
			return f(x, y)
		end
	end
	return mb:ap(ma:map(curried))
end

---@generic T, R
---@param self Maybe<T>
---@param a R
---@param f fun(x: T): R
---@return R
function Maybe:maybe(a, f)
  return self:map(f):fromMaybe(a)
end

return Maybe


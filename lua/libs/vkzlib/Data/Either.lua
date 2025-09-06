local MODULE = "Data.Either"

---@enum Either.Types
local _TYPES = {
	---@alias Either.Types.Left "Either.Left"
	---@type Either.Types.Left
	LEFT = "Either.Left",
	---@alias Either.Types.Right "Either.Right"
	---@type Either.Types.Right
	RIGHT = "Either.Right",
}

---@class Either.Left<L> : { val: L }
local _Left = {}

---@generic L
---@param val L
---@return Either.Left<L>
function _Left:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@generic L
---@param self Either.Left<L>
---@return L
function _Left:get()
	return self.val
end

---@return Either.Types.Left
function _Left.type()
	return _TYPES.LEFT
end

---@class Either.Right<R> : { val: R }
local _Right = {}

---@generic R
---@param val R
---@return Either.Right<R>
function _Right:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@generic R
---@param self Either.Right<R>
---@return R
function _Right:get()
	return self.val
end

---@return Either.Types.Right
function _Right.type()
	return _TYPES.RIGHT
end

---@class Either<L, R> : { val: Either.Left<L> | Either.Right<R>, __l: L, __r: R }
local Either = {}

---@private
---@generic L, R
---@param val Either.Left<L> | Either.Right<R>
---@return Either<L, R>
function Either:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@private
---@generic L, R
---@param self Either<L, R>
---@return Either.Left<L> | Either.Right<R>
function Either:get()
	return self.val
end

---@generic L, R
---@param x L
---@return Either<L, R>
function Either.Left(x)
	return Either:new(_Left:new(x))
end

---@generic L, R
---@param x R
---@return Either<L, R>
function Either.Right(x)
	return Either:new(_Right:new(x))
end

---@generic Left, Right, R
---@param self Either<Left, Right>
---@param onLeft fun(l: Left): R
---@param onRight fun(r: Right): R
---@return R
function Either:match(onLeft, onRight)
	local VAL = self:get()
	if VAL:type() == "Either.Left" then
		return onLeft(VAL:get())
	elseif VAL:type() == "Either.Right" then
		return onRight(VAL:get())
	else
		error("Either.match: Not an Either")
	end
end

---@generic L, R
---@param self Either<L, R>
---@return boolean
function Either:isLeft()
	return self:get():type() == _TYPES.LEFT
end

---@generic L, R
---@param self Either<L, R>
---@return boolean
function Either:isRight()
	return self:get():type() == _TYPES.RIGHT
end

---@generic L, R
---@param self Either<L, R>
---@param a L
---@return L
function Either:fromLeft(a)
	return self:match(function(l)
		return l
	end, function(_)
		return a
	end)
end

---@generic L, R
---@param self Either<L, R>
---@param b R
---@return R
function Either:fromRight(b)
	return self:match(function(_)
		return b
	end, function(r)
		return r
	end)
end

---@generic L1, L2, R1, R2
---@param self Either<L1, R1>
---@param f fun(l: L1): L2
---@param g fun(r: R1): R2
---@return Either<L2, R2>
function Either:bimap(f, g)
	return self:match(function(l)
		return Either.Left(f(l))
	end, function(r)
		return Either.Right(g(r))
	end)
end

---@generic Left, Right, R
---@param self Either<Left, Right>
---@param f fun(l: Left): R
---@return Either<R, Right>
function Either:mapLeft(f)
	return self:bimap(f, function (r)
    return r
	end)
end

---@generic Left, Right, R
---@param self Either<Left, Right>
---@param f fun(r: Right): R
---@return Either<Left, R>
function Either:map(f)
	return self:bimap(function (l)
	  return l
	end, f)
end

---@generic Left, Right, R
---@param self Either<Left, Right>
---@param f fun(l: Left): R
---@param g fun(r: Right): R
---@return R
function Either:either(f, g)
  return self:match(function (l)
    return f(l)
  end, function (r)
    return g(r)
  end)
end

return Either

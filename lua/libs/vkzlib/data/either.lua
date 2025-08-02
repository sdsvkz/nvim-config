---@enum Either.Types
local _TYPES = {
	---@alias Either.Types.Left "Either.Left"
	---@type Either.Types.Left
	LEFT = "Either.Left",
	---@alias Either.Types.Right "Either.Right"
	---@type Either.Types.Right
	RIGHT = "Either.Right",
}

---@class Either.Left<T>: { val: T }
local _Left = { val = nil }

---@generic T
---@param val T
---@return Either.Left<T>
function _Left:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@generic T
---@return T
function _Left:get()
	return self.val
end

---@return Either.Types.Left
function _Left.type()
	return _TYPES.LEFT
end

---@class Either.Right<T>: { val: T }
local _Right = { val = nil }

---@generic T
---@param val T
---@return Either.Right<T>
function _Right:new(val)
	local instance = { val = val }
	setmetatable(instance, self)
	self.__index = self
	return instance
end

---@generic T
---@return T
function _Right:get()
	return self.val
end

---@return Either.Types.Right
function _Right.type()
	return _TYPES.RIGHT
end

---@class Either<L, R>: { val: Either.Left<L> | Either.Right<R> }
local Either = { val = nil }

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
---@return Either.Left<L> | Either.Right<R>
function Either:get()
	return self.val
end

---@generic L
---@param x L
---@return Either<L, any>
local function Left(x)
	return Either:new(_Left:new(x))
end

---@generic R
---@param x R
---@return Either<any, R>
local function Right(x)
	return Either:new(_Right:new(x))
end

---@generic Left, Right, R
---@param on_left fun(l: Left): R
---@param on_right fun(r: Right): R
---@return R
function Either:match(on_left, on_right)
	local VAL = self:get()
	if VAL:type() == "Either.Left" then
		---@cast VAL Either.Left
		return on_left(VAL:get())
	elseif VAL:type() == "Either.Right" then
		---@cast VAL Either.Right
		return on_right(VAL:get())
	else
		error("Either.match: Not an Either")
	end
end

---@return boolean
function Either:is_left()
	return self:get():type() == _TYPES.LEFT
end

---@return boolean
function Either:is_right()
	return self:get():type() == _TYPES.RIGHT
end

---@generic L, R
---@param a L
---@param e Either<L, R>
---@return L
local function from_left(a, e)
	return e:match(function(l)
		return l
	end, function(_)
		return a
	end)
end

---@generic L, R
---@param b R
---@param e Either<L, R>
---@return R
local function from_right(b, e)
	return e:match(function(_)
		return b
	end, function(r)
		return r
	end)
end

---@generic L1, L2, R1, R2
---@param f fun(l: L1): L2
---@param g fun(r: R1): R2
---@param e Either<L1, R1>
---@return Either<L2, R2>
local function bimap(f, g, e)
	return e:match(function(l)
		return Left(f(l))
	end, function(r)
		return Right(g(r))
	end)
end

---@generic Left, Right, R
---@param f fun(l: Left): R
---@param e Either<Left, Right>
---@return Either<R, Right>
local function map_left(f, e)
	return bimap(f, function (r)
    return r
	end, e)
end

---@generic Left, Right, R
---@param f fun(r: Right): R
---@param e Either<Left, Right>
---@return Either<Left, R>
local function map(f, e)
	return bimap(function (l)
	  return l
	end, f, e)
end

---@generic Left, Right, R
---@param f fun(l: Left): R
---@param g fun(r: Right): R
---@param e Either<Left, Right>
---@return R
local function either(f, g, e)
  return e:match(function (l)
    return f(l)
  end, function (r)
    return g(r)
  end)
end

return {
	Left = Left,
	Right = Right,
	match = Either.match,
	is_left = Either.is_left,
	is_right = Either.is_right,
	from_left = from_left,
	from_right = from_right,
	bimap = bimap,
	map_left = map_left,
	map = map,
  either = either,
}

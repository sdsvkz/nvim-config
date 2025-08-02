local MODULE = "data"

local PREFIX = "vkzlib.data."

return {
	either = require(PREFIX .. "either"),
	maybe = require(PREFIX .. "maybe"),
	list = require(PREFIX .. "list"),
	str = require(PREFIX .. "str"),
	table = require(PREFIX .. "table"),
}

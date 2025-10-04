-- Eagerly disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local current_path = vim.fn.stdpath("config")
package.path = current_path .. "/lua/libs/?.lua;" .. current_path .. "/lua/libs/?/init.lua;" .. package.path

local vkzlib = require("vkzlib")

Vkz = {}
Vkz.vkzlib = vkzlib
Vkz.log = {
	t = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
		print = function (text)
		  vim.notify(text, vim.log.levels.TRACE)
		end,
		level = "trace",
		with_traceback = true,
    usecolor = false,
	}),
	d = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
		print = function (text)
		  vim.notify(text, vim.log.levels.DEBUG)
		end,
		level = "debug",
		with_traceback = true,
    usecolor = false,
	}),
	i = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
		print = function (text)
		  vim.notify(text, vim.log.levels.INFO)
		end,
		level = "info",
    usecolor = false
	}),
	w = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
		print = function (text)
		  vim.notify(text, vim.log.levels.WARN)
		end,
		level = "warn",
    usecolor = false,
	}),
	e = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
		print = function (text)
		  vim.notify(text, vim.log.levels.ERROR)
		end,
		level = "error",
    usecolor = false,
	}),
}

-- Setup storage

Vkz.storage = {
	path = vim.fn.stdpath("data") .. "/vkz/",
}

if vim.fn.isdirectory(Vkz.storage.path) == 0 then
	local code = vim.fn.mkdir(Vkz.storage.path, "p")
	if code == 0 then
		Vkz.log.e("Failed to create storage directory in: " .. Vkz.storage.path)
	end
end

-- Run config

require("config")

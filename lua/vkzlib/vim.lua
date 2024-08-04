return {
  augroup = function (prefix, name, opts)
    return vim.api.nvim_create_augroup(prefix .. name, opts or { clear = true })
  end
}

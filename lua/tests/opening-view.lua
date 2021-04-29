local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'floating.nvim', 'lua', 'tests')

require'floating'.open({
  view1 = {enter = true, pin = side, dual = false, name = 'global_myview', on_close = 'windows', relative = 'win'},
  view1_action = function() vim.api.nvim_buf_set_lines(opts.bufnr, 0, 1, true, {tostring(opts.bufnr)}) end


 })
--452

-- require'floating'.open({
--   view1 = {enter = true, dual = true, name = 'global_myview2', pin='topright', on_close = 'buffers'},
--   view1_action = {'open_file', string.format('%s/%s', vim.fn.stdpath('config'), 'init.lua')},
--   view1_two_action = {'open_file', string.format('%s/%s/%s', vim.fn.stdpath('config'), 'lua', 'asd14.lua')}


--  })





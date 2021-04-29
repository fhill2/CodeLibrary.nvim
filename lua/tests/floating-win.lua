local floating = require'floating'
local floating_state = require'floating/state' 


floating.open({
view1 = { dual = false, name = 'codelibrary', on_close = 'windows', relative = 'editor'},
view1_action = function() end
})


 -- REMEMBER ()() on 1st async return function is important, it returns and executes all others down the chain
 -- REMEMBER a.wait_all(unpack(list of async() wrapped functions))
local a = require('packer.async')
local async = a.sync
local await = a.wait



local install = function()

return async(function()


local tasks = { 
  async(function() 
  lo('asd1') 
end), async(function()
lo('asd2') 
end)}

a.wait_all(unpack(tasks))



end)()

end


install()


 -- REMEMBER ()() on 1st async return function is important, it returns and executes all others down the chain
 -- REMEMBER a.wait_all(unpack(list of async() wrapped functions))

local sa = {}


local a = require('packer.async')
local async = a.sync
local await = a.wait

local jobs = require'codelibrary.jobs'

 local output = jobs.output_table()

sa.install = function()

return async(function()
lo('====== NEW RUN =======')
local  install_dir = '/home/f1/install/test'
local url = 'https://github.com/nvim-telescope/telescope.nvim'

local capture_output = {
stdout = jobs.logging_callback(output.err.stdout, output.data.stdout),
stderr = jobs.logging_callback(output.err.stderr, output.data.stderr, nil, repo)
}


local tasks = { 
  async(function()
    lo('trig1')
local dest = string.format('%s/%s', install_dir, math.random(0,55000))
local cmd = string.format('%s %s %s', 'git clone', url, dest)
local r = await(jobs.run(cmd, { capture_output = capture_output}))
lo(output)
lo(r)
lo('trig after1')
return r
end), async(function()
lo('trig2')
local dest = string.format('%s/%s', install_dir, math.random(0,55000))
local cmd = string.format('%s %s %s', 'git clone', url, dest)
local r = await(jobs.run(cmd, { capture_output = capture_output}))
lo('trig after2')
lo(output)
lo(r)
return r
end)}

a.wait_all(unpack(tasks))
lo('after await all')


end)()

end

sa.check = function()
lo(output)
end

return sa
--install()


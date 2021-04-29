local a = require('packer.async')
local async = a.sync
local await = a.wait
local jobs = require'codelibrary.jobs'
local uv = vim.loop

local display = require'codelibrary.display'
local config = require'codelibrary.config'

local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'codelibrary.nvim', 'lua', 'tests')
local fp_counter = 'lua ' .. string.format('%s/%s', root, 'counter-5-test.lua')



local function getenv()
  local job_env = {}
      for k, v in pairs(vim.fn.environ()) do
        if k ~= 'GIT_TERMINAL_PROMPT' then table.insert(job_env, k .. '=' .. v) end
      end

      table.insert(job_env, 'GIT_TERMINAL_PROMPT=0')
      return  { env = job_env }

end

local repos = { 'asdasd', 'another asd' }

 local output = jobs.output_table()


   local installer_opts = {
      capture_output = {
  stdout = jobs.logging_callback(output.err.stdout, output.data.stdout),
      stderr = jobs.logging_callback(output.err.stderr, output.data.stderr)
      },
      timeout = 20,
     options = getenv()
    }

local stdout = vim.loop.new_pipe(false) -- create file descriptor for stdout
  local stderr = vim.loop.new_pipe(false) -- create file descriptor for stdout
  handle = vim.loop.spawn('ls', {
    args = {},
    stdio = {nil,stdout,stderr}
  },
  function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
  end)
  vim.loop.read_start(stdout, onread) -- TODO implement onread handler
  vim.loop.read_start(stderr, onread)





-- local stdin = uv.new_pipe()
-- local stdout = uv.new_pipe()
-- local stderr = uv.new_pipe()
-- print("stdin", stdin)
-- print("stdout", stdout)
-- print("stderr", stderr)
-- local handle, pid = uv.spawn("ls", {
--   stdio = {stdin, stdout, stderr}
-- }, function(code, signal) -- on exit
--   print("exit code", code)
--   print("exit signal", signal)
-- end)
-- print("process opened", handle, pid)
-- uv.read_start(stdout, function(err, data)
--   assert(not err, err)
--   if data then
--     print("stdout chunk", stdout, data)
--   else
--     print("stdout end", stdout)
--   end
-- end)
-- uv.read_start(stderr, function(err, data)
--   assert(not err, err)
--   if data then
--     print("stderr chunk", stderr, data)
--   else
--     print("stderr end", stderr)
--   end
-- end)
-- --uv.write(stdin, "Hello World")
-- uv.shutdown(stdin, function()
--   print("stdin shutdown", stdin)
--   uv.close(handle, function()
--     print("process closed", handle, pid)
--   end)
-- end)


--lo(installer_opts)
-- --lo(installer_opts)
-- local install = function()

-- return async(function()
--   lo(fp_counter)
-- local r = await(jobs.run({[[git clone https://github.com/fhill2/floating.nvim /home/f1/bin]]}, installer_opts))
-- --local r = await(jobs.run({'ls'}, installer_opts))
-- --print(r)
-- lo(output)
-- --r()
-- end)()

-- end


--install()



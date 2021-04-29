local a = require('packer.async')
local async = a.sync
local await = a.wait
local jobs = require'codelibrary.jobs'


local display = require'codelibrary.display'
local config = require'codelibrary.config'


local codelibrary = {}





local function getenv()
  local job_env = {}
      for k, v in pairs(vim.fn.environ()) do
        if k ~= 'GIT_TERMINAL_PROMPT' then table.insert(job_env, k .. '=' .. v) end
      end

      table.insert(job_env, 'GIT_TERMINAL_PROMPT=0')
      return job_env

end

local repos = { 'https://github.com/fhill2/floating.nvim',  'https://github.com/fhill2/LiveTableLogger.nvim' }

 local output = jobs.output_table()


   local installer_opts = {
      capture_output = {
  stdout = jobs.logging_callback(output.err.stdout, output.data.stdout),
      stderr = jobs.logging_callback(output.err.stderr, output.data.stderr, nil, repo)
      },
      timeout = 60,
     options = getenv()
    }






-- tuekka
local results = {}
local function onread(err, data)
  if err then
    -- print('ERROR: ', err)
    -- TODO handle err
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(results, d)
      ::continue::
    end
  end
end



codelibrary.download_single_repo = function(repo)

--local cmd = string.format('git clone %s %s', repo, config.install_dir)



  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)



  -- local function setQF()
  --   lo('setQF trig')
  --   lo(results)
  --   vim.fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
  --   vim.api.nvim_command('cwindow')
  --   local count = #results
  --   for i=0, count do results[i]=nil end -- clear the table for the next search
  -- end


  handle = vim.loop.spawn('git', {
    args = {'clone', repo, string.format('%s/%s', config.install_dir, math.random(0,500))},
    stdio = {nil,stdout,stderr}
  }, function()
    lo('callback trig!!')
    lo(handle)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
 -- setQF()
   handle:close()
    end)
lo('handle is: ')
lo(handle)
  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, onread)
end











codelibrary.install = function()


return async(function()
  lo('=================== NEW RUN ==================')
  local start_time = vim.fn.reltime()
  local results = {}

--local tasks = install_repos({ 'asdasd', 'another asd' }, results)

-- insert async return function into tasks array
local tasks = {}
for k, repo in ipairs(repos) do
table.insert(tasks, async(function()
    --  lo('inline return trig')
      codelibrary.download_single_repo(repo)
  end))
end



lo('before await all')
lo(tasks)

for k, v in pairs(tasks) do
lo(tostring(v))
end

a.wait_all(unpack(tasks))
lo('after await all')



end)()


end







return codelibrary




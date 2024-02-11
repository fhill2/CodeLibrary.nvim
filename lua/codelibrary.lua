local a = require('codelibrary.async')
local async = a.sync
local await = a.wait
local jobs = require'codelibrary.jobs'


--local display = require'codelibrary.display'
local config = require'codelibrary.config'
local prepare = require'codelibrary/prepare'
local display = require'codelibrary/display'
local codelibrary = {}

local all_repos = require'codelibrary/repos'.repos
local all_roots = require'codelibrary/repos'.all_roots




local function getenv()
  local job_env = {}
      for k, v in pairs(vim.fn.environ()) do
        if k ~= 'GIT_TERMINAL_PROMPT' then table.insert(job_env, k .. '=' .. v) end
      end

      table.insert(job_env, 'GIT_TERMINAL_PROMPT=0')
      return job_env

end

local repos = { 'https://github.com/fhill2/floating.nvim', 'https://github.com/fhill2/LiveTableLogger.nvim' }

 local output = jobs.output_table()


   local installer_opts = {
      capture_output = {
  stdout = jobs.logging_callback(output.err.stdout, output.data.stdout),
      stderr = jobs.logging_callback(output.err.stderr, output.data.stderr, nil, repo)

      },
      timeout = 60,
     options = getenv()
    }






-- -- tuekka
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



-- codelibrary.download_single_repo = function(repo)

--local cmd = string.format('git clone %s %s', repo, config.install_dir)


-- local spawn = a.wrap(function(cmd, args, installer_opts)
--   local stdout = vim.loop.new_pipe(false)
--   local stderr = vim.loop.new_pipe(false)



--   -- local function setQF()
--   --   lo('setQF trig')
--   --   lo(results)
--   --   vim.fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
--   --   vim.api.nvim_command('cwindow')
--   --   local count = #results
--   --   for i=0, count do results[i]=nil end -- clear the table for the next search
--   -- end

-- --local dest = string.format('%s/%s', config.install_dir, math.random(0,55000))
-- --local args = { 'clone', repo, dest}
-- --lo(args)
-- lo(cmd)
-- lo(args)

--   handle, pid = vim.loop.spawn('git',
--   {
--     args = args,
--     stdio = {nil,stdout,stderr }
--   }, function()
--     -- lo(pid)
--     -- lo('on exit trig!!')
--     -- lo(results)
--     -- lo(handle)
--     stdout:read_stop()
--     stderr:read_stop()
--     stdout:close()
--     stderr:close()
-- --  setQF()
-- if not handle:is_closing() then handle:close() end
--     end)
-- --lo('handle is: ')
-- --lo(handle)
--   vim.loop.read_start(stdout, onread)
--   vim.loop.read_start(stderr, onread)
-- end)





local function install_plugin(repo, display_win, results)


return async(function()

--local dest = string.format('%s/%s', config.install_dir, math.random(0,55000))
local dest = string.format('%s/%s/%s', config.install_dir, repo.root, repo.name)

--local cmd = 'git'
local cmd = string.format('%s %s %s', 'git clone', repo.url, dest)
--lo(cmd)
--lo(cmd)
local r = await(jobs.run(cmd, installer_opts))
--lo('AFTER JOBS RUN')
--lo('output of r is: ')
--lo(r)
--lo(results)
--lo(output)

display_win:update_task_success(repo)
--end
 --local exit_code = await(spawn(repo, installer_opts))

--  lo('exit code is: ')
-- lo(exit_code)
-- lo(output)
end)
end




local function do_install(results)
  -- init everything
  results = results or {}
--  results.installs = results.installs or {}
--  results.plugins = results.plugins or {}
  local display_win = nil
  local tasks = {}

-- find missing
local missing_repos = {}
for i, repo in ipairs(all_repos) do
  if repo.exists == false then table.insert(missing_repos, i) end
end
lo(missing_repos)

if #missing_repos > 0 then
display_win = display.open()
--display_win:redraw_init()
for _, repo_i in ipairs(missing_repos) do
table.insert(tasks, install_plugin(all_repos[repo_i], display_win, results)) 
end
else
  print('all up to date!') 
end
return tasks, display_win
end











codelibrary.install = function()


return async(function()
  lo('=================== NEW RUN ==================')
  
local results = {}
prepare.create_missing_dirs()
prepare.scan_fs()
prepare.update_missing_repos()
local tasks, display_win = do_install(results)

--   local start_time = vim.fn.reltime()

--lo(tasks)

--lo('before await all')
-- for k,v in pairs(tasks) do
-- v()
-- end
a.wait_all(unpack(tasks))
--lo('after await all')



end)()


end


codelibrary.checkoutput = function()
lo('==================  checkoutput  =========')
 -- lo(output)


 -- lo(results)
  lo(vim.api.nvim_list_chans())
end


return codelibrary















 -- old








-- SCRIPT BELOW HERE

-- local download_single_repo = function(repo, results)

-- -- setup run job config
--  local output = jobs.output_table()
--  local callbacks = {
--       stdout = jobs.logging_callback(output.err.stdout, output.data.stdout),
--       stderr = jobs.logging_callback(output.err.stderr, output.data.stderr, nil, repo)
--     }

--    local installer_opts = {
--       capture_output = callbacks,
--       timeout = 60,
--      -- options = {env = git.job_env}
--     }





-- -- MAIN job running function
-- local r = await(jobs.run('./home/f1/.config/nvim/plugins-me/codelibrary/tests/counter-5-test.lua', installer_opts))
--   lo(r)


--   results[repo] = r
-- lo('async func ran')

-- --end)
-- end



--install()

-- async(function()
-- await(a.main)
-- lo('finished interruptible wait pool!')
-- end)()



--M.asyncGrep('asd')




-- local install_repos = function(repos, results)

--   lo('main install')
--   print('main install')




-- -- local root = string.format('%s/%s/%s/%s/%s', vim.fn.stdpath('config'), 'plugins-me', 'codelibrary.nvim', 'lua', 'tests')
-- -- local fp_counter = string.format('%s/%s', root, 'counter-5-test.lua')






-- return tasks

-- end










-- local tasks = { function() 


-- --return async(function() 
--  -- lo('asd1') 
-- --end)


-- end, function() 


-- --return async(function()
-- --lo('asd2') 
-- --end)


-- end }




local a = require 'async'
local async = a.sync
local uv = vim.loop





-- local async_task_1 = function()
--   return async(function()
--     print('this trig')
--     x = 2
--     return
--   end)
-- end

-- local async_example = function()
-- --  print('got here')
-- return async(function()
-- local u = a.wait(async_task_1)
-- --print('got here22')
-- print(u)
-- end)
-- end


-- async_example()

local timeout = function (ms, callback)
  local timer = uv.new_timer()
  uv.timer_start(timer, ms, 0, function ()
    uv.timer_stop(timer)
    uv.close(timer)
    callback()
  end)
end


-- typical nodejs / luv function
local echo_2 = function (msg1, msg2, callback)
  -- wait 200ms
  timeout(200, function ()
    callback(msg1, msg2)
  end)
end


-- thunkify echo_2
local e2 = a.wrap(echo_2)


local async_tasks_1 = function()
  return a.sync(function ()
    local x, y = a.wait(e2(1, 2))
    print(x, y)
    return x + y
  end)
end


local async_example = function ()
  return a.sync(function ()
    print('async_example ran')
    -- composable, await other async thunks
    local u = a.wait(async_tasks_1())
  --  local v = a.wait(async_tasks_2(3))
    --print(u + v())
  print(u)
  end)
end



async_example()()

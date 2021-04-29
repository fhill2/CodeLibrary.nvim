local floating = require'floating'
local floating_state = require'floating/state' 


local display = {}
local display_mt = {
--all methods here
  valid_display = function(self)
    return self and self.interactive and api.nvim_buf_is_valid(self.buf)
             and api.nvim_win_is_valid(self.win)
  end,




  --- Update the status message of a task in progress
  task_update = vim.schedule_wrap(function(self, plugin, message)
    if not self:valid_display() then return end
    if not self.marks[plugin] then return end
    local line, _ = get_extmark_by_id(self.buf, self.ns, self.marks[plugin])
    self:set_lines(line[1], line[1] + 1, {fmt(' %s %s: %s', config.working_sym, plugin, message)})
    set_extmark(self.buf, self.ns, self.marks[plugin], line[1], 0)
  end),


}


display_mt.__index = display_mt

display.open = function()

disp = setmetatable({}, display_mt)
disp.window = floating.open({
view1 = { dual = false, name = 'codelibrary', on_close = 'windows', relative = 'editor', width = 0.6, height = 0.2},
view1_action = function() end
})


--display.winnr = floating_state.codelibrary.winnr.one_content
--display.bufnr = floating_state.codelibrary.bufnr.one_content





return disp
end




return display


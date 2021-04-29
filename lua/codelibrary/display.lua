

-- data = {
--   all_repos = { {
--       exists = true,
--       mode = "clone",
--       name = "telescope.nvim",
--       root = "lua/telescope"
--     }, {
--       exists = true,
--       mode = "clone",
--       name = "telescope-project.nvim",
--       root = "lua/telescope/extensions"
--     }, {
--       exists = true,
--       mode = "single",
--       name = "telescope-frecency.nvim",
--       root = "lua/telescope/extensions"
--     }, {
--    exists = false,
--       mode = "clone",
--       name = "telescope-fzf-writer.nvim",
--       root = "lua/telescope/extensions"
--     }, {
--       exists = false,
--       mode = "clone",
--       name = "vim-floaterm",
--       root = "vim"
--     },

-- },
-- all_roots = {'lua/telescope', 'lua/telescope/extensions', 'vim'},
-- }

local all_repos = require'codelibrary/repos'.repos
local all_roots = require'codelibrary/repos'.all_roots


local floating_window = require'floating/window'
local floating_state = require'floating/state' 


local display = {}
local display_mt = {
--all methods here
  -- valid_display = function(self)
  --   return self and self.interactive and api.nvim_buf_is_valid(self.buf)
  --            and api.nvim_win_is_valid(self.win)
  -- end,


 redraw_init = vim.schedule_wrap(function(self)
-- reset all buffer
disp.ns = vim.api.nvim_create_namespace('')
vim.api.nvim_buf_clear_namespace(self.buf, self.ns, 0, -1)
vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, {''})
    --  lo(vim.api.nvim_buf_get_extmarks(self.buf, self.ns, 0, -1, {}))
-- render all repos
line=0
    for _, repo in ipairs(data.all_repos) do
 
if repo.exists then 
self.marks[repo.root][repo.name] = line
vim.api.nvim_buf_set_lines(self.buf, line, line, true, { string.format('%s: %s', repo.root, repo.name) })
vim.api.nvim_buf_add_highlight(self.buf, self.ns, 'clExists', line, 0, -1)
else
self.marks[repo.root][repo.name] = line
vim.api.nvim_buf_set_lines(self.buf, line, line, true, { string.format('%s: %s ... installing', repo.root, repo.name) })
vim.api.nvim_buf_add_highlight(self.buf, self.ns, 'clMissing', line, 0, -1)
end
line=line+1
      end
  end),




  -- --- Update the status message of a task in progress
  update_task_success = vim.schedule_wrap(function(self, repo)
--     local repo = data.all_repos[1]

   local line = self.marks[repo.root][repo.name]
      vim.api.nvim_buf_set_lines(self.buf, line, line, true, { string.format('%s: %s ... CLONED', repo.root, repo.name)} )
vim.api.nvim_buf_add_highlight(self.buf, self.ns, 'clSuccess', line, 0, -1)

  end),


}


display_mt.__index = display_mt

display.open = function()
disp = setmetatable({}, display_mt)


floating_window.open({
view1 = { dual = false, name = 'codelibrary', on_close = 'windows', relative = 'editor', width = 0.6, height = 0.2},
view1_action = function() end
})
disp.window = floating_state.views.codelibrary

disp.buf = disp.window.bufnr.one_content
disp.win = disp.window.winnr.one_content

disp.marks = nil
disp.marks = {}
--lo(window)
--lo(disp)

for i,root in ipairs(all_roots) do
disp.marks[root] = nil 
disp.marks[root] = {}
end



 local highlights = { 
      'hi def link clExists   DiffText', -- DiffChange
      'hi def link clMissing DiffDelete', 
      'hi def link clSuccess DevIconBashrc'
    }
    for _, c in ipairs(highlights) do vim.cmd(c) end




--lo(window)

--display.winnr = floating_state.codelibrary.winnr.one_content
--display.bufnr = floating_state.codelibrary.bufnr.one_content





return disp
end




return display




-- old

  -- set_lines = function(self, start_idx, end_idx, lines)
  --   if not self:valid_display() then return end
  --   api.nvim_buf_set_option(self.buf, 'modifiable', true)
  --   api.nvim_buf_set_lines(self.buf, start_idx, end_idx, true, lines)
  --   api.nvim_buf_set_option(self.buf, 'modifiable', false)
  -- end,

  -- --- Start displaying a new task
  -- task_start = vim.schedule_wrap(function(self, repo, message)
  --   lo('task start trig')
  -- --  if not self:valid_display() then return end
  -- --  if self.marks[plugin] then
  --  --   self:task_update(plugin, message)
  --  --   return
  -- --  end
  --   lo('got here')
  --  -- display.status.running = true
  --   self:set_lines(config.header_lines, config.header_lines,
  --                  {fmt(' %s %s: %s', config.working_sym, plugin, message)})
  --   self.marks[repo.root][repo.name] = vim.api.nvim_buf_set_extmark(self.buf, self.ns, nil, config.header_lines, 0)
  --   lo('got to end')
  -- end),

--self.marks[repo.root][repo.name] = vim.api.nvim_buf_get_extmark_by_id(self.buf, self.ns, line, {})
--self.marks[repo.root][repo.name] = vim.api.nvim_buf_set_extmark(self.buf, self.ns, line, 0, {})


--self.marks[repo.root][repo.name] = vim.api.nvim_buf_get_extmark_by_id(self.buf, self.ns, line, {})
--self.marks[repo.root][repo.name] = 
--vim.api.nvim_buf_set_extmark(self.buf, self.ns, line, 0, {})


   --  if not self.marks[repo.root][repo.name] then
    -- self.marks[repo.root][repo.name] = vim.api.nvim_buf_set_extmark(self.buf, self.ns, 0, 0, {})
    -- end


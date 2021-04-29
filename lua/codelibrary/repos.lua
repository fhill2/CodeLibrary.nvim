-- local repos = { 
-- lua = {
--   telescope = {
--     'https://github.com/nvim-telescope/telescope.nvim',
--     extensions = { 
--       'https://github.com/fhill2/floating.nvim', 
--       'https://github.com/fhill2/LiveTableLogger.nvim' 
--       }
--     },
--     'https://github.com/kyazdani42/nvim-tree.lua',
--     'https://github.com/glepnir/galaxyline.nvim',
--   },
-- vim = {
-- 'https://github.com/voldikss/vim-floaterm'
-- }
-- }

local utils = require'codelibrary/utils'

local all_repos = {}
local dirs_to_create = {}
local all_roots = {}

local function create_dirs(root)
    local root = vim.split(root, '/')
    local depth = #root
    local current_root = root[1]
    for i = 1, depth do
        dirs_to_create[current_root] = ''
             current_root = current_root .. '/' .. (root[i + 1] or '')
    end
  end





local function startup()

    local function dl(root, repos)
all_repos[root] = {}
        
       table.insert(all_roots, root)
          create_dirs(root)

        if type(repos) == 'string' then
          local name = utils.normalize_url(repos)
          all_repos[root][name] = {}
            all_repos[root][name] = {root = root, name = name, mode = 'clone', exists = false}
        elseif type(repos) == 'table' then
          
            for _, repo in pairs(repos) do
                if type(repo) == 'string' then
                   local name = utils.normalize_url(repo)
                  all_repos[root][name] = {}
                    all_repos[root][name] = { root = root, name = name, mode = 'clone', exists = false}
                else
                  local name = utils.normalize_url(repo[1])
                  repo.name = name
                  repo.root = root
                  repo.exists = false
                  repo[1] = nil
                    all_repos[root][name] = {}
                    all_repos[root][name] = repo
                end
            end
        end
    end

    -- dl('lua', {
    -- 'https://github.com/kyazdani42/nvim-tree.lua',
    -- 'https://github.com/glepnir/galaxyline.nvim',
    -- })

    dl('lua/telescope', 'https://github.com/nvim-telescope/telescope.nvim')

    dl('lua/telescope/extensions',
       {{'https://github.com/nvim-telescope/telescope-project.nvim', mode = 'clone'}, {'https://github.com/nvim-telescope/telescope-frecency.nvim', mode = 'single'}, 'https://github.com/nvim-telescope/telescope-fzf-writer.nvim'})

    dl('vim', {'https://github.com/voldikss/vim-floaterm'})

end

startup()

return {dirs_to_create = dirs_to_create, repos = all_repos, all_roots = all_roots}

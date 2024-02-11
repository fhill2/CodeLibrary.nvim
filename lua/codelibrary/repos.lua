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
local utils = require 'codelibrary/utils'

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

        table.insert(all_roots, root)
        create_dirs(root)

        if type(repos) == 'string' then
            local name = utils.normalize_url(repos)
            table.insert(all_repos, {root = root, name = name, mode = 'clone', exists = false, url = repos})
        elseif type(repos) == 'table' then

            for _, repo in pairs(repos) do
                if type(repo) == 'string' then
                    local name = utils.normalize_url(repo)
                    table.insert(all_repos, {root = root, name = name, mode = 'clone', exists = false, url = repo})
                else
                    local name = utils.normalize_url(repo[1])
                    repo.name = name
                    repo.root = root
                    repo.exists = false
                    repo.url = repo[1]
                    repo[1] = nil
                    table.insert(all_repos, repo)
                end
            end
        end
    end

    dl('lua', {'https://github.com/kyazdani42/nvim-tree.lua', 'https://github.com/glepnir/galaxyline.nvim'})

    dl('lua/telescope', 'https://github.com/nvim-telescope/telescope.nvim')

-- all extensions on telescope nvim and wiki page
    dl('lua/telescope/extensions', {
        'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
        'https://github.com/nvim-telescope/telescope-github.nvim',
        'https://github.com/nvim-telescope/telescope-project.nvim',
        'https://github.com/nvim-telescope/telescope-fzf-writer.nvim',
        'https://github.com/nvim-telescope/telescope-dap.nvim',
        'https://github.com/nvim-telescope/telescope-arecibo.nvim',
        'https://github.com/nvim-telescope/telescope-bibtex.nvim',
        'https://github.com/nvim-telescope/telescope-media-files.nvim',
        'https://github.com/nvim-telescope/telescope-z.nvim',
        'https://github.com/nvim-telescope/telescope-node-modules.nvim',
        'https://github.com/nvim-telescope/telescope-ghq.nvim',
        'https://github.com/nvim-telescope/telescope-cheat.nvim',
        'https://github.com/nvim-telescope/telescope-snippets.nvim',
        'https://github.com/nvim-telescope/telescope-symbols.nvim',
        'https://github.com/nvim-telescope/telescope-packer.nvim',
        'https://github.com/nvim-telescope/telescope-vimspector.nvim',
        -- from wiki extensions page
        'https://github.com/nvim-telescope/telescope-frecency.nvim',
        'https://github.com/nvim-telescope/telescope-z.nvim',
        'https://github.com/GustavoKatel/telescope-asynctasks.nvim',
        'https://github.com/bi0ha2ard/telescope-ros.nvim',
        'https://github.com/fhill2/telescope-ultisnips.nvim',
        'https://github.com/luc-tielen/telescope_hoogle',
        'https://github.com/brandoncc/telescope-harpoon.nvim',
        'https://github.com/TC72/telescope-tele-tabby.nvim',
        'https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim',
        'https://github.com/fannheyward/telescope-coc.nvim',
        'https://github.com/dhruvmanila/telescope-bookmarks.nvim',
      })






    dl('vim', {'https://github.com/voldikss/vim-floaterm'})

    dl('dotfiles-lua-linux', {'https://github.com/gf3/dotfiles', 'https://github.com/jameswalmsley/dotfiles', 'https://github.com/p00f/dotfiles'})

    dl('shell', {'https://github.com/jarun/nnn'})

-- 'agkozak/zhooks'
-- 'zsh-users/zsh-syntax-highlighting'
-- 'NullSense/fuzzy-sys'
-- "denysdovhan/spaceship-prompt"
-- 'skywind3000/z.lua'
-- zplug "marlonrichert/zsh-edit"
-- # # zplug 'lincheney/fzf-tab-completion'

    dl('dotfiles', {'https://github.com/junegunn/dotfiles'})

end

startup()

return {dirs_to_create = dirs_to_create, repos = all_repos, all_roots = all_roots}

local prepare = {}
local uv = vim.loop

local config = require 'codelibrary/config'
local pscan = require 'plenary/scandir'
local utils = require'codelibrary/utils'

local all_repos = require'codelibrary/repos'.repos
local all_roots = require'codelibrary/repos'.all_roots

local dirs_keys_to_create = require'codelibrary/repos'.dirs_to_create
local dirs_to_create = {}

local function dirs_k_to_v()
dirs_to_create = {}
for dir,_ in pairs(dirs_keys_to_create) do
table.insert(dirs_to_create, dir)
end
end
dirs_k_to_v()


  local all_fs = {}

--local install_dir = '/home/f1/install2' -- config.install_dir


-- TARGET: scan current fs state into table (then table can be rendered to ui)
prepare.scan_fs = function()
  all_fs = {}
 

    for _, root in ipairs(all_roots) do
        local single_scan_result = {}

             local filepath = config.install_dir .. '/' .. root
        --  lo('=== NEW SCAN ===' .. filepath)
        -- lo(filepath)
        -- check if exists first
        local r = uv.fs_stat(filepath, nil)
        if r == nil then
            print('fs_scan cant scan directory doesnt exist')

        else

            pscan.scan_dir(filepath, {
                hidden = false,
                add_dirs = true,
                depth = 1,
                on_insert = function(result, type)
         
                    if uv.fs_stat(result .. '/.git', nil) then 
                   --   local utils = 'codelibrary/utils'

                      local repo_name = utils.normalize_url(result)
                      table.insert(all_fs, {
                        name = repo_name,
                        root = root
                      })

                    end
                    return
                end
            })

        end -- end assert loop

      --  table.insert(all_fs, single_scan_result)
    end -- end FOR LOOP
  --  dump(all_fs)
    return all_fs
end

prepare.update_missing_repos = function()
--prepare.scan_fs()

local missing_repos = {}

-- repo.exists = true if repo already found in filesystem

for _,repo in ipairs(all_repos) do
  for _, fs in ipairs(all_fs) do
      if repo.name == fs.name and repo.root == fs.root then repo.exists = true end
  end
end
lo(all_repos)
lo(all_fs)


-- for _, repo in ipairs(all_repos) do
-- if not repo.exists then table.insert(missing_repos, repo) end
-- end

--return missing_repos
end






prepare.create_missing_dirs = function()
local dirs = dirs_to_create
--lo(dirs_to_create)
    --  TARGET: filesystem, creates folders based on repo table if they dont exist
    local source_stats = uv.fs_stat(config.install_dir, nil)
    for i, relpath in ipairs(dirs_to_create) do
        local filepath = string.format('%s/%s', install_dir, relpath)

        local r = uv.fs_stat(filepath, nil)
        if r == nil then
            local r = uv.fs_mkdir(filepath, source_stats.mode, nil)
            if r == nil then assert(false, 'couldnt create folder: ' .. filepath) end
        end

    end

end

prepare.all = function()
    lo('======= NEW RUN ========')
     prepare.scan_fs()
    prepare.create_missing_dirs()
   
end

return prepare

---- old



-- OLD FIND MISSING REPOS
-- local missing_plugins = {}

-- for _, root in pairs(all_repos) do
-- for _, repo in pairs(root) do
-- vim.tbl_map(function()
-- if all_fs[repo.root] == nil then 
--   missing_plugins[repo.root] = {}
--   missing_plugins[repo.root][repo.name] = repo 
--   return end


-- if all_fs[repo.root][repo.name] == nil then 
--   missing_plugins[repo.root] = {}
--   missing_plugins[repo.root][repo.name] = repo 
--   return end

-- lo('DIDNT ADD:')
-- lo(repo)
-- repo.exists = true
-- --table.insert(missing_plugins,repo)
-- return
-- end, root)
-- end
---- END OLD FIND MISSING REPOS


-- TARGET: repo config table
-- prepare.list_all_repo_dirs = function(root)

--     -- local roots_to_add_keys = {}

--     -- for _, repo in ipairs(all_repos) do
--     local root = vim.split(root, '/')
--     local depth = #root
--     local current_root = root[1]
--     for i = 1, depth do
--         if not i == depth then
--             joined = current_root .. '/' .. root[i + 1]
--     end

--     -- local fp_undup = {}
--     -- for k,v in pairs(fp_k_undup) do table.insert(fp_undup, k) end

--     -- all_roots = fp_undup

--     -- return fp_undup
-- end



-- TARGET: repo table -- lists each repo in a list like table
-- local function list_all_repo_paths(repos, prev_path)
--    for current_t, next_t in pairs(repos) do
--         if type(next_t) == 'table' then

--                 if not prev_path then
--                   prev_path = current_t
--                   else
--                 prev_path = string.format('%s/%s', prev_path, current_t)
--               end

--                 table.insert(all_repo_paths, prev_path)
--             list_all_repo_paths(next_t, prev_path)
--         elseif type(next_t) == 'string' then

--           lo('outside table: ' .. prev_path .. ': ' .. next_t)
--         end

--     end

-- end

-- for current_t, next_t in pairs(repos) do
--       if type(next_t) == 'table' then

--           if not prev_path then
--               prev_path = current_t
--           else

--               prev_path = string.format('%s/%s', prev_path, current_t)
--           end

--           table.insert(all_repo_paths, prev_path)
--           list_all_repo_dirs(next_t, prev_path)
--       end

--   end

-- local function list_all_install_dir_paths()
--  local data = {}

-- end


local utils = {}


function utils:make_relative()
  self.filename = clean(self.filename)
  cwd = clean(F.if_nil(cwd, self._cwd, cwd))

  if self.filename:sub(1, #cwd) == cwd then
    if #self.filename == #cwd then
      self.filename = "."
    else
      -- skip path separator, unless cwd is root
      local offset = 2
      if cwd:sub(-1) == path.sep then
        offset = 1
      end
      self.filename = self.filename:sub(#cwd + offset, -1)
    end
  end

  return self.filename
end


function utils.normalize_url(url)
local _, slash_amt = url:gsub('/', '')

if slash_amt > 1 then
url = vim.split(url, '/')
--url = url[#url - 1] .. '/' .. url[#url]
url = url[#url]
end

return url
end


return utils

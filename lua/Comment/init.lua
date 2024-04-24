
local comment = require("Comment.lib.comment")

local M = {}


M.setup = function(opts)
  opts = opts or {key = "§"}

  if not opts["remap_opts"] then 
    opts["remap_opts"] = {silent = true, noremap = true}
  end 

  local comments_group = vim.api.nvim_create_augroup("MyComments", {clear = true})

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(event)
      comment.set_keymaps(opts.key, event.match, opts.remap_opts)
    end,
    group = comments_group 
  })
end 
return M

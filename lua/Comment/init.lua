
local comment = require("Comment.lib.comment")

local M = {}


M.setup = function(config)
  print("eeeeeeeeeeeee")
  config = config or {key = "§"}

  if not config["remap_opts"] then 
    config["remap_opts"] = {silent = true, noremap = true}
  end 

  local comments_group = vim.api.nvim_create_augroup("MyComments", {clear = true})

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(event)
      comment.set_keymaps(config.key, event.match, config.remap_opts)
    end,
    group = comments_group 
  })
end 
return M

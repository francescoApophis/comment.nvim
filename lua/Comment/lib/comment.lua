local M = {}
local comment_tables = require("Comment.lib.comment_tables")

-- used in comment_or_undo_range() to exit visual mode 
local esc_key = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

---@param comment_pattern string | string[]
---@param row_from_range number | nil  #Line-row-num coming from range of selected lines 
---@return (number | number | string)[]
M.is_commented_out = function (comment_pattern, row_from_range)
  local row = row_from_range or vim.fn.getcurpos(0)[2] 
  local curr_line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] 
  comment_pattern = (type(comment_pattern) == "table" and comment_pattern[1]) or comment_pattern

  return {
    -- '^' must begin; '%s-' zero or more space and comment
    string.find(curr_line, "^%s-" .. comment_pattern .. "[%w|%p]-", 1), 
    row, 
    curr_line
  }
end  


-- Remove comment from string line retrieved through vim.api; edited line is inserted back by 'comment_or_undo_line()'
---@param comment_pattern string | string[]
---@param line string
---@return string  
M.remove_comment_from_str_line = function(comment_pattern, line)
  if type(comment_pattern) == "table" then 
    local uncommented_line = string.gsub(line, comment_pattern[1], "", 1)
    return string.gsub(uncommented_line, comment_pattern[2], "", 1)
  end 

  return string.gsub(line, comment_pattern, "", 1)
end 

---@param comment string | string[]
---@param comment_pattern string | string[]
---@param row_from_range string | string[] 
---@return nil  
M.comment_or_undo_line = function(comment, comment_pattern, row_from_range)
  local is_line_commented, row, line = unpack(M.is_commented_out(comment_pattern, row_from_range))

  if is_line_commented then
    local uncommented_line = M.remove_comment_from_str_line(comment_pattern, line)
    vim.api.nvim_buf_set_lines(0, row - 1, row, true, {uncommented_line})

  else 
    local first_char_col = string.find(line, "[%w|%p]") -- 'w' -> alphanum char, 'p' -> punctuation chars
    if not first_char_col then return end 
    
    first_char_col = first_char_col - 1
    local last_char_col = string.find(vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1], "[%S]$") 

    if type(comment) ~= "table" then 
        vim.api.nvim_buf_set_text(0, row - 1, first_char_col, row - 1, first_char_col, {comment})
    else 
      vim.api.nvim_buf_set_text(0, row - 1, last_char_col, row - 1, last_char_col, {comment[2]})
      vim.api.nvim_buf_set_text(0, row - 1, first_char_col, row - 1, first_char_col, {comment[1]})
    end 
  end
end 


-- Comment or uncomment lines selected in Visual-Line mode
---@param comment string | string[]
---@param comment_pattern string | string[]
---@return nil 
M.comment_or_undo_range = function(comment, comment_pattern)   
  -- marks are available after visual mode is exited 
  -- schedule() because the rest of the code is called too early 
  vim.api.nvim_feedkeys(esc_key, "v", false)
  vim.schedule(function()
    local start_row = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_row   = vim.api.nvim_buf_get_mark(0, ">")[1]

    for row_from_range=start_row, end_row do 
      M.comment_or_undo_line(comment, comment_pattern, row_from_range)
    end 
  end)
end 


---@param event_match string
---@return string | nil
M.get_file_ext = function(event_match)
  return string.match(event_match, "%a+$") 
end 


---@param key string
---@event_match string 
---@param opts table | nil Check :help vim.keymap.set()
---@return nil
M.set_keymaps = function(key, event_match, opts)
  opts = opts or {}

  local file_ext = M.get_file_ext(event_match)
  local comment = comment_tables.comments[file_ext] 
  local comment_pattern = comment_tables.comments_lua_regex_pattern[file_ext] 
  if comment then 
    vim.keymap.set("n", key, function() M.comment_or_undo_line(comment, comment_pattern) end, opts)
    vim.keymap.set("v", key, function() M.comment_or_undo_range(comment, comment_pattern) end, opts)
  else 
    M.delete_keymaps(key)
  end 
end 


---@param key string 
---@return nil
M.delete_keymaps = function(key)
  for _, map in ipairs(vim.api.nvim_get_keymap("n")) do 
    if map.lhs == key then 
      vim.api.nvim_del_keymap("n", key) 
    end 
  end 

  for _, map in ipairs(vim.api.nvim_get_keymap("v")) do 
    if map.lhs == key then 
      vim.api.nvim_del_keymap("v", key) 
    end 
  end 
end 


return M 

local M = {}

M.comments = {
  py  = "# ",
  c   = "// ",
  js  = "// ", 
  lua = "-- ", 
  vim = "\" ",
  html = {"<!-- ", " -->"},
  css = {"/* ", " */"},
}

M.comments_lua_regex_pattern = {
  -- '-' is magic character; for lua and html's comment 
  -- it needs to be escaped with '%' 
  -- %s -> literal space char 
  py  = "#%s",
  c   = "//%s",
  js  = "//%s", 
  lua = "%-%-%s", 
  vim = "\"%s",
  html = {"<%!%-%-%s", "%s-%-%->"},
  css = {"/%*%s", "%s%*/"},
}


return M 

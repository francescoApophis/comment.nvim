local M = {}

M.comments = {
  asm = ";; ",
  c   = "// ",
  cpp = "// ",
  cs  = "// ",
  csproj = "// ",
  fren = "// ",
  h   = "// ",
  rs  = "// ",
  rlib = "// ",
  go = "// ",
  java = "// ",
  class = "// ",
  jar = "// ", 
  jmod = "// ",
  js  = "// ", 
  lox = "// ",
  py  = "# ",
  makefile = "# ",
  lua = "-- ", 
  sql = "-- ", 
  vim = "\" ",
  html = {"<!-- ", " -->"},
  css = {"/* ", " */"},
}

M.comments_lua_regex_pattern = {
  -- '-' is magic character; for lua and html's comment 
  -- it needs to be escaped with '%' 
  -- %s -> literal space char 
  asm = ";;%s",
  c   = "//%s",
  cpp = "//%s",
  cs = "//%s",
  csproj = "//%s",
  h = "//%s",
  rs = "//%s",
  rslib = "//%s",
  go = "//%s",
  java = "//%s",
  class = "//%s",
  jar = "//%s",
  jmod = "//%s",
  js  = "//%s", 
  lox  = "//%s", 
  fren = "//%s", 
  py  = "#%s",
  makefile = "#%s",
  lua = "%-%-%s", 
  sql = "%-%-%s", 
  vim = "\"%s",
  html = {"<%!%-%-%s", "%s-%-%->"},
  css = {"/%*%s", "%s%*/"},
}


return M 

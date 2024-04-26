# Comment.nvim 

Comment.nvim is a very modest and simple plugin for commenting and uncommenting 
code I built mainly for myself.
For this reason by default it supports comments 
for:

  - Python 
  - C
  - C++
  - C#
  - Golang
  - Rust
  - Java
  - Javascript 
  - HTML
  - CSS
  - Lua
  - Sql

Some of them are languages/tools I'm using or have used, others I plan to use 
maybe in the future. So sorry if one some languages are missing.

## Usage 
You use the *SAME* key or keys-combination for commenting/uncommenting **only** in  
**Normal** mode (edit current line) and **Visual/V-Line** mode (edit range of selected 
lines). 

The plugin ***doesn't handle block comments***. So when commenting mulitple lines this
is always the result: 
```css
body {
    /* width: 500px; */
    /* height: 400px; */
    /* background-color: 'black'; */
}

div {
    /* not this */ 
    /*
    width: 10px;
    height: 20px;
    display: flex;
    */
}
```

And that's it, no other functionality, it's nothing fancy really. 

## Installation 
Keep in mind that I know nothing about plugin managers. I ***think*** (not sure)
the plugin  would work at the moment only with **Lazy.nvim**. 

```lua
return {
    "francescoApophis/comment.nvim",
    lazy = false,

    -- this is not needed if you plan to use the default keymap 'gc'
    config = function()
        require("Comment").setup({
            key = "" -- your key or keys-combination, <leader> works as well
        })
    end 
}
```


if os.getenv("WORK") then
  Work = true
else
  Work = false
end

require("options")
require("keybindings")
require("abbreviations")
require("autocmd")

require("plugins")

require("colorscheme")
require("completion")
require("languages")

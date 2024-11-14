local Lang = require("util.lang")
local fn = require("util.fn")

return Lang.makeSpec({
  Lang.addFormatter({ rust = { "rustfmt" } }, false),
  Lang.addTreesitterFiletypes({ "rust", "ron", "toml" }),
  Lang.addLspServer("rust_analyzer", true),
  Lang.addLspServer("taplo"),
  Lang.addDap("codelldb"),
})

local lang = require("util.lang")

return lang.makeSpec({
  lang.addFormatter({ elixir = { "mix" } }, false),
  lang.addLspServer("elixirls"),
  lang.addTreesitterFiletypes({ "elixir" }),
  -- {
  --   "elixir-editors/vim-elixir",
  -- },
})

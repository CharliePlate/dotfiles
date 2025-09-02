local Lang = require("util.lang")

return Lang.makeSpec({
  Lang.addFormatter({ vue = { "prettierd" } }),
  Lang.addLspServer("vue_ls"),
  Lang.addLspServer("vtsls"),
  Lang.addTreesitterFiletypes({ "vue" }),
})

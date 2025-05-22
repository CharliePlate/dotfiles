local Lang = require("util.lang")

return Lang.makeSpec({
  Lang.addFormatter({ vue = { "prettierd" } }),
  Lang.addLspServer("vue_ls"),
  Lang.addTreesitterFiletypes({ "vue" }),
})

local Lang = require("util.lang")

return Lang.makeSpec({
  Lang.addLspServer("omnisharp"),
  Lang.addTreesitterFiletypes({ "c_sharp" }),
})

local configurations = {}

local ports = {
  ["Answers"] = 9230,
  ["Public API"] = 9202,
  ["Web API"] = 9229,
  ["Worker"] = 9231,
}

for name, port in pairs(ports) do
  table.insert(configurations, {
    lang = "typescript",
    type = "pwa-node",
    request = "attach",
    port = port,
    name = "Attach to " .. name,
    -- sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    resolveSourceMapLocations = {
      "${workspaceFolder}/**/*.ts",
      "${workspaceFolder}/../pg-isomorphic/src/**/*.ts",
      "${workspaceFolder}/../pg-shared/src/**/*.ts",
      "${workspaceFolder}/**/*.js",
      "!**/node_modules/**",
    },
    remoteRoot = "${workspaceFolder}",
    localRoot = "${workspaceFolder}",
  })
end

table.insert(configurations, {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = false,
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = false,
  },
})

return configurations

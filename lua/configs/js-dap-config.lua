local dap = require "dap"
if not dap.adapters["pwa-node"] then
  require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      -- 💀 Make sure to update this path to point to your installation
      args = {
        "/home/ogunleye/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
end
if not dap.adapters["node"] then
  dap.adapters["node"] = function(cb, config)
    if config.type == "node" then
      config.type = "pwa-node"
    end
    local nativeAdapter = dap.adapters["pwa-node"]
    if type(nativeAdapter) == "function" then
      nativeAdapter(cb, config)
    else
      cb(nativeAdapter)
    end
  end
end

local js_filetypes = { "typescript", "javascript" }

-- local vscode = require "dap.ext.vscode"
-- vscode.type_to_filetypes["node"] = js_filetypes
-- vscode.type_to_filetypes["pwa-node"] = js_filetypes

for _, language in ipairs(js_filetypes) do
  if not dap.configurations[language] then
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        --runtimeExecutable = "node",
      },
      -- {
      --   type = "pwa-node",
      --   request = "attach",
      --   name = "Attach",
      --   processId = require("dap.utils").pick_process,
      --   cwd = "${workspaceFolder}",
      -- },
      -- {
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Launch File(pwa-node with ts-node!!)",
      --   cwd = vim.fn.getcwd(),
      --   runtimeExecutable = "ts-node",
      --   args = { "${file}" },
      --   sourceMaps = true,
      --   protocol = "inspector",
      --   skipFiles = { "<node_internals>/**", "node_modules/**" },
      --   resolveSourceMapLocations = {
      --     "${workspaceFolder}/**",
      --     "!**/node_modules/**",
      --   },
      --},
    }
  end
end

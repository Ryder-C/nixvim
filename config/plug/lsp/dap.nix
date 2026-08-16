{pkgs, ...}: let
  codelldb = pkgs.vscode-extensions.vadimcn.vscode-lldb;
  codelldbPath = "${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
  liblldbExt =
    if pkgs.stdenv.isDarwin
    then "dylib"
    else "so";
  liblldbPath = "${codelldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.${liblldbExt}";
in {
  extraPackages = [codelldb];

  plugins = {
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "◆";
          texthl = "DapBreakpointCondition";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "▶";
          texthl = "DapStopped";
        };
        dapBreakpointRejected = {
          text = "●";
          texthl = "DapBreakpointRejected";
        };
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.35;
              }
              {
                id = "breakpoints";
                size = 0.15;
              }
              {
                id = "stacks";
                size = 0.25;
              }
              {
                id = "watches";
                size = 0.25;
              }
            ];
            position = "left";
            size = 50;
          }
          {
            elements = [
              {
                id = "repl";
                size = 0.5;
              }
              {
                id = "console";
                size = 0.5;
              }
            ];
            position = "bottom";
            size = 12;
          }
        ];
      };
    };

    dap-virtual-text = {
      enable = true;
      settings = {
        commented = true;
        virt_text_pos = "eol";
      };
    };
  };

  extraConfigLua = ''
    local dap = require("dap")
    local dapui = require("dapui")

    -- Auto open/close dap-ui on session start/end
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- codelldb as a plain nvim-dap adapter (rustaceanvim wires its own copy
    -- internally; this one is for hand-rolled configurations).
    dap.adapters.codelldb = {
      type = "server",
      port = "''${port}",
      executable = {
        command = "${codelldbPath}",
        args = { "--liblldb", "${liblldbPath}", "--port", "''${port}" },
      },
    }

    -- Debug a leetgo-generated solution against a single testcase.
    -- The solution binary reads its input from stdin, so stdin is redirected
    -- from <cargo-root>/.dbg-input (populated by the repo's scripts/dbg-case).
    -- codelldb's `stdio` launch field is silently ignored, hence the lldb
    -- setting via preRunCommands.
    local function leetcode_debug()
      local dir = vim.fn.expand("%:p:h")
      local slug = vim.fn.fnamemodify(dir, ":t"):gsub("^%d+%.", "")
      local root = vim.fn.fnamemodify(dir, ":h:h")
      local input = root .. "/.dbg-input"

      if vim.fn.filereadable(root .. "/Cargo.toml") == 0 then
        vim.notify("no Cargo.toml at " .. root, vim.log.levels.ERROR)
        return
      end
      if vim.fn.filereadable(input) == 0 then
        vim.notify("no .dbg-input; run scripts/dbg-case <qid> <n>", vim.log.levels.ERROR)
        return
      end

      local out = vim.fn.system({
        "cargo", "build", "--manifest-path", root .. "/Cargo.toml", "--bin", slug,
      })
      if vim.v.shell_error ~= 0 then
        vim.notify(out, vim.log.levels.ERROR)
        return
      end

      dap.run({
        name = "leetcode: " .. slug,
        type = "codelldb",
        request = "launch",
        program = root .. "/target/debug/" .. slug,
        cwd = root,
        stopOnEntry = false,
        preRunCommands = { "settings set target.input-path " .. input },
      })
    end

    vim.api.nvim_create_user_command("LeetDebug", leetcode_debug, {
      desc = "Debug leetgo solution with .dbg-input on stdin",
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>d";
      action = "+debug";
      options.desc = "+debug";
    }

    # Run / control
    {
      mode = "n";
      key = "<F5>";
      action = "<cmd>lua require'dap'.continue()<CR>";
      options.desc = "Debug: Continue / Start";
    }
    {
      mode = "n";
      key = "<S-F5>";
      action = "<cmd>lua require'dap'.terminate()<CR>";
      options.desc = "Debug: Terminate";
    }
    {
      mode = "n";
      key = "<F10>";
      action = "<cmd>lua require'dap'.step_over()<CR>";
      options.desc = "Debug: Step Over";
    }
    {
      mode = "n";
      key = "<F11>";
      action = "<cmd>lua require'dap'.step_into()<CR>";
      options.desc = "Debug: Step Into";
    }
    {
      mode = "n";
      key = "<S-F11>";
      action = "<cmd>lua require'dap'.step_out()<CR>";
      options.desc = "Debug: Step Out";
    }

    # <leader>d* leader maps
    {
      mode = "n";
      key = "<leader>dc";
      action = "<cmd>lua require'dap'.continue()<CR>";
      options.desc = "Continue / Start";
    }
    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>lua require'dap'.toggle_breakpoint()<CR>";
      options.desc = "Toggle Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dB";
      action = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>";
      options.desc = "Conditional Breakpoint";
    }
    {
      mode = "n";
      key = "<leader>dp";
      action = "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>";
      options.desc = "Log Point";
    }
    {
      mode = "n";
      key = "<leader>do";
      action = "<cmd>lua require'dap'.step_over()<CR>";
      options.desc = "Step Over";
    }
    {
      mode = "n";
      key = "<leader>di";
      action = "<cmd>lua require'dap'.step_into()<CR>";
      options.desc = "Step Into";
    }
    {
      mode = "n";
      key = "<leader>dO";
      action = "<cmd>lua require'dap'.step_out()<CR>";
      options.desc = "Step Out";
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = "<cmd>lua require'dap'.repl.open()<CR>";
      options.desc = "Open REPL";
    }
    {
      mode = "n";
      key = "<leader>dl";
      action = "<cmd>lua require'dap'.run_last()<CR>";
      options.desc = "Run Last";
    }
    {
      mode = "n";
      key = "<leader>dt";
      action = "<cmd>lua require'dap'.terminate()<CR>";
      options.desc = "Terminate";
    }
    {
      mode = "n";
      key = "<leader>du";
      action = "<cmd>lua require'dapui'.toggle()<CR>";
      options.desc = "Toggle UI";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>dh";
      action = "<cmd>lua require'dap.ui.widgets'.hover()<CR>";
      options.desc = "Hover Variables";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>de";
      action = "<cmd>lua require'dapui'.eval()<CR>";
      options.desc = "Evaluate Expression";
    }

    # Rust-specific (rustaceanvim)
    {
      mode = "n";
      key = "<leader>dR";
      action = "<cmd>RustLsp debuggables<CR>";
      options.desc = "Rust: Debuggables";
    }
    {
      mode = "n";
      key = "<leader>dn";
      action = "<cmd>RustLsp runnables<CR>";
      options.desc = "Rust: Runnables";
    }
    {
      mode = "n";
      key = "<leader>dL";
      action = "<cmd>LeetDebug<CR>";
      options.desc = "Rust: Debug leetcode testcase";
    }
  ];
}

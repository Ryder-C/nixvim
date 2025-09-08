{
  lib,
  config,
  ...
}: {
  plugins.mini.modules.pick = {};

  keymaps = lib.mkIf (config.plugins.mini.enable && lib.hasAttr "pick" config.plugins.mini.modules) [
    {
      mode = "n";
      key = "<leader><space>";
      action.__raw = ''
        function()
          MiniPick.builtin.files()
        end
      '';
      options = {
        desc = "Find project files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action.__raw = ''
        function()
          local fn = MiniPick.builtin.grep_live or MiniPick.builtin.grep
          fn()
        end
      '';
      options = {
        desc = "Find text";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action.__raw = ''
        function()
          MiniPick.builtin.oldfiles()
        end
      '';
      options = {
        desc = "Recent";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action.__raw = ''
        function()
          MiniPick.builtin.buffers()
        end
      '';
      options = {
        desc = "Buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<C-p>";
      action.__raw = ''
        function()
          local inside = vim.fn.system('git rev-parse --is-inside-work-tree')
          if vim.v.shell_error == 0 then
            local items = vim.fn.systemlist({'git', 'ls-files'})
            MiniPick.start({
              source = { items = items },
              prompt = 'Git files',
              action = function(item)
                if not item or not item.text then return end
                vim.cmd.edit(item.text)
              end,
            })
          else
            MiniPick.builtin.files()
          end
        end
      '';
      options = {
        desc = "Search project files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sh";
      action.__raw = ''
        function()
          MiniPick.builtin.help()
        end
      '';
      options = {
        desc = "Help pages";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>:";
      action.__raw = ''
        function()
          local items = {}
          local histnr = vim.fn.histnr('cmd')
          for i = histnr, 1, -1 do
            local cmd = vim.fn.histget('cmd', i)
            if cmd ~= "" then table.insert(items, cmd) end
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Command history',
            action = function(item)
              if item and item.text then vim.cmd(item.text) end
            end,
          })
        end
      '';
      options = {
        desc = "Command History";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>b";
      action.__raw = ''
        function()
          MiniPick.builtin.buffers()
        end
      '';
      options = {
        desc = "+buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fe";
      action.__raw = ''
        function()
          (MiniPick.builtin.oldfiles)()
        end
      '';
      options = {
        desc = "Resume (oldfiles)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gc";
      action.__raw = ''
        function()
          local lines = vim.fn.systemlist({'git', 'log', '--pretty=format:%h %s', '--decorate'})
          MiniPick.start({
            source = { items = lines },
            prompt = 'Git commits',
            action = function(item)
              if not item or not item.text then return end
              local sha = item.text:match('^([0-9a-fA-F]+)')
              if not sha then return end
              vim.cmd('tabnew')
              vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile')
              vim.cmd('read !git show '..sha)
              vim.cmd('normal! gg')
            end,
          })
        end
      '';
      options = {
        desc = "Commits";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action.__raw = ''
        function()
          local lines = vim.fn.systemlist({'git', 'status', '-s'})
          MiniPick.start({
            source = { items = lines },
            prompt = 'Git status',
            action = function(item)
              if not item or not item.text then return end
              local path = item.text:match('->%s*(.+)$') or item.text:match('%s+(.+)$')
              if path then vim.cmd.edit(path) end
            end,
          })
        end
      '';
      options = {
        desc = "Status";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sa";
      action.__raw = ''
        function()
          local acs = vim.api.nvim_get_autocmds({})
          local items = {}
          for _, ac in ipairs(acs) do
            local desc = string.format('%s %-12s %s %s', ac.group or "", ac.event or "", ac.pattern or "", ac.desc or "")
            table.insert(items, desc)
          end
          MiniPick.start({ source = { items = items }, prompt = 'Autocommands' })
        end
      '';
      options = {
        desc = "Auto Commands";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sb";
      action.__raw = ''
        function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local items = {}
          for i, l in ipairs(lines) do
            table.insert(items, string.format('%5d  %s', i, l))
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Buffer lines',
            action = function(item)
              if not item or not item.text then return end
              local lnum = tonumber(item.text:match('^%s*(%d+)')) or 1
              vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            end,
          })
        end
      '';
      options = {
        desc = "Buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sc";
      action.__raw = ''
        function()
          local items = {}
          local histnr = vim.fn.histnr('cmd')
          for i = histnr, 1, -1 do
            local cmd = vim.fn.histget('cmd', i)
            if cmd ~= "" then table.insert(items, cmd) end
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Command history',
            action = function(item)
              if item and item.text then vim.cmd(item.text) end
            end,
          })
        end
      '';
      options = {
        desc = "Command History";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sC";
      action.__raw = ''
        function()
          local cmds = vim.api.nvim_get_commands({})
          local items = {}
          for name, _ in pairs(cmds) do table.insert(items, name) end
          table.sort(items)
          MiniPick.start({
            source = { items = items },
            prompt = 'Commands',
            action = function(item)
              if item and item.text then vim.cmd(item.text) end
            end,
          })
        end
      '';
      options = {
        desc = "Commands";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sD";
      action.__raw = ''
        function()
          local diags = vim.diagnostic.get(nil)
          local items = {}
          for _, d in ipairs(diags) do
            local buf = vim.api.nvim_buf_get_name(d.bufnr)
            local msg = string.format('%s:%d:%d %s', vim.fn.fnamemodify(buf, ':.'), d.lnum + 1, d.col + 1, d.message)
            table.insert(items, { text = msg, _loc = { bufnr = d.bufnr, lnum = d.lnum + 1, col = d.col } })
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Diagnostics (workspace)',
            action = function(item)
              if not item or not item._loc then return end
              vim.api.nvim_set_current_buf(item._loc.bufnr)
              vim.api.nvim_win_set_cursor(0, { item._loc.lnum, item._loc.col })
            end,
          })
        end
      '';
      options = {
        desc = "Workspace diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sH";
      action.__raw = ''
        function()
          local groups = vim.fn.getcompletion("", 'highlight')
          MiniPick.start({
            source = { items = groups },
            prompt = 'Highlight groups',
            action = function(item)
              if item and item.text then vim.cmd('help highlight-groups') end
            end,
          })
        end
      '';
      options = {
        desc = "Search Highlight Groups";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sk";
      action.__raw = ''
        function()
          local modes = { 'n', 'v', 'i', 'x', 'o', 't' }
          local items = {}
          for _, m in ipairs(modes) do
            for _, km in ipairs(vim.api.nvim_get_keymap(m)) do
              local desc = km.lhs .. ' -> ' .. (km.rhs or (km.callback and '<lua>') or "") .. '  (' .. m .. ')'
              table.insert(items, desc)
            end
          end
          MiniPick.start({ source = { items = items }, prompt = 'Keymaps' })
        end
      '';
      options = {
        desc = "Keymaps";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sM";
      action.__raw = ''
        function()
          local lines = vim.fn.systemlist({'apropos', '.'})
          MiniPick.start({
            source = { items = lines },
            prompt = 'Man pages',
            action = function(item)
              if not item or not item.text then return end
              local name, section = item.text:match('^(%S+)%s*%(([^)]+)%)')
              if name and section then vim.cmd('Man '..section..' '..name) end
            end,
          })
        end
      '';
      options = {
        desc = "Man pages";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sm";
      action.__raw = ''
        function()
          local marks = vim.fn.getmarklist(0)
          local items = {}
          for _, m in ipairs(marks) do
            if m.pos and m.pos[1] and m.pos[2] then
              local lnum = m.pos[2]
              table.insert(items, { text = string.format('%s @ %d', m.mark, lnum), _loc = { bufnr = m.bufnr or 0, lnum = lnum } })
            end
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Marks',
            action = function(item)
              if not item or not item._loc then return end
              if item._loc.bufnr ~= 0 then vim.api.nvim_set_current_buf(item._loc.bufnr) end
              vim.api.nvim_win_set_cursor(0, { item._loc.lnum, 0 })
            end,
          })
        end
      '';
      options = {
        desc = "Jump to Mark";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>so";
      action.__raw = ''
        function()
          local opts = vim.api.nvim_get_all_options_info()
          local items = {}
          for name, _ in pairs(opts) do table.insert(items, name) end
          table.sort(items)
          MiniPick.start({
            source = { items = items },
            prompt = 'Options',
            action = function(item)
              if item and item.text then vim.cmd("help '"..item.text.."'") end
            end,
          })
        end
      '';
      options = {
        desc = "Options";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>uC";
      action.__raw = ''
        function()
          local schemes = vim.fn.getcompletion("", 'color')
          MiniPick.start({
            source = { items = schemes },
            prompt = 'Colorschemes',
            action = function(item)
              if item and item.text then vim.cmd.colorscheme(item.text) end
            end,
          })
        end
      '';
      options = {
        desc = "Colorscheme preview";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = ''
        function()
          local bufnr = 0
          local diags = vim.diagnostic.get(bufnr)
          local items = {}
          for _, d in ipairs(diags) do
            local buf = vim.api.nvim_buf_get_name(d.bufnr)
            local msg = string.format('%s:%d:%d %s', vim.fn.fnamemodify(buf, ':.'), d.lnum + 1, d.col + 1, d.message)
            table.insert(items, { text = msg, _loc = { bufnr = d.bufnr, lnum = d.lnum + 1, col = d.col } })
          end
          MiniPick.start({
            source = { items = items },
            prompt = 'Diagnostics (buffer)',
            action = function(item)
              if not item or not item._loc then return end
              vim.api.nvim_set_current_buf(item._loc.bufnr)
              vim.api.nvim_win_set_cursor(0, { item._loc.lnum, item._loc.col })
            end,
          })
        end
      '';
      options = {
        desc = "Document diagnostics";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = ''
        function()
          MiniPick.builtin.files({ cwd = vim.fn.expand('%:p:h') })
        end
      '';
      options = {
        desc = "Search file cwd";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fR";
      action.__raw = ''
        function()
          local fn = MiniPick.builtin.grep_live or MiniPick.builtin.grep
          fn({ cwd = vim.fn.expand('%:p:h') })
        end
      '';
      options = {
        desc = "Grep cwd";
        silent = true;
      };
    }
  ];
}

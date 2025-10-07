{
  plugins.mini.modules.pairs = {};

  extraConfigLua = ''
    local function configure_typst_pairs(buf)
      local ok, mini_pairs = pcall(require, 'mini.pairs')
      if not ok or type(mini_pairs.map_buf) ~= 'function' then
        return
      end

      mini_pairs.map_buf(buf, 'i', '$', {
        action = 'closeopen',
        pair = '$$',
        neigh_pattern = '[^\\].',
      })
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typst', 'typ' },
      callback = function(args)
        configure_typst_pairs(args.buf)
      end,
    })
  '';
}

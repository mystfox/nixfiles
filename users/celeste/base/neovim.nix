{pkgs, ...}: {
  # Install language servers and other generally wanted tools globally
  home.packages = with pkgs; [
    neovim-remote
    page
    neovim-qt-unwrapped
    neovide
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    extraPackages = builtins.attrValues {inherit (pkgs) rnix-lsp nixpkgs-fmt xclip lua-language-server iferr;};
    extraLuaPackages = lp: builtins.attrValues {inherit (lp) jsregexp;}; # for luasnip
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-unimpaired
      {
        plugin = nvim-surround;
        type = "lua";
        config = ''
          require'nvim-surround'.setup{}
        '';
      }
      plenary-nvim
      {
        plugin = vim-numbertoggle;
        type = "lua";
        config = ''
          -- Default to both number and relative number
          vim.opt.number = true
          vim.opt.relativenumber = true
        '';
      }
      vim-eunuch
      vim-nix # TODO: does this provide anything anymore w/ tree-sitter in use?
      zoxide-vim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Mappings.
          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          local opts = { noremap=true, silent=true }
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          end

          -- capabilities for nvim-cmp
          local capabilities = require'cmp_nvim_lsp'.default_capabilities()

          -- mow
          --vim.lsp.set_log_level("debug")

          require'lspconfig'.rnix.setup{
            on_attach=on_attach,
            capabilities=capabilities,
          }

          require'lspconfig'.pylsp.setup{
            on_attach=on_attach,
            capabilities=capabilities,
          }

          -- Tuned for editing lua for nvim, if I do do that. Override w/ a .luarc.json for projects if needed
          -- https://github.com/sumneko/lua-language-server/wiki/Configuration-File
          -- lua-language-server now, but looks the same there: https://github.com/LuaLS/lua-language-server/wiki/Configuration-File
          require'lspconfig'.lua_ls.setup{
            settings = {
              Lua = {
                runtime = {
                  -- What version of Lua (Neovim Lua is probably LuaJIT), is as of setting this up
                  version = 'LuaJIT',
                },
                diagnostics = {
                  -- recognise the vim global
                  globals = {'vim'},
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true)
                },
                telemetry = {
                  enable = false,
                },
              },
            },
            on_attach=on_attach,
            capabilities=capabilities,
          }
        '';
      }
      {
        plugin = rust-vim;
        type = "lua";
        config = '''';
      }
      {
        plugin = rust-tools-nvim;
        type = "lua";
        config = ''
          require'rust-tools'.setup{
            server = {
              on_attach = function(client, bufnr)
                -- TODO: This is copied from above w/ additions: make modular? Maybe a "require" for an extensible "on_attach" function?
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

                -- Rust specific
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, bufopts)
                -- Code action groups
                vim.keymap.set("n", "<space>cg", rt.code_action_group.code_action_group, bufopts)
              end,
              capabilities=require'cmp_nvim_lsp'.default_capabilities(), -- TODO: same, weh?
            },
          }
        '';
      }
      pkgs.vimExtraPlugins.guihua-lua
      {
        plugin = pkgs.vimExtraPlugins.go-nvim;
        type = "lua";
        config = ''
          require'go'.setup{
            verbose = true,
            lsp_cfg = {
              capabilities = require'cmp_nvim_lsp'.default_capabilities(),
            },
            lsp_on_attach = true,
            lsp_keymaps = function(bufnr)
              -- Mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local bufopts = { noremap=true, silent=true, buffer=bufnr }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, bufopts)
              vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
              vim.keymap.set('n', '<space>rn', function() require'go.rename'.run() end, bufopts)
              vim.keymap.set('n', '<space>ca', function() require'go.codeaction'.run_code_action() end, bufopts)
              vim.keymap.set('v', '<space>ca', function() require'go.codeaction'.run_range_code_action() end, bufopts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
              vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
            end,
            lsp_gofumpt = true,
            textobjects = false,
            luasnip = true,
          }
        '';
      }
      /*
      {
        plugin = pkgs.vimExtraPlugins.nvim-go;
        type = "lua";
        config = ''
          -- lsp config is in lspconfig plugin block, since there's no need to put it here
          -- binaries this wants, really:
          -- gopls, language server
          -- revive, linter
          -- gomodifytags
          -- gotests
          -- iferr (including)
          -- nodePackages.quicktype
          require'go'.setup{
            formatter = 'lsp',
          }

        '';
      }
      */
      {
        plugin = pkgs.vimExtraPlugins.typescript-nvim;
        type = "lua";
        config = ''
          require'typescript'.setup{
            server = {
              on_attach = function(client, bufnr)
                -- TODO: This is copied from above w/ additions: make modular? Maybe a "require" for an extensible "on_attach" function?
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set('n', '<space>wl', function()
                  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

                -- Rust specific
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, bufopts)
                -- Code action groups
                vim.keymap.set("n", "<space>cg", rt.code_action_group.code_action_group, bufopts)
              end,
              capabilities=require'cmp_nvim_lsp'.default_capabilities(), -- TODO: same, weh?
            },
          }
        '';
      }
      # completion
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-git
      # for luasnip integration
      cmp_luasnip
      # pretty
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          vim.opt.completeopt = { "menu", "menuone", "noselect" }

          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local luasnip = require'luasnip'
          local cmp = require'cmp'
          local lspkind = require'lspkind'

          cmp.setup{
            snippet = {
              expand = function(args)
                require'luasnip'.lsp_expand(args.body)
              end,
            },
            window = {
            },
            formatting = {
              format = lspkind.cmp_format{
                mode = "symbol_text",
                menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[Latex]",
                }),
              },
            },
            mapping = cmp.mapping.preset.insert{
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-Space>'] = cmp.mapping.complete(),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'luasnip' },
            }, {
              { name = 'buffer' },
            }),
          }

          -- Set configuration for specific filetype.
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
              { name = 'buffer' },
            })
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })
        '';
      }
      {
        plugin = luasnip;
        type = "lua";
        config = ''
          ls = require'luasnip'

          ls.setup{
            ft_func = require'luasnip.extras.filetype_functions'.from_pos_or_filetype,
            load_ft_func = require'luasnip.extras.filetype_functions'.extend_load_ft{
              html = {"javascript"}
            },
          }

          -- For vim-snippets
          ls.filetype_extend("all", { "_" })
          -- as a note: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
          -- from_pos_or_filetype above preferentially returns the name of the treesitter parser
          ls.filetype_extend("latex", { "tex" })

          require'luasnip.loaders.from_vscode'.lazy_load{}
          require'luasnip.loaders.from_snipmate'.lazy_load{}

          vim.api.nvim_create_user_command('LuaSnipEdit', function(opts)
            require'luasnip.loaders'.edit_snippet_files{
              extend = function(ft, paths)
                if #paths == 0 then
                  return {
                    { "$CONFIG/snippets/" .. ft .. ".snippets",
                    string.format("%s/snippets/%s.snippets", vim.fn.stdpath('config'), ft) }
                  }
                end
                return {}
              end,
            }
          end, {})
        '';
      }
      vim-snippets
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require'Comment'.setup{
            pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
          }
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup{
            -- Don't auto install on NixOS
            auto_install = false,
            context_commentstring = {
              enable = true,
              enable_autocmd = false,
            },
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
          }
        '';
      }
      nvim-ts-context-commentstring
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = ''
          require'treesitter-context'.setup{}
        '';
      }
      {
        plugin = pkgs.vimExtraPlugins.nvim-pqf;
        type = "lua";
        config = ''
          require'pqf'.setup{}
        '';
      }
      # Git
      vim-fugitive
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require'gitsigns'.setup{}
        '';
      }
      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = ''
          require'gitlinker'.setup{}
        '';
      }
      # Themes
      {
        plugin = pkgs.vimExtraPlugins.starry-nvim;
        type = "lua";
        config = ''
          vim.g.starry_italic_comments = true
          vim.g.starry_disable_background = true -- transparency support
          vim.cmd.colorscheme 'moonlight'
        '';
      }
      {
        plugin = aurora;
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          vim.g.aurora_italic = 1
          vim.g.aurora_transparent = 1
          -- vim.cmd.colorscheme 'aurora'
        '';
      }
    ];
    extraConfig = ''
      if exists("g:neovide")
        " Running in neovide
        set guifont=VictorMono\ Nerd\ Font,Fira\ Code\ Nerd\ Font,Fira\ Code:h10
        let g:neovide_transparency = 0.8
        let g:neovide_remember_window_size = v:true
        let g:neovide_cursor_vfx_mode = "pixiedust"
      endif
    '';
  };
}

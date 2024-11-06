---@diagnostic disable: undefined-global
--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.showtabline = 2
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.cursorcolumn = false

-- general
lvim.log.level = "info"
lvim.format_on_save = false
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.insert_mode["jk"] = "<ESC>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["l"]["R"] = { "<cmd>Telescope lsp_references<cr>", "Telescope references" }

-- Adding terminal keybindings
lvim.builtin.which_key.mappings["t"] = { "Terminal" };
lvim.builtin.which_key.mappings["t"]["f"] = { "<cmd>ToggleTerm direction=float<cr>", "Floating terminal" }
lvim.builtin.which_key.mappings["t"]["h"] = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal terminal" }
lvim.builtin.which_key.mappings["t"]["v"] = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical terminal" }

-- Adding symbols-outline mapping
lvim.builtin.which_key.mappings["l"]["o"] = { "<cmd>SymbolsOutline<cr>", "Toggle SymbolsOutline" }

-- -- Change theme settings
lvim.colorscheme = "catppuccin-mocha"
-- lvim.colorscheme = "duskfox"
lvim.transparent_window = true

-- After changing plugin config exit and reopen LunarVim, Run :PackerSync
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>
lvim.lsp.installer.setup.ensure_installed = {
  "bashls",
  "dagger",
  "gopls",
  "helm_ls",
  "lua_ls",
  "rust_analyzer",
}

-- --- disable automatic installation of servers
lvim.lsp.installer.setup.automatic_installation = false

lvim.lsp.automatic_configuration.skipped_servers = {
  "kotlin_language_server",
  "rust_analyzer",
  "nil"
}
-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- kotlin_language_server setup
require("lvim.lsp.manager").setup("kotlin_language_server", {
  settings = {
    kotlin = {
      compiler = {
        jvm = {
          target = "1.8",
        },
      },
    },
  },
})

-- nix nil lsp setup
require('lvim.lsp.manager').setup("nil_ls", {
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      }
    }
  }
})

-- helm_ls setup
require("lvim.lsp.manager").setup("helm_ls", {
  filetypes = { "helm", "helm_template" },
})

require("lvim.lsp.manager").setup("yamlls", {
  filetypes = vim.tbl_filter(function(ft)
    return not (ft == 'helm' or ft == 'helm_template')
  end, { "yaml", "yml" }),
})

-- terraform setup
require("lvim.lsp.manager").setup("terraformls", {
  filetypes = { "hcl", "tf", "tfvars" },
})

lvim.autocommands = {
  {
    { "BufRead", "BufNewFile" },
    {
      pattern = { "*/templates/*.tpl", "*/templates/*.{yaml,yml}" },
      command = "setfiletype helm",
    }
  },
}
-- end helm_ls setup

-- rust_analyzer setup
require("lvim.lsp.manager").setup("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      files = {
        excludeDirs = {
          ".direnv"
        }
      }
    }
  }
})

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    command = "shfmt",
  },
  {
    command = "yamlfmt",
    filetypes = { "yaml", "yml" },
  },
  {
    command = "prettier",
    extra_args = { "--print-width", "100" },
    filetypes = { "markdown", "typescript", "javascript" },
  },
  -- {
  -- 	command = "stylua",
  -- 	filetypes = { "lua" },
  -- },
})
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
})

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  "folke/todo-comments.nvim",
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          }
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  { "EdenEast/nightfox.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  -- { "p00f/nvim-ts-rainbow" },
  { "christoomey/vim-tmux-navigator" },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  -- TPope
  "tpope/vim-surround",
  "tpope/vim-fugitive",

  -- Markdown
  { "ellisonleao/glow.nvim" },
  {
    "davidgranstrom/nvim-markdown-preview",
    build = "yarn global add @compodoc/live-server --prefix ~/.local",
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --     })
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua" },
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
  { 'cappyzawa/starlark.vim' },
  { 'simrat39/rust-tools.nvim' },
  { 'towolf/vim-helm' },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function()
      require "lsp_signature".setup()
      require "lsp_signature".on_attach()
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    config = function()
      require('symbols-outline').setup()
    end,
  }
}

lvim.builtin.gitsigns.opts.current_line_blame = true

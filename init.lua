-- <---Settings--->

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true
vim.o.termguicolors = true
vim.opt.shell = 'zsh'
vim.opt.showmode = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.smartindent = true
vim.o.breakindent = true

vim.opt.tabstop = 8
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.wo.signcolumn = 'yes'
vim.opt.signcolumn = 'yes'

vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.formatoptions = 'jcroqlnt'
vim.g.autoformat = true
vim.opt.linebreak = true
vim.opt.wrap = false

vim.opt.wildmenu = true

vim.opt.autoread = true
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.o.clipboard = 'unnamedplus'

-- <---Key Bindings--->

-- buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext <CR>')       -- Tab goes to next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious <CR>') -- Shift+Tab goes to previous buffer

-- Soft word-wrap
vim.keymap.set('n', '<leader>lb', ':set wrap!<cr>')

-- Replace in whole file, :%s/foo/bar/g
vim.keymap.set('n', '<leader>r', ':%s/')

-- Exit search in buffer
vim.keymap.set('n', '<esc>', ':noh<cr>', { silent = true })

-- Save
vim.keymap.set('n', '<C-s>', ':w<cr>>')

-- Select next file in quickfix list
vim.keymap.set('n', '<C-Tab>', ':cnext')

-- Toggle Colours in code
vim.keymap.set('n', '<leader>ct', ':ColorizerToggle<cr>')

-- Annoying prism.js for < and >, place cursor over characters in normal mode and press leader < or >

vim.keymap.set('n', '<leader>,', 'xi&lt;<esc>')
vim.keymap.set('n', '<leader>.', 'xi&gt;<esc>')

-- <---Snippits--->

-- Code snippit
vim.keymap.set('n', ',c', ':read ~/.config/nvim/snippits/code.html<cr> 26li')

-- <---User Defined Commands--->

-- Edit this file
vim.api.nvim_create_user_command('Init', ':e ~/.config/nvim/init.lua', {})

-- Edit .zshrc
vim.api.nvim_create_user_command('Zshrc', ':e ~/.zshrc', {})

-- Add html template from CWD
vim.api.nvim_create_user_command('Template', ':read template.html', {})

-- <---Spell checker--->

vim.opt.spell = true
vim.opt.spelllang = 'en_gb'

-- Toggle spell checker
vim.keymap.set('n', '<leader>s', ':set spell!<cr>')

-- <---Highlight on yank--->

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- <---Plugins--->

-- Install lazy.nvim

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- Vim Wiki
  { 'vimwiki/vimwiki' },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Whichkey
  {
    'folke/which-key.nvim',
    opts = {
      show_keys = false,
      triggers_blacklist = {
        n = { '<leader>' },
      },
    },
  },

  -- Colour Scheme
  {
    'f4z3r/gruvbox-material.nvim',
    name = 'gruvbox-material',
    lazy = false,
    priority = 1000,
    opts = {
      italics = false,
      comments = { italics = false },
      background = { transparent = true },
      float = {
        force_background = false,
        background_color = nil,
      },
    },
  },

  -- Show Colours in code
  { 'norcalli/nvim-colorizer.lua',      opts = {} },

  -- <---Autocompletion--->
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'vim' },
    },
  },

  -- <---Syntax Highlighting--->
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      local configs = require 'nvim-treesitter.configs'

      configs.setup {
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'elixir', 'heex', 'javascript', 'html' },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- <---Formatting--->
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        html = { 'htmlbeautifier' },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- <---Toggle Term--->

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      shell = 'zsh',
    },
  },

  -- Flatten, Stops nested sessions
  {
    'willothy/flatten.nvim',
    lazy = false,
    priority = 1001,
    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = 'alternate',
        },
        callbacks = {
          should_block = function(argv)
            -- Note that argv contains all the parts of the CLI command, including
            -- Neovim's path, commands, options and files.
            -- See: :help v:argv

            -- In this case, we would block if we find the `-b` flag
            -- This allows you to use `nvim -b file1` instead of
            -- `nvim --cmd 'let g:flatten_wait=1' file1`
            return vim.tbl_contains(argv, '-b')

            -- Alternatively, we can block if we find the diff-mode option
            -- return vim.tbl_contains(argv, "-d")
          end,
          pre_open = function()
            local term = require 'toggleterm.terminal'
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            else
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)

              -- If we're in a different wezterm pane/tab, switch to the current one
              -- Requires willothy/wezterm.nvim
              --require("wezterm").switch_pane.id(
              --tonumber(os.getenv("WEZTERM_PANE"))
              --)
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            -- If you just want the toggleable terminal integration, ignore this bit
            if ft == 'gitcommit' or ft == 'gitrebase' then
              vim.api.nvim_create_autocmd('BufWritePost', {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end),
              })
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
  },

  -- <---LSP--->

  { 'folke/neodev.nvim',                opts = {} },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },

  -- Plugins Above this line
}, {}) -- Closes require('lazy').setup({
-- Configs Below this line

-- <---Toggle Term Windows--->

-- Custom terminal [vifm] Requires vifm to be installed https://github.com/vifm/vifm
local Terminal = require('toggleterm.terminal').Terminal
local vifm = Terminal:new { cmd = 'vifm -c view', hidden = true, direction = 'float' }

function _vifm_toggle()
  vifm:toggle()
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>e',
  '<cmd>lua _vifm_toggle()<CR>',
  { noremap = true, silent = true, desc = '[v]ifm file manager' }
)

-- <---Telescope Setup--->

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<c-d>'] = require('telescope.actions').delete_buffer,
      },
    },
  },
}

-- <---LSP Config--->

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require('neodev').setup {
  -- add any options here, or leave empty to use the default settings
}

local lspconfig = require 'lspconfig'
lspconfig.lua_ls.setup {
  -- on_attach, etc.
  settings = {
    Lua = {
      -- completion, runtime, workspace, etc.
      diagnostics = {
        globals = { 'vim' },
        undefined_global = false,   -- remove this from diag!
        missing_parameters = false, -- missing fields :)
      },
    },
  },
}

require('mason').setup {}
require('mason-lspconfig').setup {}

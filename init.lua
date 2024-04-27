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

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.path:append '**'
vim.opt.wildmenu = true

vim.opt.autoread = true
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- <---Key Bindings--->

-- buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext <CR>') -- Tab goes to next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious <CR>') -- Shift+Tab goes to previous buffer

-- Soft word-wrap
vim.keymap.set('n', '<leader>lb', ':set linebreak!<cr>')

-- Fuzzy finder, only use in projects not in home as will search all sub directories
vim.keymap.set('n', '<leader>f', ':find *')

-- Search old files, when found hit enter number and hit 'enter'
vim.keymap.set('n', '<leader>?', ':ol <cr>:e #<')

-- Replace in whole file, :%s/foo/bar/g
vim.keymap.set('n', '<leader>r', ':%s/')

-- Exit search in buffer
vim.keymap.set('n', '<esc>', ':noh<cr>', { silent = true })

-- Save
vim.keymap.set('n', '<C-s>', ':w<cr>>')

-- html format  https://github.com/threedaymonk/htmlbeautifier
vim.keymap.set('n', ',html', ':! htmlbeautifier %<CR>')

-- <---User Defined Commands--->

--command Vimrc :e ~/.vimrc
vim.api.nvim_create_user_command('Init', ':e ~/.config/mnvim/init.lua', {})

--command Zshrc :e ~/.zshrc
vim.api.nvim_create_user_command('Zshrc', ':e ~/.zshrc', {})

--command Template :read template.html
vim.api.nvim_create_user_command('Template', ':read template.html', {})

-- <---Autocompletion--->

vim.cmd [[inoremap " ""<left>]]
vim.cmd [[inoremap ' ''<left>]]
vim.cmd [[inoremap ( ()<left>]]
vim.cmd [[inoremap [ []<left>]]
vim.cmd [[inoremap { {}<left>]]
vim.cmd [[inoremap < <><left>]]
vim.cmd [[inoremap {<CR> {<CR>}<ESC>O]]
vim.cmd [[inoremap {;<CR> {<CR>};<ESC>O]]

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
		config = function()
			vim.g.gruvbox_material_disable_italic_comment = 1
			vim.g.gruvbox_material_transparent_background = 1

			vim.cmd 'colorscheme gruvbox-material'
		end,
	},
    -- Syntax Highlighting
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

	-- ToggleTerm
	{
		'akinsho/toggleterm.nvim',
		version = '*',
		opts = {
			shell = 'zsh',
		},
	},
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
}, {})

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

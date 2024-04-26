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

--vim.opt.shortmess+=F

vim.opt.path:append '**'
vim.opt.wildmenu = true

vim.opt.autoread = true

-- <---Key Bindings--->

-- buffer navigation
vim.keymap.set('n', '<Tab>', ':bnext <CR>') -- Tab goes to next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious <CR>') -- Shift+Tab goes to previous buffer

-- Soft wordwrap
vim.keymap.set('n', '<leader>lb', ':set linebreak!<cr>')

-- Fuzzy finder, only use in projects not in home as will search all sub directories
vim.keymap.set('n', '<leader>f', ':find *')

-- Search old files, when found hit 'q' then enter number and hit 'enter'
vim.keymap.set('n', '<leader>?', ':ol <cr>:e #<')

-- Replace in whole file, :%s/foo/bar/g
vim.keymap.set('n', '<leader>r', ':%s/')

-- Exit search in buffer
vim.keymap.set('n', '<esc>', ':noh<cr>')

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
	{ 'folke/which-key.nvim', opts = {
		show_keys = false,
		triggers_blacklist = {
				n = { "<leader>" }
				},
		} 
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

		-- Open files from terminal buffers without creating a nested session
		{
			'willothy/flatten.nvim',
			lazy = false,
			priority = 1001,
			opts = function()
				local saved_terminal

				return {
					window = {
						open = 'alternate',
					},
					callbacks = {
						should_block = function(argv)
							return vim.tbl_contains(argv, '-b')

						end,
						pre_open = function()
							local term = require 'toggleterm.terminal'
							local termid = term.get_focused_id()
							saved_terminal = term.get(termid)
						end,
						post_open = function(bufnr, winnr, ft, is_blocking)
							if is_blocking and saved_terminal then
								saved_terminal:close()
							else
								vim.api.nvim_set_current_win(winnr)

							end

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

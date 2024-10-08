set hlsearch
set clipboard+=unnamedplus
set number
colorscheme vim
" set shellcmdflag+=i
set tabstop=4
set shiftwidth=4
set expandtab
set completeopt+=menuone,noinsert,noselect,preview 
set nofoldenable 
set relativenumber 
set splitright
set splitbelow
set undofile
autocmd InsertLeave *.tex update

" inoremap <CR> <CR>

let g:instant_username = "Meow :3"
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

set conceallevel=2
hi Conceal ctermbg=none
au TermOpen * setlocal nospell
tnoremap <Esc> <C-\><C-n>
inoremap <expr> <TAB> pumvisible() ? "<C-y>" : "<TAB>"
nmap <Esc> :nohl<CR>
nmap <C-n> :NvimTreeToggle<CR>
nmap <C-m> :TagbarToggle<CR>
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-o> <C-O>
nmap <C-i> <C-I>

nmap j gj
nmap k gk

inoremap {<CR> {<CR>}<C-o>O 
inoremap [<CR> [<CR>]<C-o>O
inoremap (<CR> (<CR>)<C-o>O
inoremap jk <Esc> 
" inoremap kj <Esc> 

"terminal
map <leader>tt :<C-r>=floor((1.0/3.0)*winheight(0)) + 1<CR>split<CR>:set winfixheight<CR>:term<CR>A

"comp coding
nmap <leader>cc :CompetiTest receive contest<CR>
nmap <leader>cr :CompetiTest run<CR>

let g:vimtex_compiler_latexmk = {'out_dir' : 'texbuild',}

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <A-up> :call <SID>swap_up()<CR>
noremap <silent> <A-down> :call <SID>swap_down()<CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

lua << END
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"eandrju/cellular-automaton.nvim", lazy = true},
    {"tpope/vim-fugitive"},
    {"airblade/vim-gitgutter", lazy = true},
    {"petRUShka/vim-sage", lazy = true},
    {"NeogitOrg/neogit", lazy = true},
    "nvim-telescope/telescope.nvim",
    {"kylechui/nvim-surround", lazy = true,
    version = "*", 
    event = "VeryLazy", config = function()
        require("nvim-surround").setup({})
    end
    },
    "nvim-lua/plenary.nvim",
    {"nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'gruvbox_dark',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
          },
        }
    end
    },
    "nvim-tree/nvim-web-devicons",
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")
              configs.setup({
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "latex" },
                }
              })
        end
    },
    {"nvim-tree/nvim-tree.lua",
        config = function()
        require("nvim-tree").setup{}
        end
    },
    {"neovim/nvim-lspconfig",
    config = function()
      require('lspconfig')['clangd'].setup{}
      require('lspconfig').ltex.setup{}

      local lspconfig = require 'lspconfig'
        local configs = require 'lspconfig/configs'

        if not configs.golangcilsp then
            configs.golangcilsp = {
                default_config = {
                    cmd = {'golangci-lint-langserver'},
        root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
                    init_options = {
                            command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" };
                    }
                };
            }
        end
        
      require'lspconfig'.gopls.setup{}
      require'lspconfig'.ts_ls.setup{}
      require'lspconfig'.jdtls.setup{
        cmd = {'/bin/jdtls'},
      }
      require'lspconfig'.pyright.setup{}
      require'lspconfig'.hls.setup{}

      vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.keymap.set("n", "K", function()
            local base_win_id = vim.api.nvim_get_current_win()
            local windows = vim.api.nvim_tabpage_list_wins(0)
            for _, win_id in ipairs(windows) do
                if win_id ~= base_win_id then
                    local win_cfg = vim.api.nvim_win_get_config(win_id)
                    if win_cfg.relative == "win" and win_cfg.win == base_win_id then
                        vim.api.nvim_win_close(win_id, {})
                        return
                    end
                end
            end
            vim.lsp.buf.hover()
        end, { remap = false, silent = true, buffer = ev.buf, desc = "Toggle hover" })

        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        --vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
        })
      end
    },
    {"ray-x/lsp_signature.nvim",
        config = function()
          require "lsp_signature".setup({hint_prefix = ""})
        end
    },
    "tpope/vim-commentary",
    {"hrsh7th/nvim-cmp",
    config = function()
    local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), 
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, 
          { name = 'ultisnips' }, 
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' }, 
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
      vim.cmd("set winhighlight=Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual")
    end
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "lervag/vimtex",
    "ludovicchabant/vim-gutentags",
    "SirVer/ultisnips",
    "honza/vim-snippets",
    {'Julian/lean.nvim',
      event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
      opts = {
        lsp = {
          on_attach = on_attach,
        },
        mappings = true,
      }
    },
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
    "preservim/tagbar",
    {
        'xeluxee/competitest.nvim',
        dependencies = 'MunifTanjim/nui.nvim',
        config = function() require('competitest').setup({
            template_file = "~/.config/nvim/comptemp.$(FEXT)"
        }) end,
    },
    "github/copilot.vim"
})

vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = false

vim.g.nvim_tree_update_cwd = 1

 vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
 vim.lsp.handlers.hover, {
   border = "rounded",
 }
)
local function close_floating()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

vim.cmd("Copilot disable")
END

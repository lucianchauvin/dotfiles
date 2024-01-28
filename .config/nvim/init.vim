set spell spelllang=en_us
set clipboard+=unnamedplus
set number!
set shellcmdflag+=i
set tabstop=4
set shiftwidth=4
set expandtab
set completeopt+=menuone,noinsert,noselect,preview
set nofoldenable
set relativenumber
set splitright
set splitbelow
let g:auto_save=0
autocmd BufRead,BufNewFile   *.tex let g:auto_save=1

let g:instant_username = "Meow :3"

set conceallevel=2
hi Conceal ctermbg=none

inoremap <expr> <TAB> pumvisible() ? "<C-y>" : "<TAB>"
nmap <Esc> :nohl<CR>
nmap <C-n> :NvimTreeToggle<CR>
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nnoremap / /\v
cnoremap %s/ %s/\v

call plug#begin()
Plug 'Maan2003/lsp_lines.nvim'
Plug 'NeogitOrg/neogit'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kylechui/nvim-surround'
Plug 'nvim-lua/plenary.nvim'
Plug 'jbyuki/instant.nvim'
Plug '907th/vim-auto-save'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'terrortylor/nvim-comment'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'lervag/vimtex'
Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'
Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger = '<tab>'
    let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
Plug 'honza/vim-snippets'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0
call plug#end()

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
local neogit = require('neogit')
neogit.setup {}

require("nvim-surround").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()

require('lsp_lines').setup()
-- Disable virtual_text since it's redundant due to lsp_lines.
vim.diagnostic.config({
  virtual_text = false,
})

require('nvim_comment').setup()

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
  },
}

local cmp = require'cmp'
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
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
  require("nvim-web-devicons").setup{}

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

 --  lua/lspconfig/server_configurations/SERVER_NAME.lua
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }

  require'lspconfig'.ltex.setup{}

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

  require'lspconfig'.pyright.setup{}

  require'lspconfig'.hls.setup{}

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true, 
  })

  require'nvim-treesitter.configs'.setup{
    auto_install = true,
    highlight = {
        enable = true,
        disable = { "latex" },
    }
}
END

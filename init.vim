call plug#begin('~/.config/nvim/plugged')

Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lspconfig'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'airblade/vim-gitgutter'
Plug 'Cian911/vim-cadence'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'preservim/nerdtreec'
Plug 'frazrepo/vim-rainbow'
Plug 'tpope/vim-surround'

Plug 'justinmk/vim-sneak'
"Plug 'easymotion/vim-easymotion'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-fugitive'  " for git stuff
Plug 'tpope/vim-rhubarb'

Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'wookayin/fzf-ripgrep.vim'

call plug#end()
let g:rainbow_active = 1
autocmd! BufWritePost vimrc source ~/.vim/vimrc

set nocompatible

" Leader
nnoremap <SPACE> <Nop>
let mapleader=" "

set ttyfast

filetype plugin indent on
filetype on
syntax on
syntax enable

set encoding=utf-8
set expandtab
set number
set autoindent
set termguicolors
set nobackup
set noswapfile
set nowritebackup
set ignorecase                    " ignore case when searching
set smartcase                     " turn on smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set number
set relativenumber
set hidden
set mouse=a
set noshowmode
set noshowmatch
set nolazyredraw
set number relativenumber
set nu rnu
set bs=2
set clipboard=unnamed
set mouse=a
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c

inoremap jf <Esc>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>rr :Rg<CR>
nnoremap <silent> <Leader>bf :Buffers<CR>
nnoremap <silent> <Leader>bw :bwipe<CR>

noremap <F3> Autoformat<CR>


" Airline
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:python_highlight_all = 1
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'
let g:airline#extensions#tabline#enabled = 1




let g:catppuccin_flavour = "mocha" " latte, frappe, macchiato, mocha
colorscheme catppuccin



lua << EOF
require("nvim-lsp-installer").setup {
  automatic_installation = true
}

local lspconfig = require("lspconfig")
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

local on_attach = function(client, bufnr)
    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
    buf_map(bufnr, "n", "gd", ":LspDef<CR>")
    buf_map(bufnr, "n", "gr", ":LspRefs<CR>")
    buf_map(bufnr, "n", "gy", ":LspTypeDef<CR>")
    buf_map(bufnr, "n", "K", ":LspHover<CR>")
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

lspconfig.gopls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end, 
})
lspconfig.golangci_lint_ls.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
    end, 
})

lspconfig.tsserver.setup({
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
})


local util = require 'lspconfig/util'
local configs = require'lspconfig/configs'



EOF

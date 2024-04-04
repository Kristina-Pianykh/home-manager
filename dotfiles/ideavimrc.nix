{...}: {
  home.file.".ideavimrc".text = ''
    " Set <space> as the leader key
    let mapleader = " "
    let maplocalleader = " "

    " Basic Settings
    set mouse=a
    set termguicolors
    set relativenumber
    set pumheight=10
    set hlsearch
    set clipboard+=unnamedplus

    " Indentation
    set expandtab
    set shiftwidth=2
    set tabstop=2
    set softtabstop=2
    set smartindent

    " UI Configurations
    set showmode=false
    set signcolumn=yes:1
    set laststatus=3

    " Keymaps for inserting new lines above or below the current line
    nnoremap mo o<Esc>k
    nnoremap mO O<Esc>j

    " Split window navigation
    nnoremap <Space>h <C-w>h
    nnoremap <Space>j <C-w>j
    nnoremap <Space>k <C-w>k
    nnoremap <Space>l <C-w>l

    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'machakann/vim-highlightedyank'
  '';
}

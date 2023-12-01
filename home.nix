{ config, pkgs, lib, ... }:

let 
  username = "piankris";
  homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.05";
    packages = with pkgs; [
      lsd
      bat
      nerdfonts
      joypixels
      awscli
      rustup
      parquet-tools
      ripgrep
      fd
    ];
    sessionPath = [
      "${homeDirectory}/Work/data-delivery-backend/.venv/bin/sqlfluff"
      "${homeDirectory}/slides"
      "${homeDirectory}/act"
    ];
    shellAliases = {
      ls="lsd -la";
      lsd="lsd -la";
      rm="rm -f";
      home="code ~/.config/nixpkgs/home.nix";
      mnt="cd /mnt/c/Users/pianykri/'OneDrive - diconium GmbH'";
      desktop="cd /mnt/c/Users/pianykri/'OneDrive - diconium GmbH'/Desktop";
      ipython="ipython3";
    };
  };
  fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    history.extended = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      export GPG_TTY=$(tty)
      
      eval "$(ssh-agent -s)"
      ssh-add ~/.ssh/work

      eval "$(direnv hook zsh)"
      eval "$(direnv stdlib)"
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word 
    '';
    prezto = {
      enable = true;
      extraConfig = ''
        # alias node="nocorrect node"
        # alias yarn="nocorrect yarn"
      '';
      pmodules = [
        "environment"
        "terminal"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
      ];
    };
  };
  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  # programs.neovim = {
  #   enable = true;
  #   extraConfig = ''
  #     set number relativenumber
  #   '';
  # };
  programs.home-manager.enable = true;
  programs.neovim = let
    # Function to fetch plugins from github if they're not already in the nix store
    plugin = {
      repo,
      ref,
      rev,
    }:
      pkgs.vimUtils.buildVimPlugin {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = rev;
        src = builtins.fetchGit {
          url = "https://github.com/${repo}.git";
          inherit ref rev;
        };
      };
    in {
      enable = true;
      withNodeJs = true;
      # COC CONFIG CURRENTLY DISABLED! UNCOMMENT TO ENABLE!
      # ===================================================
      # # Config for coc.nvim - You don't need to use all of these mappings but a few are notable:
      # # - `K` for documentation in preview window
      # # - Tab and Shift-Tab to move arround the completion list
      # # - Shift-Space to show completions if not there
      # # - Completions are automatically filled in - no need to accept just keep typing
      # # - `gd` to go to definition of the symbol under the cursor
      # # - <leader>f to format the current file - requires formatting to be configured
      # # - <leader> is mapped above to `,`
      coc = {
        enable = true;
        pluginConfig = ''
          let mapleader = ","
          let g:coc_global_extensions = ["coc-pyright","coc-yaml","coc-json", "coc-prettier"]
          set nobackup
          set nowritebackup
          set cmdheight=1

          set updatetime=900
          set shortmess+=c

          hi CocUnderline gui=undercurl term=undercurl
          hi CocErrorHighlight gui=undercurl guisp=red
          hi CocWarningHighlight gui=undercurl guisp=yellow

          " Use tab for trigger completion with characters ahead and navigate
          " NOTE: There's always complete item selected by default, you may want to enable
          " no select by `"suggest.noselect": true` in your configuration file
          " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
          " other plugin before putting this into your config
          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction
          inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ CheckBackspace() ? "\<TAB>" :
            \ coc#refresh()

          " Shitf + Tab to jump back threw recommendations
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          " Use <c-space> to trigger completion (if not already shown)
          inoremap <silent><expr> <c-space> coc#refresh()

          " Enter to confirm completion
          inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

          " Use `[g` and `]g` to navigate diagnostics
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " Remap keys for gotos
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window
          function! ShowDocumentation()
            if CocAction('hasProvider', 'hover')
              call CocActionAsync('doHover')
            else
              call feedkeys('K', 'in')
            endif
          endfunction
          nnoremap <silent> K :call ShowDocumentation()<CR>

          " Symbol referecnes highlighted after hold of cursor
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Renaming & Refactoring
          nmap <leader>rn <Plug>(coc-rename)
          nmap <leader>rf <Plug>(coc-refactor)

          " Formatting
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  :Format<Enter>

          nmap <silent> <leader>F  :CocCommand<Space>eslint.executeAutofix<Enter>

          " TODO Does something, not sure
          augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
            " Update signature help on jump placeholder.
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          augroup end

          " Open code actions of selected region. Press 'j' or 'k' to navigate.
          xmap <leader>a  <Plug>(coc-codeaction-selected)
          nmap <leader>a  <Plug>(coc-codeaction-selected)
          nmap <leader>ac  <Plug>(coc-codeaction)

          " Open quick fick for current line
          nmap <leader>qf  <Plug>(coc-fix-current)

          " Trigger code lens actions in current buffer. Not sure what it means
          nmap <leader>cl  <Plug>(coc-codelens-action)

          " Motions around language constructs
          xmap if <Plug>(coc-funcobj-i)
          omap if <Plug>(coc-funcobj-i)
          xmap af <Plug>(coc-funcobj-a)
          omap af <Plug>(coc-funcobj-a)
          xmap ic <Plug>(coc-classobj-i)
          omap ic <Plug>(coc-classobj-i)
          xmap ac <Plug>(coc-classobj-a)
          omap ac <Plug>(coc-classobj-a)

          " Scrolling of preview window
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

          nmap <silent> <C-s> <Plug>(coc-range-select)
          xmap <silent> <C-s> <Plug>(coc-range-select)
          command! -nargs=0 Format :call CocAction('format')
          command! -nargs=? Fold :call     CocAction('fold', <f-args>)
          command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
          nnoremap <silent> <leader>cr :CocRestart<Enter>
          nnoremap <silent> <leader>cf :CocCommand workspace.renameCurrentFile<Enter>
        '';
      };
      extraConfig = ''
        let mapleader = ","
        set termguicolors
        set number relativenumber
        set pumheight=10
        set mouse=a
        set clipboard+=unnamedplus
        set signcolumn=yes:1
        set nohlsearch
        " Fixing shit clipboard in WSL
        let g:clipboard = {
             \   'name': 'WslClipboard',
             \   'copy': {
             \      '+': 'clip.exe',
             \      '*': 'clip.exe',
             \    },
             \   'paste': {
             \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
             \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
             \   },
             \   'cache_enabled': 0,
             \ }
        nmap mo o<Esc>k
        " Shortutting split navigation
        nnoremap <Space>h <C-w>h
        nnoremap <Space>j <C-w>j
        nnoremap <Space>k <C-w>k
        nnoremap <Space>l <C-w>l
      ''
      ;
      plugins = with pkgs.vimPlugins; [
        # Adds closing pairs automatically like VsCode
        {
          plugin = auto-pairs;
          config = ''
            let g:AutoPairsMultilineClose = 0
            autocmd FileType json let b:autopairs_enabled = 0
          '';
        }
        {
          plugin = vim-smoothie;
          config = ''
            nnoremap <unique> <Space>d <cmd>call smoothie#do("\<C-D>") <CR>
            vnoremap <unique> <Space>d <cmd>call smoothie#do("\<C-D>") <CR>
            nnoremap <unique> <Space>u <cmd>call smoothie#do("\<C-U>") <CR>
            vnoremap <unique> <Space>u <cmd>call smoothie#do("\<C-U>") <CR>
          '';
        }
        # https://github.com/tomtom/tNONEcomment_vim
        tcomment_vim

        # Very useful but needs to be learned
        # https://github.com/tpope/vim-surround
        # vim-surround

        # Awesome Git integration - Needs to be learned
        # https://github.com/tpope/vim-fugitive
        # vim-fugitive

        # Commit browser - Needs to be learned
        # https://github.com/junegunn/gv.vim
        # gv-vim

        # Greatly improves built-in language support and adds more
        vim-polyglot

        # Give a markdown preview in browser
        # markdown-preview-nvim

        # Better statusline - integrates with many other plugins
        # Theme is set the same as the nordfox theme.
        {
          plugin = plugin {
            repo = "nvim-lualine/lualine.nvim";
            ref = "master";
            rev = "2248ef254d0a1488a72041cfb45ca9caada6d994";
          };
          config = ''
            lua << EOF
            require("lualine").setup({
              options = {
                theme = "nordfox"
              }
            })
            EOF
          '';
        }

        # Allows for better syntax highlighting
        {
          plugin = nvim-treesitter.withAllGrammars;
          config = ''
            lua << EOF
            require("nvim-treesitter.configs").setup({
              highlight = {
                enable = true,
              },
              indent = {
                enable = true,
                disable = { "python" },
              },
            })
            EOF
          '';
        }
        # Nordfox nevoim theme
        {
          plugin = nightfox-nvim;
          config = ''
            lua << EOF
            require("nightfox").setup({
              options = {
                styles = {
                  types = "NONE",
                  numbers = "NONE",
                  strings = "NONE",
                  comments = "NONE",
                  keywords = "bold",
                  constants = "NONE",
                  functions = "NONE",
                  operators = "NONE",
                  variables = "NONE",
                  conditionals = "NONE",
                  virtual_text = "NONE",
                }
              }
            })
            vim.cmd("colorscheme nordfox")
            EOF
          '';
        }

        # Shows git changes in the gutter
        # vim-gitgutter

        # You'll probably want this ;)
        # C-Enter to accept completion
        {
          plugin = plugin {
            repo = "github/copilot.vim";
            ref = "release";
            rev = "309b3c803d1862d5e84c7c9c5749ae04010123b8";
          };
          config = ''
            imap <silent><script><expr> <C-Enter> copilot#Accept("\<CR>")
            let g:copilot_no_tab_map = v:true
          '';
        }
        plenary-nvim
        telescope-fzf-native-nvim
        {
          plugin = telescope-nvim;
          config = ''
          lua << EOF
          require("telescope").setup({
            -- defaults = {
            --   layout_strategy = "vertical",
            -- },
            pickers = {
              find_files = {
                find_command = { "rg", "--files", "--ignore", "-g", "!.git", "--hidden" },
              }
            }
          })

          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<Space>p", builtin.find_files, {})
          vim.keymap.set("n", "<Space>g", builtin.live_grep, {})
          EOF
          '';
        }
        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          config = ''
            lua << EOF
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup()
            vim.keymap.set("n", "<Space>e", ":NvimTreeClose<Enter>:G<Enter>", {silent = true})
            vim.keymap.set("n", "<Space>t", ":NvimTreeToggle<Enter>", {silent = true})
            EOF
          '';
        }
        vim-fugitive
      ];
    };

  programs.git = {
    enable = true;
    userName = "Kristina Pianykh";
    userEmail = "kristinavrnrus@gmail.com";
    signing = {
      key = "C66C7DFC66E169F1";
      gpgPath = "/usr/bin/gpg";
      signByDefault = true;
    };
    diff-so-fancy.enable = true;
    extraConfig = {
      init = {
          defaultBranch = "main";
      };
    };
    includes = [
      { 
        condition = "gitdir:${homeDirectory}/Work/";
        contents = {
          user = {
            name = "Kristina Pianykh";
            email = "kristina.pianykh@diconium.com";
            signingKey = "3A09BEC8E7DCA833";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
    ];
  };
}

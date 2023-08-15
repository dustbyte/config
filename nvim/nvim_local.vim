call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.pie.apple.com/pcl/pcl-neovim.git'
call plug#end()

" The below is required for enabling the tree-sitter syntax engine, which is used by pcl-neovim.
lua <<EOF
local hasConfigs, configs = pcall(require, "nvim-treesitter.configs")
if hasConfigs then
  configs.setup {
    ensure_installed = "pcl",
    highlight = {
      enable = true,              -- false will disable the whole extension
    },
    indent = {
      enable = true
    }
  }
end
EOF

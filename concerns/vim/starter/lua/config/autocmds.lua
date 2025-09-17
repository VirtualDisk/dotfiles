-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[set guicursor=n:hor50,i-ci-ve:block]])

-- Helm fix
-- https://github.com/neovim/nvim-lspconfig/issues/2252
vim.cmd([[autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl,*.gotmpl,helmfile*.yaml set ft=helm]])

-- Terraform Stuff
-- vim.cmd([[let g:terraform_fmt_on_save=1]])
-- vim.cmd([[let g:terraform_align=1]])
-- vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
-- vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
-- require("lspconfig").terraformls.setup({})
-- require("lspconfig").tflint.setup({})

-- vim.cmd([[autocmd BufRead,BufNewFile *.yaml.tpl set filetype=yaml]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.yml.tpl set filetype=yaml]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.yaml set filetype=yaml]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.yml set filetype=yaml]])

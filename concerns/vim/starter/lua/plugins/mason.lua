return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ansible-lint",
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "terraform-ls",
      },
    },
  },
}

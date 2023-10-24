return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
}

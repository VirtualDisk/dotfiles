-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("devcontainer").setup({
  generate_commands = true,
  -- By default no autocommands are generated
  -- This option can be used to configure automatic starting and cleaning of containers
  autocommands = {
    -- can be set to true to automatically start containers when devcontainer.json is available
    init = true,
    -- can be set to true to automatically remove any started containers and any built images when exiting vim
    clean = true,
    -- can be set to true to automatically restart containers when devcontainer.json file is updated
    update = true,
  },
  -- can be changed to increase or decrease logging from library
})

# zoë's dotfiles

This will set up your workspace to be identical to mine. It will install several tools. 
Note that for my actual toolchain I use with my work, such as terraform and helm, are managed with asdf and are using old versions by default.

## Requirements

This script will run on
- MacOS 11
- Debian (including Ubuntu)
- Arch

For a better understanding of which packages are being installed, see [vars.yml](https://github.com/VirtualDisk/.dotfiles/blob/main/vars.yml). 
Note that different platforms require different dependencies to work properly, but all of them will have the same tools installed. 

## Installation

- Clone the repo
`git clone github.com/virtualdisk/.dotfiles ~/.dotfiles`

- Switch the working directory
    `cd ~/.dotfiles`

- Run the bootstrap script, giving it exec permissions first
    `sudo chmod +x ./bootstrap.sh && ./bootstrap.sh`

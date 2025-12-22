{
  description = "Nix configuration";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
 
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
 
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
 
  outputs = inputs @ { self, flake-utils, nixpkgs, ... }: let
    nixpkgsConfig = {
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = 
      let
        inherit (inputs.nix-darwin.lib) darwinSystem;
        system = "aarch64-darwin";
      in {
        "zoe-mbp" = darwinSystem {
          inherit system;
          specialArgs = { inherit system inputs; };
  
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ./hosts/mbp/configuration.nix
            {
              nixpkgs = nixpkgsConfig;
  
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zoe = import ./home/home.nix;
            }
          ];
        };
      };
  };
}

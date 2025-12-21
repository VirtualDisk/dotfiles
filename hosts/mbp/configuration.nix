_:
 
{
  services.nix-daemon.enable = true;
 
  users.users.zoe = {
    home = /Users/zoe;
  };
 
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
 
  homebrew = {
    enable = true;
 
    casks = [
     "alacritty"
     "discord"
     "docker"
     "maccy"
     "rectangle"
     "session-manager-plugin"
     "signal"
    ];
  };
}

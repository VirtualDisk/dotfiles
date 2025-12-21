{ pkgs, ... }:

{
 home.stateVersion = "23.11";

 home.packages = with pkgs; [
   htop
   curl
   coreutils
   jq
 ];

 programs.zsh = {
   enable = true;

   shellAliases = {
     ls = "ls --color";
     vim = "nvim";
     vi = "nvim";
     grepo = "cdfzf Greenhouse";
     repo = "cdfzf Projects";
     a = "argo";
     k = "kubectl";
     t = "talosctl";
     dev = "ssh -i ${HOME}/.ssh/ubuntu ubuntu@dev.zoe";
     tf = "terraform";
     inf = "cd ~/Greenhouse/infrastructure";
     tfi = "tf init -backend-config=state.conf";
     ztfp = "tf plan -out .tfplan";
     tfp = "tf plan";
     tfpl = 'terraform plan -out=.tfplan && terraform show -json .tfplan | jq '"'"'.resource_changes[]|select(.change.actions != ["no-op"])|(.change.actions|join(","))+": "+.address'"'"' -r';
     tfpv = "tfp -var-file=secrets.tfvars";
     tfdv = "tf destroy -var-file=secrets.tfvars";
     tfa = "tf apply";
     dj = "dajoku";
     music = "ncmpcpp --host mpd.zoe";
     y = "yes > /dev/null";
     pj = "cd ~/Projects";
     kt = "killall tmux";
     gst = "git status";
     ga = "git add";
     gcam = "git commit -m";
     gco = "git checkout $(git branch | fzf)";
     showhidden = "defaults write com.apple.finder AppleShowAllFiles YES && killall Finder";
     hidehidden = "defaults write com.apple.finder AppleShowAllFiles NO && killall Finder";
     dockerid = "docker ps |awk 'FNR == 2 {print $1}' |pbcopy";
     ansible = "ansible -i ~/.ansible/inventory.yml";
     realpath = "grealpath";
     cleardns = "sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder";
     ytmp3 = "yt-dlp -x --audio-format mp3";
     };;
   };;
 }


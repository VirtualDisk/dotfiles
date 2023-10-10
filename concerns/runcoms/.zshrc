autoload -Uz compinit
compinit
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HISTFILE="${HOME}/.zsh_history"
export HISTFILESIZE=1000000000000
export HISTSIZE=10000000000000
setopt HIST_FIND_NO_DUPS

export ZOEREPO="${HOME}/Projects/zoe-infrastructure"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export EDITOR=nvim
export KUBE_EDITOR=nvim

# export TF_LOG="INFO"

# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# source "~/.zshsecrets"
# Source Prezto.

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source asdf
# source /opt/homebrew/opt/asdf/libexec/asdf.sh

# Source Google Cloud SDK
source '/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'

# Source kubectl completion
source <(argo completion zsh)
source <(talosctl completion zsh)
source <(/usr/local/bin/kubectl completion zsh)
# complete -F __start_kubectl k

. "/opt/homebrew/etc/profile.d/z.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias vim=nvim
alias vi=nvim
alias a=argo
alias k=kubectl
alias t=talosctl
alias dev='ssh -i ${HOME}/.ssh/ubuntu ubuntu@dev.zoe'
alias tf=terraform
alias inf="cd ~/Greenhouse/infrastructure"
alias tfi='tf init -backend-config=state.conf'
alias ztfp='tf plan -out .tfplan'
alias tfp='tf plan'
alias tfpl='tf show -json .tfplan | jq '"'"'.resource_changes[]|select(.change.actions != ["no-op"])|(.change.actions|join(","))+": "+.address'"'"' -r'
alias tfpv='tfp -var-file=secrets.tfvars'
alias tfdv='tf destroy -var-file=secrets.tfvars'
alias tfa='tf apply'
alias dj="dajoku"
alias music="ncmpcpp --host mpd.zoe"
alias y="yes > /dev/null"
alias pj="cd ~/Projects"
alias kt="killall tmux"
alias gst="git status"
alias ga="git add"
alias gcam="git commit -m"
alias gco='git checkout $(git branch | fzf)'
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias dockerid="docker ps |awk 'FNR == 2 {print $1}' |pbcopy"
alias ansible="ansible -i ~/.ansible/inventory.yml"
# alias ap="ansible-playbook -i ~/.ansible/inventory.yml --ask-become-pass"
alias livingroom="curl -X POST http://homeassistant.zoe/api/webhook/living-room-bright"
alias zbright="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bright"
alias zoff="curl -X POST http://homeassistant.zoe/api/webhook/zoe-off"
alias zdim="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-dim"
alias fan="curl -X POST http://homeassistant.zoe/api/webhook/toggle-ac"
alias zpurple="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-purple"
alias zbi="curl -X POST http://homeassistant.zoe/api/webhook/zoe-lights-bi"
alias cleardns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias sshm="aws ssm start-session --target"

zop() {
    while [[ ! $(pgrep 'Docker Desktop') ]];  do
        open "/Applications/Docker.app"
        echo "Docker desktop is not open. Waiting for Docker to start..."
        sleep 8
    done

    docker-compose --file ${ZOEREPO}/docker/onepassword/docker-compose.yaml up -d
    export OP_CONNECT_TOKEN=$(op item get 'zoe Access Token terraform' |yq .Fields.credential)
}

tfix() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    # docker run -it -v $(pwd):/terraform -v "${HOME}/.aws:/root/.aws" --platform=linux/amd64 virtualdisk/terraform "/usr/bin/terraform"
    docker run -it -v $(pwd):/terraform -v "${HOME}/.aws:/root/.aws" --platform=linux/amd64 virtualdisk/terraform "-chdir=/terraform/${PREVDIR} init"
    cd "${PREVDIR}"
}

tfax() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    docker run -it -v "${HOME}/.kube":"/root/.kube" -v "${HOME}/.ssh":"/root/.ssh" -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform "-chdir=/terraform/${PREVDIR}" apply
    cd "${PREVDIR}"
}

tfaxd() {
    PREVDIR="$(pwd | rev| awk -F / '{print $1}' | rev)"
    cd ..
    docker run -e TF_LOG="DEBUG" -it -v "${HOME}/.kube":"/root/.kube" -v "${HOME}/.ssh":"/root/.ssh" -v $(pwd):/terraform --platform=linux/amd64 hashicorp/terraform "terraform init -chdir=/terraform/${PREVDIR}" apply
    cd "${PREVDIR}"
}

#!/bin/bash
# find_and_replace.sh
findreplace() {
    echo "Find and replace in current directory!"
    echo "File pattern to look for? (eg '*.txt')"
    read filepattern
    echo "Existing string?"
    read existing
    echo "Replacement string?"
    read replacement
    echo "Replacing all occurences of $existing with $replacement in files matching $filepattern"

    find . -type f -name $filepattern -print0 | xargs -0 sed -i '' -e "s#$existing#$replacement#g"
}

udmdns() {
    ssh -i "~/.ssh/unifi" "root@192.168.1.1" "pkill dnsmasq"
}


av() {
  case $1 in
    s) export AWS_PROFILE="dev.use1";;
    sw) export AWS_PROFILE="dev.usw2";;
    p) export AWS_PROFILE="prod.use1";;
    pw) export AWS_PROFILE="prod.usw2";;
    pec) export AWS_PROFILE="prod.euc1";;
    pew) export AWS_PROFILE="prod.euw1";;
    b) export AWS_PROFILE="bastion.use1";;
    *) export AWS_PROFILE="$1";;
  esac
}

# Functions
# BEGIN ANSIBLE MANAGED BLOCK: asdf
# if [ -e "$HOME/.asdf/asdf.sh" ]; then
#   source $HOME/.asdf/asdf.sh
#   source $HOME/.asdf/completions/asdf.bash
# fi
# END ANSIBLE MANAGED BLOCK: asdf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

export ASDF_HASHICORP_OVERWRITE_ARCH=amd64

## FUNCTIONS ##
find-asg-instance-ids () {
        local _asg _instances _instance_ids _name
        _name="${1:-.*}"
        _asg=("${(@f)$(_find-asgs ${_name})}")
        _instance_ids=("${(@f)$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${_asg[@]} | jq -er '.AutoScalingGroups[].Instances[].InstanceId')}")
        _instances="$(aws ec2 describe-instances --instance-ids ${_instance_ids[@]} | jq -er '.Reservations[].Instances[] | .PrivateDnsName + " " + .InstanceId')"
        echo "${_instances}" | fzf | awk '{print $2}'
}

_find-asgs () {
        find-asgs "${1}" | fzf -m
}

c() {
    dadir=${HOME}/$(cd && fzf|rev|cut -d'/' -f2- |rev)
    cd "${dadir}" 
}

v() {
    dafile=${HOME}/$(cd && fzf)
    dadir="$(echo ${dafile}|rev|cut -d'/' -f2- |rev)"
    nvim "${dafile}"
    cd "${dadir}"
}

kn() {
    if [[ $(kubectl get ns "${1}" 2>/dev/null) ]]; then
        /usr/local/bin/kubectl config set-context --current --namespace="${1}"
    elif [[ -z "${1}" ]]; then
        kubectl config set-context --current --namespace="$(kubectl get ns |grep -v 'NAME'|fzf|awk '{print $1}')"
    else
        echo "invalid namespace"
    fi
}

kzoe() {
        echo "zoe mode"
        export KUBECONFIG="${HOME}/.kube/config.zoe"
}

kwork() {
        echo "Switched to work mode. You've got this!"
        echo "Say aloud what you are about to do."
        sleep 5
        export KUBECONFIG="${HOME}/.kube/config.gh"
}


lint() {
    cd "${HOME}/Greenhouse/infrastructure"
    SECONDS=0
    PIDS=()
    docker run --rm -v "$(pwd):/todo" --workdir /todo grnhse/circleci-lint:v2.4.1 required &
    PIDS+=($!)
    docker run --rm -v "$(pwd):/todo" --workdir /todo grnhse/circleci-lint:v2.4.1 optional &
    PIDS+=($!)
    RESULT=0
    for p in "${PIDS[@]}"; do
        if ! wait $p; then
            echo "Failure detected"
            RESULT=1
        fi
    done
    echo "Took: $SECONDS seconds to lint"
    exit $RESULT
}

kc() {
    context="$(cat $(echo $KUBECONFIG) |ag -C 3 context: |ag name: |awk '{print $2}'|fzf)"
    /usr/local/bin/kubectl config use-context "${context}"
}

kcrm() {
    if [[ -z "${1}" ]]; then
        echo "usage: kcrm <context name>"
        return
    else
        kubectl config delete-cluster "${1}"
        kubectl config delete-context "${1}"
        kubectl config unset "users.${1}"
    fi
}

tc() {
    contexts=$(cat <<-EOF
grapefruit
EOF
)
    context="$(echo ${contexts} |fzf)"
    talosctl config context "${context}"
}

# kubectl() {
#     # only sort if we are listing objects
#     if [[ $(echo "${@}" |ag "get all") ]]; then
#      /usr/local/bin/kubectl "${@}"
#     elif [[ $(echo "${@}" |ag "get") ]]; then
#      /usr/local/bin/kubectl "${@}" |sort --numeric-sort
#     else
#      /usr/local/bin/kubectl "${@}"
#     fi
# }

ips() {
    kubectl get svc -A | ag '192' | awk '{print $5 " " $2}' | sort -n
}


export AWS_SDK_LOAD_CONFIG=true
#export AWS_DEFAULT_PROFILE="dev.use1"

aws-vault-use() {
    local profile output

    profile="$1"

    output="$(aws-vault exec "$profile" -- env)"
    if [[ $? -ne 0 ]]; then
        echo "$output" >&2
        return 1
    fi

    eval "$(echo "$output" | awk '/^AWS/ && !/^AWS_VAULT/ { print "export " $1 }')"
}

flipstate () {
        to_local () {
                echo "Moving state to local"
                if mv _state.tf _state.tf.local
                then
                        echo "Done"
                        return 0
                else
                        echo "Failed"
                        return 1
                fi
        }
        to_remote () {
                echo "Moving state to remote"
                if mv _state.tf.local _state.tf
                then
                        echo "Done"
                        return 0
                else
                        echo "Failed"
                        return 1
                fi
        }
        if [[ $# -eq 1 ]]
        then
                case "$1" in
                        (local) to_local ;;
                        (remote) to_remote ;;
                esac
        else
                if [[ -f "_state.tf" ]]
                then
                        to_local
                else
                        to_remote
                fi
        fi
}

param () {
	aws ssm get-parameters --with-decryption --names "$(aws ssm get-parameters-by-path --path / --recursive \
  | jq -r '.Parameters[].Name' | fzf)" | jq -er '.Parameters[].Value' | pbcopy
}

get_command_output() {
    aws ssm list-command-invocations \
        --command-id "${1}" \
        --details \
    | jq -r '.CommandInvocations[].CommandPlugins[].Output'
}

tfstatemove() {
    for i in "$(terraform state list |ag 'rbac.kubernetes')"; do
        echo "terraform state mv $i $(echo $i | sed 's/rbac.kubernetes/rbac-okta.kubernetes/g')"
    done

}

# ap() {
# 	case $1 in
#     d) 
#         export AWS_PROFILE="dev.use1"  
#         ;;
#     dw) 
#         export AWS_PROFILE="dev.usw2"  
#         ;;
#     p) 
#         export AWS_PROFILE="prod.use1"  
#         ;;
#     pw) 
#         export AWS_PROFILE="prod.usw2"  
#         ;;
#     pec) 
#         export AWS_PROFILE="prod.euc1"  
#         ;;
#     pew) 
#         export AWS_PROFILE="prod.euw1"  
#         ;;
#     b) 
#         export AWS_PROFILE="bastion.use1"  
#         ;;
#     *) 
#         export AWS_PROFILE="$1"  
#         ;;
# esac
# }

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/zoe.blanco/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zoe.blanco/Greenhouse/infrastructure/docker/zookeeper/google-cloud-sdk/completion.zsh.inc'; fi

alias rotate="aws autoscaling terminate-instance-in-auto-scaling-group \
  --no-should-decrement-desired-capacity --instance-id"

function git-pr-create() {
  local reviewer branch branch_items card
  reviewer="${1:-grnhse/cloud-platform}"

  branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  branch_items=($(echo $branch | tr "-" "\n"))
  card="${branch_items[1]}-${branch_items[2]}"

  gh pr create -t "$branch" -b "https://greenhouseio.atlassian.net/browse/$card" -r "$reviewer" "$@"
  gh pr view --web
}

get-ec2() {
    aws ec2 describe-instances \
        --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
        --output table
}

describe-ec2() {
    aws ec2 describe-instances \
        --output table \
        --filters "Name=tag:Name,Values=${1}"
}

taintmodule() {
  #excluded_resources=('google_compute_address.ip_address')
  excluded_resources=('google_compute_address.ip_address' 'google_compute_disk')

  echo "Tainting all resources in ${module} excluding ${excluded_resources[*]}"
  read -p "Press [Enter] key to start..."

  for resource in $(terraform state list |                    # Get a list of all the 'resources'
                      grep "^module.${module}" |          # Filter to the specific module
                      grep -v "\.module\." |              # Ignore sub modules
                      sed "s/module\.${module}\.//g" |    # replace the module.* to get resource sans module prefix
                      sed -E "s/\[(.*)\]/.\1/g"           # replace the [#] suffix with .# (needed by taint command)
                      ); do
    if array_contains excluded_resources ${resource}; then
      echo "<<< Skipping ${resource} >>>"
    else
        echo "--- Tainting ${resource} ---"
        bash -c "terraform taint --module=${module} `echo ${resource} | tr -d '[:space:]'`"
    fi
  done
}

rotate_asg_instance_by_id () {
        local _instance_id
        _instance_id="${1}"
        if [ -z "${_instance_id}" ]
        then
                echo "Provide an instance ID" >&2
                return 1
        else
                echo "About to delete instance id: ${_instance_id}..." >&2
                sleep 3
                PAGER=cat aws autoscaling terminate-instance-in-auto-scaling-group --no-should-decrement-desired-capacity --instance-id "${_instance_id}"
        fi
}

rotate_asg_instance_by_hostname () {
        local _instance_dns_name _instance_id
        _instance_dns_name="${1}"
        _instance_id="$(aws ec2 describe-instances --filters Name=instance-state-name,Values=pending,running Name=private-dns-name,Values="${_instance_dns_name}" | jq '.Reservations[].Instances[].InstanceId' -r | head -1)"
        if [ -z "${_instance_id}" ]
        then
                echo "Didn't find any instance ID with private dns name: ${_instance_dns_name}" >&2
                return 1
        else
                echo "About to delete instance id: ${_instance_id}..." >&2
                sleep 3
                PAGER=cat aws autoscaling terminate-instance-in-auto-scaling-group --no-should-decrement-desired-capacity --instance-id "${_instance_id}"
        fi
}

ssh-nucs() {
  LAST_WINDOW_ID="$(tmux list-windows |awk '{print $1}' | sed 's/://g' | tail -n 1)"
  NEXT_WINDOW_ID=$((LAST_WINDOW_ID + 1))

  tmux new-window
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ssh -i ~/.ssh/proxmox root@nuc1.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:"${NEXT_WINDOW_ID}" "ssh -i ~/.ssh/proxmox root@nuc2.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:"${NEXT_WINDOW_ID}" "ssh -i ~/.ssh/proxmox root@nuc3.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:"${NEXT_WINDOW_ID}" "ssh -i ~/.ssh/proxmox root@nuc4.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:"${NEXT_WINDOW_ID}" "ssh -i ~/.ssh/proxmox root@nuc5.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:"${NEXT_WINDOW_ID}" "ssh -i ~/.ssh/proxmox root@nuc6.zoe" Enter
  tmux set-window-option -t prezto:"${NEXT_WINDOW_ID}" synchronize-panes
}

ping-nucs() {
  LAST_WINDOW_ID="$(tmux list-windows |awk '{print $1}' | sed 's/://g' | tail -n 1)"
  NEXT_WINDOW_ID=$((LAST_WINDOW_ID + 1))

  tmux new-window
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc1.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc2.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc3.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc4.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc5.zoe" Enter
  tmux split-window -t prezto:"${NEXT_WINDOW_ID}" -v -p 20
  tmux next-layout -t prezto:"${NEXT_WINDOW_ID}"
  tmux send-keys -t prezto:${NEXT_WINDOW_ID} "ping nuc6.zoe" Enter
  tmux set-window-option -t prezto:"${NEXT_WINDOW_ID}" synchronize-panes
}
#compdef cilium
compdef _cilium cilium

# zsh completion for cilium                               -*- shell-script -*-

__cilium_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_cilium()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16
    local shellCompDirectiveKeepOrder=32

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace keepOrder
    local -a completions

    __cilium_debug "\n========= starting completion logic =========="
    __cilium_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __cilium_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __cilium_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., cilium -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __cilium_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __cilium_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __cilium_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __cilium_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __cilium_debug "No directive found.  Setting do default"
        directive=0
    fi

    __cilium_debug "directive: ${directive}"
    __cilium_debug "completions: ${out}"
    __cilium_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __cilium_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __cilium_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __cilium_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __cilium_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __cilium_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __cilium_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveKeepOrder)) -ne 0 ]; then
        __cilium_debug "Activating keep order."
        keepOrder="-V"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __cilium_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __cilium_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __cilium_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __cilium_debug "Calling _describe"
        if eval _describe $keepOrder "completions" completions $flagPrefix $noSpace; then
            __cilium_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __cilium_debug "_describe did not find completions."
            __cilium_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __cilium_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __cilium_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_cilium" ]; then
    _cilium
fi

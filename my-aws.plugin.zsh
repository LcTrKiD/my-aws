# aws sso: auth stage

function gcred() (
  function exists_in_list() {
    VALUE=$1
    shift
    LIST=("$@")
    for x in $LIST 
    do
      if [ "$x" = "$VALUE" ]
      then
        return 0
      fi
    done
    return 1
  }
  env="${1:-NULL}"
  # fail safe i.e. if no $1 passed to the script, die with an error
  if [[ "$env" == "NULL" ]] 
  then
    echo "Usage: $0 environment."
    return 1
  fi
  
  # make sure aws cli is installed else die
  if ! type -a aws &>/dev/null
  then
    echo "Error: $0 - aws cli not found."
    return 2
  fi
  
  if [[ "$env" == "prod" ]]
  then
    env="sso_it_pro_admin"
  fi
  
  if [[ "$env" == "stag" ]]
  then
    env="sso_it_sta_admin"
  fi

  if [[ "$env" == "play" ]]
  then
    env="sso_it_pla_admin"
  fi

  list_of_envs=(sso_it_pro_admin sso_it_sta_admin sso_it_pla_admin)

  if exists_in_list "$env" "${list_of_envs[@]}"
  then
    aws sso login --profile $env
  else
    echo "Profile '"$1"' not found in your aws config. Use 'prod', 'stag' or 'play' instead."
  fi
)

# VNC to AWS Mac mini

alias mmvnc="aws ssm start-session --target i-0e1f71f003ecfbd66 --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"5900\"],\"localPortNumber\":[\"59000\"]}'"

# RDP to AWS Bastion Windows

alias rdpbw="aws ssm start-session --target i-079287c947016c2e7 --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=9000,portNumber=3389""

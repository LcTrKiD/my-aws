# aws-okta: auth stage

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
  
  # make sure aws-okta is installed else die
  if ! type -a aws-okta &>/dev/null
  then
    echo "Error: $0 - aws-okta not found."
    return 2
  fi
  
  if [[ "$env" == "prod" ]]
  then
    env="aws_production_it"
  fi
  
  if [[ "$env" == "stag" ]]
  then
    env="aws_staging_it"
  fi

  if [[ "$env" == "play" ]]
  then
    env="aws_playground_it"
  fi

  list_of_envs=(aws_production_it aws_staging_it aws_playground_it)

  if exists_in_list "$env" "${list_of_envs[@]}"
  then
    aws-okta --mfa-factor-type "push" --mfa-provider "OKTA" exec $env -- $SHELL
  else
    echo "Profile '"$1"' not found in your aws config. Use 'prod', 'stag' or 'play' instead."
  fi
)

# VNC to AWS Mac mini

alias mmvnc="aws ssm start-session --target i-0052d4c93b38ccffb --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"5900\"],\"localPortNumber\":[\"59000\"]}'"

VENV_PATH=$HOME/.venvs

abort() {
  echo "$1" >&2
  false
}

mkvirtualenv() {
    env_name="$1"
    env_path="$VENV_PATH/$env_name"

    if [ -d "$env_path" ]; then
        abort "Virtualenv \"$env_name\" already exists"
    else
        mkdir "$VENV_PATH" 2>/dev/null
        virtualenv "$env_path"
        workon "$env_name"
    fi
}

lsvirtualenv() {
    \ls -1 $VENV_PATH
}

workon() {
    env_name="$1"

    if [ "$VIRTUAL_ENV" = "$VENV_PATH/$env_name" ]; then
      abort "Virtualenv \"$env_name\" already loaded"
    elif [ -z "$env_name" ]; then
      abort "Please provide an environment name"
    elif [ ! -d  "$VENV_PATH/$env_name" ]; then
      abort "Environment \"$env_name\" doesn't exist."
    else
      if [ "$VIRTUAL_ENV" != "" ]; then
        deactivate
      fi
      source "$VENV_PATH/$env_name/bin/activate"
    fi
}

rmvirtualenv() {
    env_name="$1"
    env_path="$VENV_PATH/$env_name"


    if [ -z "$env_name" ]; then
        abort "Please provide an environment name"
    elif [ ! -d "$env_path" ]; then
      abort "Environment \"$env_name\" doesn't exist."
    else
      if [ "$VIRTUAL_ENV" = "$VENV_PATH/$env_name" ]; then
        deactivate
      fi
      echo "Deleting \"$env_name\""
      rm -rf "$env_path"
    fi
}

#!/usr/bin/env bash

SERVER_PATH=/usr/share/minecraft

# If a config file is found in a volume share, copy it over to the server path
if [ -f $SERVER_PATH/config/server.properties ]; then
    cp $SERVER_PATH/config/server.properties $SERVER_PATH/server.properties
fi

# If MC_* ENV variables are set, update the server.properties file
mcEnvs=( "${!MC_@}" )
if [ "${#mcEnvs[@]}" -gt 0 ]; then
  for mcConfig in "${mcEnvs[@]}"; do
    IFS='_' read -ra CONFIG <<< "${mcConfig}"
    key=${CONFIG[1]}
    if [ "${#CONFIG[@]}" -gt 2 ]; then
      for ((i=2; i<${#CONFIG[@]}; i++)); do
        key="${key}-${CONFIG[i]}"
      done
    fi
    value=${!mcConfig}
    echo "Setting $key=$value"
    sed -i "s~^$key=.*~$key=${value}~" $SERVER_PATH/server.properties
  done
fi

exec "$@"
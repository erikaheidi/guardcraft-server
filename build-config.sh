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
    if [ -n "${CONFIG[2]}" ]; then
      key="${CONFIG[1]}-${CONFIG[2]}"
    fi
    value=${!mcConfig}
    echo "Setting $key=$value"
    #sed -i "s/^$key=.*/$key=$value/" $SERVER_PATH/server.properties
  done
fi

exec "$@"
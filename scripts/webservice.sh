#!/bin/bash

if [ "$RUNNER_WEBSERVICE" == "novnc" ]
then
    # Setup noVNC
    sudo apt-get install novnc websockify
    websockify -D \
        --web /usr/share/novnc/ \
        8080 \
        localhost:7582

elif [ "$RUNNER_WEBSERVICE" == "cloud9" ]
then
    # Setup cloud9
    cd ~
    mkdir workspace
    sudo apt-get install python2
    sudo apt-get install nodejs
    git clone https://github.com/c9/core.git c9sdk
    cd c9sdk
    ./scripts/install-sdk.sh
    nodejs ./server.js -p 8080 -l 0.0.0.0 -a linux:$VNC_PASSWORD -w ../workspace &

elif [ "$RUNNER_WEBSERVICE" == "vscode" ]
then
    # Setup code-server (vscode)
    cd ~
    mkdir workspace
    curl -fsSL https://code-server.dev/install.sh | sh
    sudo systemctl start code-server@$USER
    sudo systemctl enable --now code-server@$USER
    sleep 5
    cat /home/runner/.config/code-server/config.yaml
fi

exit
#!/usr/bin/bash

cd /root/server_1
screen -A -m -d -S gmod ./srcds_run -console -game garrysmod +maxplayers 20 +map rp_c24_UNION +host_workshop_collection 2148804710 -tickrate 33 +gamemode ixhl2rp
screen -r

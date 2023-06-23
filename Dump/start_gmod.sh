#!/bin/bash

declare who=$1
declare -A opts=(
	["srv"]="/root/server_1/"
	["players"]="2"
	["map"]="gm_blackwoods2"
)

declare -A workshops=(["clumba"]="2259440712" ["dix"]="2259440712")
declare -A gamemodes=(["clumba"]="w40k" ["dix"]="militaryrp")

if [[ -n $who ]] && [[ -v 'gamemodes[$who]' ]] && [[ -v 'workshops[$who]' ]]; then
	cd ${opts[srv]}
	screen -A -m -d -S gmod ./srcds_run -console -game garrysmod +maxplayers ${opts[players]} +map ${opts[map]} +gamemode ${gamemodes[$who]} +host_workshop_collection ${workshops[$who]}
	screen -r
else
	echo "Не найден данный индекс"
fi

--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Вортигонт");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {"models/vortigaunt.mdl"},
	male = {"models/vortigaunt.mdl"}
};
FACTION.weapons = {
	"cw_vortibeam"
};

FACTION_VORTIGAUNT = FACTION:Register();

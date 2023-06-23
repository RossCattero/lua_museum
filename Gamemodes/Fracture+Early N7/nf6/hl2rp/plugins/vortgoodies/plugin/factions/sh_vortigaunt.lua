--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Вортигонт-раб");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.models = {
	female = {"models/vortigaunt_slave.mdl"},
	male = {"models/vortigaunt_slave.mdl"}
};
FACTION.weapons = {
	"cw_broom"
};

FACTION_VORTSLAVE = FACTION:Register();

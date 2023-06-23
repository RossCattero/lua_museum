--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Муравьиные львы")
FACTION.whitelist = true;
FACTION.useFullName = true;
FACTION.noGas = true;
FACTION.models = {
		male = {"models/AntLion.mdl"},
		female = {"models/AntLion.mdl"}
};

--Called when a player's model should be assigned to the faction.
function FACTION:GetModel(player, character)
	if(character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

FACTION_ANTLION = FACTION:Register();
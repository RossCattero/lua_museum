--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Гражданская Оборона");

FACTION.isCombineFaction = true;
FACTION.whitelist = true;
FACTION.maximumAttributePoints = 40;
FACTION.models = {
	female = {
	"models/hl2rp/metropolice/hl2_femalecp1.mdl"
},
	male = {
	"models/hl2rp/metropolice/hl2_malecp1.mdl"
}
}

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "C17.MPF-RCT:"..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA) then
		if (name) then
			Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d)", "C17.MPF-RCT:%1"), true);
		else
			return false, "Вам нужно указать имя в качестве третьего аргумента!";
		end;
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()));
	end;
	
	local models = self.models[ string.lower( player:QueryCharacter("gender") ) ];
	
	if (models) then
		player:SetCharacterData("Model", models[ math.random(#models) ], true);
	end;
end;

FACTION_MPF = FACTION:Register();
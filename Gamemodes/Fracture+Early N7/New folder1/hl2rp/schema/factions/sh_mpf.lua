--[[
	� CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Гражданская Оборона");

FACTION.isCombineFaction = true;
FACTION.whitelist = true;
FACTION.maxArmor = 100;
FACTION.startChatNoise = "npc/overwatch/radiovoice/on1.wav";
FACTION.endChatNoise = "npc/overwatch/radiovoice/off4.wav";
FACTION.models = {
	female = {
		"models/frp/police/police_female_01.mdl"
	},
	male = {
		"models/frp/police/police_male_02.mdl"
	}
};
for i = 2, 6 do
	if i < 10 then
		table.insert(FACTION.models.female, "models/frp/police/police_female_0"..i..".mdl" )
		Clockwork.animation:AddFemaleHumanModel("models/frp/police/police_female_0"..i..".mdl" )
	else
		table.insert(FACTION.models.female, "models/frp/police/police_female_"..i..".mdl" )
		Clockwork.animation:AddFemaleHumanModel("models/frp/police/police_female_"..i..".mdl" )
	end;
end;
for i = 3, 16 do
	if i < 10 then
		table.insert(FACTION.models.male, "models/frp/police/police_male_0"..i..".mdl" )
	else
		if i != 12 then
			table.insert(FACTION.models.male, "models/frp/police/police_male_"..i..".mdl" )
		end;
	end;
end;

FACTION.startingInv = {
	["handheld_radio"] = 1,
	['cw_stunstick'] = 1
};
FACTION.entRelationship = {
	["npc_combine_s"] = "Like",
	["npc_helicopter"] = "Like",
	["npc_metropolice"] = "Like",
	["npc_manhack"] = "Like",
	["npc_combinedropship"] = "Like",
	["npc_rollermine"] = "Like",
	["npc_stalker"] = "Like",
	["npc_turret_floor"] = "Like",
	["npc_combinegunship"] = "Like",
	["npc_cscanner"] = "Like",
	["npc_clawscanner"] = "Like",
	["npc_strider"] = "Like",
	["npc_turret_ceiling"] = "Like",
	["npc_turret_ground"] = "Like",
	["npc_combine_camera"] = "Like"
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "C17.MPF-RCT:"..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA or faction.name == FACTION_SCANNER) then
		if (name) then
			Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d)", "MPF.%1"), true);
		else
			return false, "You need to specify a name as the third argument!";
		end;
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()));
	end;
	
	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("model", self.models.male[1], true);
	else
		player:SetCharacterData("model", self.models.female[1], true);
	end;
end;

FACTION_MPF = FACTION:Register();

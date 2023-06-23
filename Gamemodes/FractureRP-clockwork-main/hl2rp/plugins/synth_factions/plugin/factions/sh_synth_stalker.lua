local FACTION = Clockwork.faction:New("Сталкер");

FACTION.isCombineFaction = true;
FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = "Male"
FACTION.models = {
	male = {"models/stalker_old.mdl"}
};

FACTION.startingInv = {
	["handheld_radio"] = 1
}; 

FACTION.weapons = {
	'cw_betastalker_weapon'
}

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

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name != FACTION_CITIZEN) then
		return false;
	end;

	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("model", self.models.male[1], true);
	else
		player:SetCharacterData("model", self.models.female[1], true);
	end;
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;


-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	local crmID = math.random(1, 999);

	return "UU-STALKER."..Clockwork.kernel:ZeroNumberToDigits(crmID, 3);
end;

FACTION_STALKER = FACTION:Register();
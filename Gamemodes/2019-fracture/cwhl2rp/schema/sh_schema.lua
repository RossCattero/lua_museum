--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("cl_schema.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_theme.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_schema.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

Schema.customPermits = {};
Schema.avaiblePDAs = {};
Schema.PDAlogs = {};

for k, v in pairs(_file.Find("models/humans/group17/*.mdl", "GAME")) do
	Clockwork.animation:AddMaleHumanModel("models/humans/group17/"..v);
end;

Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp1.mdl")

Clockwork.option:SetKey("intro_background_url", "");
Clockwork.option:SetKey("intro_logo_url", "");
Clockwork.option:SetKey("default_date", {month = 4, year = 2019, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("format_singular_cash", "%a");
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "materials/fracture_logo");
Clockwork.option:SetKey("schema_logo", "materials/fracture_logo");
Clockwork.option:SetKey("format_cash", "%a %n");
Clockwork.option:SetKey("name_box_cash", "Жетоны");
Clockwork.option:SetKey("menu_music", ""); -- music/hl2_song8.mp3
Clockwork.option:SetKey("name_cash", "Жетонов");
Clockwork.option:SetKey("model_cash", "models/coin02.mdl");
Clockwork.option:SetKey("gradient", "hl2rp2/gradient");

Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");
Clockwork.config:ShareKey("business_cost");
Clockwork.config:ShareKey("permits");

Clockwork.quiz:SetEnabled(false);

-- A function to add a custom permit.
function Schema:AddCustomPermit(name, flag, model)
	local formattedName = string.gsub(name, "[%s%p]", "");
	local lowerName = string.lower(name);
	
	self.customPermits[ string.lower(formattedName) ] = {
		model = model,
		name = name,
		flag = flag,
		key = Clockwork.kernel:SetCamelCase(formattedName, true)
	};
end;

-- A function to get if a faction is Combine.
function Schema:IsCombineFaction(faction)
	return (faction == FACTION_MPF or faction == FACTION_OTA);
end;

-- A function to check if a string is a Combine rank.
function Schema:IsStringCombineRank(text, rank)
	if (type(rank) == "table") then
		for k, v in ipairs(rank) do
			if (self:IsStringCombineRank(text, v)) then
				return true;
			end;
		end;
	else
		return string.find(text, "%p"..rank.."%p");
	end;
end;

-- A function to check if a player is a Combine rank.
function Schema:IsPlayerCombineRank(player, rank, realRank)
	local name = player:Name();
	local faction = player:GetFaction();
	
	if (self:IsCombineFaction(faction)) then
		if (type(rank) == "table") then
			for k, v in ipairs(rank) do
				if (self:IsPlayerCombineRank(player, v, realRank)) then
					return true;
				end;
			end;
		else
			return string.find(name, "%p"..rank.."%p");
		end;
	end;

	return false;
end;

function Schema:IsPlayerCombineRankShared(player, rank)
	local sharedVar = player:GetSharedVar("CombineRanke");
	local faction = player:GetFaction();
	
	if (self:IsCombineFaction(faction)) then
		if (type(rank) == "table") then
			for k, v in ipairs(rank) do
				if (self:IsPlayerCombineRank(player, v)) then
					return true;
				end;
			end;
		else
			return rank == sharedVar
		end;
	end;

	return false;
end;

function Schema:GetCombineRank(name)
	local ranks = {
		"RCT",
		"SCN",
		"05",
		"04",
		"03",
		"02",
		"01",
		"EpU",
		"CmR",
		"DvL",
		"SeC"
	};

	for k, v in pairs(ranks) do
		if string.find(name, "%p"..v.."%p") then
			return v;
		end;
	end;

	return "RCT"
end;

function Schema:IsCombineRank(rank)
	local ranks = {
		"RCT",
		"SCN",
		"05",
		"04",
		"03",
		"02",
		"01",
		"EpU",
		"CmR",
		"DvL",
		"SeC"
	};

	if table.HasValue(ranks, rank) then
		return true;
	end;

	return false
end;
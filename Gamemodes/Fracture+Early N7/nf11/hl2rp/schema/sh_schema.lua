--[[
	� CloudSixteen.com do not share, re-distribute or modify
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

Clockwork.animation:AddMaleHumanModel("models/frp/ross_sex.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_01.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_02.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_03.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_04.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_05.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_06.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_07.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_08.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_09.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_10.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_11.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_12.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_13.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_14.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_15.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_16.mdl");
Clockwork.animation:AddCivilProtectionModel("models/frp/police/police_male_17.mdl");

Clockwork.option:SetKey("default_date", {month = 1, year = 2019, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "materials/fracture_logo");
Clockwork.option:SetKey("schema_logo", "materials/fracture_logo");
Clockwork.option:SetKey("menu_music", "");
Clockwork.option:SetKey("name_box_cash", "Жетоны");
Clockwork.option:SetKey("name_cash", "Жетонов");
Clockwork.option:SetKey("model_cash", "models/bioshockinfinite/hext_coin.mdl");
Clockwork.option:SetKey("gradient", "hl2rp2/gradient");

Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");
Clockwork.config:ShareKey("business_cost");
Clockwork.config:ShareKey("permits");

Clockwork.quiz:SetEnabled(false);

Clockwork.command:AddAlias("StorageGiveCash", "StorageGiveTokens");
Clockwork.command:AddAlias("StorageTakeTokens", "StorageTakeTokens");
Clockwork.command:AddAlias("GiveCash", "GiveTokens");
Clockwork.command:AddAlias("DropCash", "DropTokens");
Clockwork.command:AddAlias("SetCash", "SetTokens");

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
	local factionTable = Clockwork.faction:FindByID(faction);

	return factionTable and factionTable.isCombineFaction or false;
end;

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
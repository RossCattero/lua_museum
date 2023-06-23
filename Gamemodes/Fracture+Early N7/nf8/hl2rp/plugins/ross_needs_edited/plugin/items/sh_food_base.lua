local math = math;
local mc = math.Clamp

local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "База еды";
ITEM.weight = 100;
ITEM.category = "Пища";
ITEM.useText = "Употребить";
ITEM.uniqueID = "food_base"

ITEM.hunger = 0;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.damage = 0;
ITEM.type = "food";
ITEM.useAmount = 0;
ITEM.canBeGarbaged = true;

ITEM.useSound = "";

ITEM.cookingBlueprint = {
    ["Жарка"] = {
        hun = 0,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "",
        time = 0
    },
    ["Варка"] = {
        hun = 0,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "",
        time = 0
	},
	["Кипячение"] = {
        hun = 0,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "",
        time = 0
	},
	["Обваривание"] = {
        hun = 0,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "",
        time = 0
	},
	["Объединение"] = {
        hun = 0,
        thirst = 0,
        sleep = 0,
        dirt = 0,
        model = "",
        time = 0
    }
}

ITEM.foodQuality = 0;
ITEM.addDisease = {};
ITEM.CanPick = false;

ITEM:AddData("needs", {
	food = -1,
	thirst = -1,
	sleep = -1,
	damage = -1
}, true);
ITEM:AddData("diseases", {}, true);
ITEM:AddData("useAmount", -1, true);
ITEM:AddData("FoodQuality", -1, true);
ITEM:AddData("Model", "", true);
ITEM:AddData('IsCrafted', false, true)

function ITEM:GetNeedTable()
	return self:GetData("needs")
end;

function ITEM:EmitItemSound(type)
	
	if type == "food" then
		return "npc/barnacle/barnacle_crunch2.wav";
	elseif type == "drink" then
		return "npc/barnacle/barnacle_gulp1.wav"
	end;

	return "";
end;

function ITEM:OnUse(player, itemEntity)
	local needs = self:GetNeedTable();
	local hunger = needs['food'];
	local thirst = needs['thirst'];
	local sleep = needs['sleep'];
	local damage = needs['damage'];
	local pHunger = player:GetNeed("hunger");
	local pThirst = player:GetNeed("thirst");
	local pSleep = player:GetNeed("sleep");
	local uses = self:GetData("useAmount");
	local health = player:Health();
	local maxHealth = player:GetMaxHealth();
	local random = math.random(100);
	local diseases = self:GetData("diseases");
	local quality = self:GetData("FoodQuality");

	if uses > 0 then
		if hunger > 0 then
			player:SetOneNeed("hunger", mc(pHunger + hunger + quality, 0, 100) );
		end;
		if thirst > 0 then
			player:SetOneNeed("thirst", mc(pThirst + thirst + quality, 0, 100) );
		end;
		if sleep > 0 then
			player:SetOneNeed("sleep", mc(pSleep + sleep, 0, 100) );
		end;
		self:SetData("useAmount", mc(uses - 1, 0, uses));
		
		player:EmitSound( self:EmitItemSound(self.type) );

		if damage > 0 then
			player:SetHealth( mc(health - damage, 0, maxHealth) );
		end;
	end;

	if random < 50 then
		Clockwork.attributes:Update(player, ATB_COOK, math.random(0.01, 0.05))
	end;

	if table.Count(diseases) > 0 && random > health then
		for k, v in pairs(diseases) do
			player:AddSympthom(v)
		end;
	end;
	
	if self.canBeGarbaged || uses > 1 then
		return false;
	end;

	return;
end;


function ITEM:CanPickup(player, quickUse, entity)
	local pick = self.CanPick;

	if pick then
		if pick == false then
			return false;
		end;
	end;

	return true;
end;

function ITEM:OnDrop(player, position) end;

if SERVER then

	function ITEM:OnInstantiated()
		local needs = self:GetNeedTable();
		local uses = self:GetData("useAmount");
		local foodq = self:GetData("FoodQuality");
		local dis = self:GetData("diseases");
		local model = self:GetData("Model");

		if needs['food'] == -1 then
			needs['food'] = self.hunger;
		end;
		if needs['thirst'] == -1 then
			needs['thirst'] = self.thirst;
		end;
		if needs['sleep'] == -1 then
			needs['sleep'] = self.sleep;
		end;
		if needs['damage'] == -1 then
			needs['damage'] = self.damage;
		end;
		if model == "" then
			self:SetData("Model", self.model);
		end;
		if uses == -1 then
			self:SetData("useAmount", self.useAmount)
		end;
		if foodq == -1 then
			self:SetData("FoodQuality", self.foodQuality)
		end;
		if type(dis) == "table" && table.Count(dis) == 0 then
			self:SetData("diseases", self.addDisease);
		end;
    end;

else

	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;
		
		local portions = self:GetData("useAmount");
		local canGar = self.canBeGarbaged;
        local clientSideInfo = "";

        if portions > 0 then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество порций: "..portions, Color(190, 150, 150));
		elseif canGar && portions == 0 then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Мусор.", Color(190, 150, 150));
        end;

        return (clientSideInfo != "" and clientSideInfo);
    end;

	function ITEM:GetClientSideModel()
		local model = self:GetData("Model");
        return model;
	end;

end;

ITEM:Register();
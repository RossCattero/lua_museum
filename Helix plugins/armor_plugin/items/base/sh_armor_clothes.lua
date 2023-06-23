local PLUGIN = PLUGIN;

ITEM.name = "Clothes base"
ITEM.description = "- - -"
ITEM.model = "models/props_junk/cardboard_box003a.mdl"
ITEM.category = 'Одежда'
// Для армора, регена брони и прочего
ITEM.features = { 
	level = 1, // В зависимости от уровня броня будет больше или меньше получать урона. 1 - 3 ур.
	maxArmor = 50,
	regen = 5,
	tick = 2, // Сколько секунд надо подождать, чтобы реген начался;
	walk = 5, // + или - к скорости ходьбы
	sprint = 5, // + или - к скорости бега
} 
// Таблица защиты; 0 - 100
ITEM.protections = { 
	["fire"] = 10, 
	["bullets"] = 100,
} // Защита и параметры
ITEM.slot = "body";
ITEM.useSound = "items/ammopickup.wav"

ITEM.changeSkin = 0;
ITEM.changeBGs = {
	["torso"] = 3,
}

ITEM.functions.WearArmor = {
		name = "Надеть",
		OnRun = function(self)
			local client = self.player
			local char = client:GetCharacter()
			local features = self:GetData("Features")
			local data = {}
			data = features;
			data.uniqueID = self.uniqueID;
			data.protections = self.protections;

			client:ArmorEquip(self.slot, data)
			
			local bgs = char:GetData("Bodygroups", {})
			for k, v in pairs(self.changeBGs) do
					local bg = client:FindBodygroupByName(k)
					client:SetBodygroup(bg, v);
					bgs[k] = v
			end
			char:SetData("Bodygroups", bgs);

			local skin = char:GetData("Skin", 0)
			client:SetSkin(self.changeSkin)
			char:SetData("Skin", skin);

			client:EmitSound(self.useSound)
		end,
		OnCanRun = function(self)
			local client = self.player;
			return !client:HaveArmorInSlot(self.slot);
		end
}

function ITEM:OnInstanced()
		if !self:GetData("Features") then
				self.features.level = math.Clamp(self.features.level, PLUGIN.minlvl, PLUGIN.maxlvl)
				self.features.armor = self.features.maxArmor;

				self:SetData("Features", self.features);
		end;
end;
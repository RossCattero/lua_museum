--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Магазин для Штурмовых Винтовок";
	ITEM.model = "models/frp/props/models/rif_aug_mag.mdl";
	ITEM.weight = 0.6;
	ITEM.category = "Боеприпасы";
	ITEM.uniqueID = "tfa_ammo_ar2";
	ITEM.ammoClass = "ar2";
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.ammoAmount = 30;
	ITEM.description = "Универсальный магазин с патронами для штурмовых винтовок.";

function ITEM:CanPickup(player)
	if (player:HasItemByID(self.uniqueID) and table.Count(player:GetItemsByID(self.uniqueID)) >= 5) then
		player:Notify("У вас слишком много обойм для штурмовых винтовок!")

		return false
	end
end

function ITEM:OnUse(player, itemEntity)
	local ammocount = player:GetAmmoCount(ITEM.ammoClass)

	if ammocount >= 90 then
		player:Notify("Вы носите слишком много обойм!")

		return false
	end

	local secondaryAmmoClass = self("secondaryAmmoClass")
	local primaryAmmoClass = self("primaryAmmoClass")
	local ammoAmount = self("ammoAmount")
	local ammoClass = self("ammoClass")

	for k, v in pairs(player:GetWeapons()) do
		local itemTable = Clockwork.item:GetByWeapon(v)

		if (itemTable and (itemTable.primaryAmmoClass == ammoClass or itemTable.secondaryAmmoClass == ammoClass)) then
			player:GiveAmmo(ammoAmount, ammoClass)

			return
		end
	end

	Clockwork.player:Notify(player, "Вам нужно иметь оружие, которое использует эту аммуницию!")

	return false
end
ITEM:Register();
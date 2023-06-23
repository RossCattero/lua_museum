--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Коробка с Патронами 12 Калибра";
	ITEM.model = "models/Items/BoxBuckshot.mdl";
	ITEM.weight = 0.7;
	ITEM.uniqueID = "tfa_ammo_buckshot";
	ITEM.ammoClass = "buckshot";
	ITEM.category = "Боеприпасы";
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.ammoAmount = 16;
	ITEM.description = "Коробка с патронами 12 Калибра.";

function ITEM:CanPickup(player)
	if (player:HasItemByID(self.uniqueID) and table.Count(player:GetItemsByID(self.uniqueID)) >= 5) then
		player:Notify("У вас слишком много коробок с дробью!")

		return false
	end
end

function ITEM:OnUse(player, itemEntity)
	local ammocount = player:GetAmmoCount(ITEM.ammoClass)

	if ammocount >= 30 then
		player:Notify("У вас слишком много патронов!")

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

	Clockwork.player:Notify(player, "Вам нужно взять оружие, которое использует эту аммуницию!")

	return false
end
ITEM:Register();
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Обойма для Пистолетов";
	ITEM.model = "models/frp/props/models/pist_glock18_mag.mdl";
	ITEM.weight = 0.3;
	ITEM.category = "Боеприпасы";
	ITEM.uniqueID = "tfa_ammo_pistol";
	ITEM.ammoClass = "pistol";
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.ammoAmount = 15;
	ITEM.description = "Обойма с универсальными патронами для пистолетов.";

function ITEM:CanPickup(player)
	if (player:HasItemByID(self.uniqueID) and table.Count(player:GetItemsByID(self.uniqueID)) >= 5) then
		player:Notify("У вас слишком много обойм для пистолета!")

		return false
	end
end

function ITEM:OnUse(player, itemEntity)
	local ammocount = player:GetAmmoCount(ITEM.ammoClass)

	if ammocount >= 60 then
		player:Notify("У вас слишком много обойм для пистолета!")

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

	Clockwork.player:Notify(player, "Вам нужно взять оружие, которое использует данную аммуницию!")

	return false
end

ITEM:Register()
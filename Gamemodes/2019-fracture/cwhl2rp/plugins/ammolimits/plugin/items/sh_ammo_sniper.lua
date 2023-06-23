--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "Обойма для Снайперских Винтовок";
	ITEM.model = "models/frp/props/models/snip_g3sg1_mag.mdl";
	ITEM.weight = 0.6;
	ITEM.uniqueID = "tfa_ammo_sniper_rounds";
	ITEM.ammoClass = "SniperPenetratedRound";
	ITEM.ammoAmount = 20;
        ITEM.useSound = "items/ammo_pickup.wav";
	ITEM.category = "Боеприпасы";
	ITEM.description = "Обойма с универсальными патронами для снайперских винтовок.";

function ITEM:CanPickup(player)
	if (player:HasItemByID(self.uniqueID) and table.Count(player:GetItemsByID(self.uniqueID)) >= 5) then
		player:Notify("У вас слишком много снайперских обойм!")

		return false
	end
end

function ITEM:OnUse(player, itemEntity)
	local ammocount = player:GetAmmoCount(ITEM.ammoClass)

	if ammocount >= 20 then
		player:Notify("У вас слишком много снайперских патрон!")

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
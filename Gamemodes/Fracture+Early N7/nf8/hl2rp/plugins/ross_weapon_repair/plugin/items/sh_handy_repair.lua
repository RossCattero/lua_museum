local math = math;
local mc = math.Clamp
local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "База ручных наборов";
ITEM.weight = 1;
ITEM.model = "models/devcon/mrp/props/weapon_shipment.mdl";
ITEM.category = "Починка";
ITEM.uniqueID = "repair_base";
ITEM.useText = "Открыть";
ITEM.toolsQuality = 100;
ITEM.repairPlus = 10;
ITEM.weaponAllowed = {
	assault = false,
	shotgun = false,
	pistols = false,
	melee = false
};
ITEM.minimumToRepair = 20;

ITEM:AddData('RepQuality', -1, true);
ITEM:AddData('AmountOfRepair', -1, true);
ITEM:AddData('WeaponsAllowed', -1, true);
ITEM:AddData('MinimumWeapon', -1, true);

function ITEM:OnDrop(player, position) end;

function ITEM:OnUse(player, itemEntity)
	local inventory = {};
	local repairInfo = {
		q = self:GetData('RepQuality'),
		a = self:GetData('AmountOfRepair') + Clockwork.attributes:Get(player, ATB_COLLECTING),
		w = self:GetData('WeaponsAllowed'),
		m = self:GetData('MinimumWeapon'),
		id = self.uniqueID
	};

	for k, v in ipairs(Clockwork.inventory:GetAsItemsList(player:GetInventory())) do
		if v:IsBasedFrom("weapon_base") && !v:GetData('Mag') && !string.StartWith(v.uniqueID, 'cw_') then
			inventory[v.itemID] = {
				uniqueID = v.uniqueID,
				quality = v:GetData('Quality'),
				WepType = GetWeaponTFAtype(v.uniqueID)
			}
		end;
	end;

	cable.send(player, 'OpenRepairWeapons', inventory, repairInfo)
	return false;
end;

if SERVER then

	function ITEM:OnInstantiated()

		local tq = self:GetData('RepQuality');
		local rp = self:GetData('AmountOfRepair');
		local wa = self:GetData('WeaponsAllowed');
		local mw = self:GetData('MinimumWeapon');

		if tq == -1 then
			self:SetData('RepQuality', self.toolsQuality)
		end;
		if rp == -1 then
			self:SetData('AmountOfRepair', self.repairPlus)
		end;
		if wa == -1 then
			self:SetData('WeaponsAllowed', self.weaponAllowed)
		end;
		if mw == -1 then
			self:SetData('MinimumWeapon', self.minimumToRepair)
		end;

    end;

end;

ITEM:Register();
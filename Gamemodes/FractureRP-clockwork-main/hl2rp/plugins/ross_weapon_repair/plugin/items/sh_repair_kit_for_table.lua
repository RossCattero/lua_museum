local ITEM = Clockwork.item:New();
ITEM.name = "Набор для починки";
ITEM.model = "models/devcon/mrp/props/weapon_shipment.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "repair_kit_table";
ITEM.category = "Починка";

ITEM:AddData("RepQua", 100, true);

function ITEM:OnDrop(player, position) end;

ITEM:Register();
local ITEM = Clockwork.item:New();
ITEM.name = "Газовый баллон";
ITEM.model = "models/props_junk/PropaneCanister001a.mdl";
ITEM.weight = 2;
ITEM.uniqueID = "gas_fuel_tank";
ITEM.category = "Прочее";

ITEM:AddData("Fuel", 1000, true);

function ITEM:OnDrop(player, position) end;

ITEM:Register();
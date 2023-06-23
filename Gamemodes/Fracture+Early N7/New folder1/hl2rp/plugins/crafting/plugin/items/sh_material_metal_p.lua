local ITEM = Clockwork.item:New();
ITEM.name = "Железная часть";
ITEM.model = "models/props_debris/rebar_smallnorm01c.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "materials_metal_p";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

ITEM:Register();
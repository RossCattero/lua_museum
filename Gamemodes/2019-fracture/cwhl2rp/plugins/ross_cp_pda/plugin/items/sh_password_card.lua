local ITEM = Clockwork.item:New();
ITEM.name = "Карта доступа";
ITEM.model = "models/gibs/metal_gib4.mdl";
ITEM.weight = 0.01;
ITEM.uniqueID = "pda_password_edit";
ITEM.category = "Прочее";

ITEM:AddData("PasswordEdited", false, true);

function ITEM:OnDrop(player, position) end;

ITEM:Register();
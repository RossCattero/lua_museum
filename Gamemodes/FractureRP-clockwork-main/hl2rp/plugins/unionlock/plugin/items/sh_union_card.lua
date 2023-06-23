local ITEM = Clockwork.item:New();
ITEM.name = "Карточка доступа";
ITEM.category = "Карточки";
ITEM.model = "models/gibs/metal_gib4.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "union_card"
ITEM.description = "Карточка, дающая доступ к замкам UU.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();
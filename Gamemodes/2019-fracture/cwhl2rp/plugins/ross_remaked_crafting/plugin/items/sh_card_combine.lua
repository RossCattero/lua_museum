local ITEM = Clockwork.item:New();
ITEM.name = "Гражданская карточка";
ITEM.model = "models/dorado/tarjeta4.mdl";
ITEM.weight = 0.01;
ITEM.uniqueID = "citizen_civ_card";
ITEM.category = "Прочее";

ITEM:AddData("CardInformation", {
    OwnerName = "",
    OwnerCID = 00000,
    Rations = 0,
    CooldownRations = 0,
    OL = 0,
    ON = 0
}, true)

function ITEM:OnDrop(player, position) end;

ITEM:Register();
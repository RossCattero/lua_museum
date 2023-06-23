local ITEM = Clockwork.item:New();
ITEM.name = "Кулинарная книга";
ITEM.model = "models/props_lab/binderredlabel.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "book_kulinar";
ITEM.category = "Прочее";
ITEM.customFunctions = {"Посмотреть"};

function ITEM:OnDrop(player, position) end;

if SERVER then
    if (funcName == "Посмотреть") then
        -- cable.send(player, 'OpenKitchenBook')
    end;
end;


ITEM:Register();
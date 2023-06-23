local ITEM = Clockwork.item:New();
ITEM.name = "Стиральный наполнитель";
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "analog_bleach";
ITEM.category = "Прочее";

ITEM:AddData("Clean", 5, true);

function ITEM:OnDrop(player, position) end;

if (CLIENT) then

    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество наполнителя: "..self:GetData("Clean"), Color(120, 120, 255));
        
        return (clientSideInfo != "" and clientSideInfo);
    end;

end;

ITEM:Register();
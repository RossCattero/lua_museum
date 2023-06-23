local ITEM = Clockwork.item:New();
ITEM.name = "Батарея";
ITEM.weight = 0.3;
ITEM.uniqueID = "item_battery_charger";
ITEM.model = "models/Items/battery.mdl"

ITEM:AddData('ArmorCapacity', 100, true);

function ITEM:OnDrop(player, position) end;

if CLIENT then
    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Заряд: "..self:GetData("ArmorCapacity"), Color(100, 100, 255));
        
        return (clientSideInfo != "" and clientSideInfo);
    end;
end;

ITEM:Register();
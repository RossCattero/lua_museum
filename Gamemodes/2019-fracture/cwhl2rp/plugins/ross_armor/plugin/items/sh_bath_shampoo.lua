local ITEM = Clockwork.item:New();
ITEM.name = "Шампунь 'Союз'";
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.weight = 0.3;
ITEM.uniqueID = "shampoo_body";
ITEM.category = "Прочее";

ITEM:AddData("Uses", 5, true);

local function isNearFullBath(player)
    for k, v in ipairs( ents.FindInSphere(player:GetPos(), 20) ) do
		if v:IsValid() && v:GetClass() == "human_bath" && v:GetWaterLevel() == 60 && !v:GetWaterFall() then
			return true
		end;
    end;
    return false;
end;

local function CheckClothesWearing(player)
    local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());
    for k, v in ipairs( items ) do
        if git(ent, "baseItem") == "clothes_base" && v:GetData("Used") then
            return false;
        end;
    end;
    return true;
end;

function ITEM:OnUse(player, itemEntity)
    local shamUse = self:GetData("Uses");

    if shamUse > 0 && isNearFullBath(player) && CheckClothesWearing(player) then
        Clockwork.player:SetAction(player, "cleanSelf", 10, 2, function()
            if isNearFullBath(player) && shamUse > 0 then
                self:SetData("Uses", math.Clamp(shamUse - 1, 0, 5));
                player:SetNeed("clean", math.Clamp(player:GetNeed("clean") - 25, 0, 100));
            end;
            Clockwork.player:SetAction(player, "cleanSelf", false);
        end);
    else
        Clockwork.chatBox:SendColored(player, Color(200, 100, 100), "Вы не рядом с ванной/У вас не хватает шампуня или вы носите какую-то одежду!")
    end;
        
    return false;
end;

function ITEM:OnDrop(player, position) end;

if (CLIENT) then

    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество использований: "..self:GetData("Uses"), Color(120, 120, 255));
        
        return (clientSideInfo != "" and clientSideInfo);
    end;

end;

ITEM:Register();
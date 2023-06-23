local ITEM = Clockwork.item:New();
ITEM.name = "Гражданская карточка";
ITEM.model = "models/dorado/tarjeta4.mdl";
ITEM.weight = 0.01;
ITEM.uniqueID = "citizen_civ_card";
ITEM.category = "Прочее";
ITEM.useText = 'Поднести карточку'

ITEM:AddData("CardInformation", {
    OwnerName = "",
    OwnerCID = 00000,
    Rations = 0,
    CooldownRations = 0,
    OL = 0,
    ON = 0
}, true)

function ITEM:OnDrop(player, position) end;

function ITEM:OnUse(player, entity)
    local trace = player:GetEyeTraceNoCursor();
    local ent = trace.Entity;

    if ent:GetClass() == 'ross_cp_callmonitor' && ent:GetTimeLeft() == 0 then
        ent:SetTimeLeft(76)
        Schema:AddCombineDisplayLine("Монитор: #"..ent:GetNumberDone()..". Запрос помощи!", Color(255, 255, 255, 255), nil, player);
    end;
    return false;
end;

ITEM:Register();
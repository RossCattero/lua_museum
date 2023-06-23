local ITEM = Clockwork.item:New();
ITEM.name = "Набор для шитья";
ITEM.model = "models/sewing_kit_a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "ross_sewing_kit";
ITEM.category = "Прочее";
ITEM.customFunctions = {"Добавить нитки"};

ITEM:AddData('Webs', 0, true)

function ITEM:OnEditFunctions(functions)
    local inv = Clockwork.inventory:GetClient();
    local tr = Clockwork.Client:GetEyeTraceNoCursor();
    local ent = tr.Entity;
    if ent && ent:GetClass() == 'cw_item' then
        ent = ent:GetClass() == 'cw_item' && ent:GetItemTable().uniqueID == 'materials_sewing_net'
    end;

    if self:GetData('Webs') > 0 && (!Clockwork.inventory:HasItemByID(inv, 'materials_sewing_net') || !ent) then
        self.customFunctions = nil;
    end;
end;

function ITEM:OnDrop(player, position) end;
if SERVER then
    function ITEM:OnCustomFunction(player, f)
        local netent = player:GetEyeTraceNoCursor().Entity;
        if f == 'Добавить нитки' then
            if self:GetData('Webs') < 100 then
                if player:HasItemByID('materials_sewing_net') then
                    player:TakeItemByID('materials_sewing_net')
                    self:SetData('Webs', 100)
                elseif !player:HasItemByID('materials_sewing_net') then
                    if netent:GetClass() == 'cw_item' && netent:GetItemTable().uniqueID == 'materials_sewing_net' then
                        netent:Remove()
                        self:SetData('Webs', 100)
                    end;
                end;
            end;
        end;
    end;
else
    function ITEM:GetClientSideInfo()
        if (!self:IsInstance()) then return; end;
        local clientSideInfo = "";
        local webs = tostring(self:GetData('Webs'));

        clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Количество нити: "..webs.." %", Color(100, 100, 255));
        return (clientSideInfo != "" and clientSideInfo);
    end;
end;

ITEM:Register();
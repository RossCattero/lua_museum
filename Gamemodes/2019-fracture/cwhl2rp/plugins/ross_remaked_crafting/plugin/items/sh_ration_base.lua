local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "База рационов";
ITEM.model = "models/weapons/w_package.mdl";
ITEM.weight = 50;
ITEM.uniqueID = "ration_base";
ITEM.category = "Рационы";
ITEM.rationContains = {
    cash = 0,
    items = {}
}

function ITEM:OnUse(player, itemEntity)
    local cashNum = self.rationContains["cash"];
    local itemsTbl = self.rationContains["items"];
    local countTblItems = table.Count(self.rationContains["items"]);
    local trace = player:GetEyeTraceNoCursor();
    local hitPost = trace.HitPos;

    if self.rationContains["cash"] > 0 then
        Clockwork.player:GiveCash(player, self.rationContains["cash"])
        self.rationContains["cash"] = 0
    end;
    if countTblItems > 0 then
        for k, v in pairs(self.rationContains["items"]) do
            if Clockwork.item:FindByID(v).weight + player:GetInventoryWeight() < player:GetMaxWeight() then
                player:GiveItem(Clockwork.item:CreateInstance(v));
                table.RemoveByValue(self.rationContains["items"], v)
            elseif Clockwork.item:FindByID(v).weight + player:GetInventoryWeight() > player:GetMaxWeight() && player:GetShootPos():Distance(trace.HitPos) <= 192 then
                Clockwork.entity:CreateItem(self, Clockwork.item:CreateInstance(v, nil, v("data")), hitPost);
                table.RemoveByValue(self.rationContains["items"], v)
            else
                break;
            end;
        end;
    end;
    return false;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();
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
            player:GiveItem(Clockwork.item:CreateInstance(v), true);
            table.RemoveByValue(self.rationContains["items"], v)
        end;
    end;
    return false;
end;

function ITEM:OnDrop(player, position) end;

ITEM:Register();
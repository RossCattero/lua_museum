ITEM.name = "Медицина"
ITEM.description = "База медицины"
ITEM.model = "models/union/props/ai2.mdl"
ITEM.weight = 0.1
ITEM.addHealth = 0;
ITEM.uses = 1;

ITEM.functions.Medic = {
    name = "Принять аптечку",
    OnRun = function(item)
        local uses = item:GetData('uses');
        local client = item.player;
        local health = client:Health()

        client:SetHealth(math.Clamp(health + item.addHealth, 0, client:GetMaxHealth()))
        item:SetData('uses', math.Clamp(uses - 1, 0, item.uses))

        if uses > 1 then
            return false;
        end;
    end,
    OnCanRun = function(item)
       
    end
}

function ITEM:OnInstanced()
    if !self:GetData('uses') then
        self:SetData('uses', self.uses or 0);
    end;
end;
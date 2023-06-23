local math = math;
local m = math.Clamp;

ITEM.name = "База еды"
ITEM.description = ""
ITEM.model = "models/props_c17/oildrum001.mdl"
ITEM.category = 'Пища'

ITEM.hunger = 0;
ITEM.thirst = 0;
ITEM.sleep = 0;

ITEM.uses = 0;

ITEM.foodtype = ''; -- food/drink;
ITEM.canGarbage = false;

if (CLIENT) then
    function ITEM:PopulateTooltip(tooltip)
        if !self:GetData('IsGarbage') then
            local name = tooltip:AddRowAfter("description", "FoodAmount")
            name:SetText("Количество использований: "..self:GetData('USES', 0)..".")
            name:SizeToContents()
            
            tooltip:SizeToContents()
        end
    end
end

ITEM.functions.EatUp = {
    name = "Съесть",
    OnRun = function(item)
        local client = item.player;
        local h = client:GetLocalVar('hunger');
        client:SetLocalVar('hunger', m(h + item:GetData('hunger'), 0, 100));
        client:EmitSound('usesound/eatfood.wav')
        if item.canGarbage then item:SetData('IsGarbage', true) return false end;
    end,
    OnCanRun = function(item) return item.foodtype == 'food' && !item:GetData('IsGarbage') end
}

ITEM.functions.EatABit = {
    name = "Съесть немного",
    OnRun = function(item)
        local client = item.player;
        local amount = item:GetData('USES', 0)
        local h = client:GetLocalVar('hunger'); 
        local itemhunger = item:GetData('hunger');
        local addme = itemhunger/amount
        if amount == 1 or amount == 0 then return; end;

        client:SetLocalVar('hunger', m(h + addme, 0, 100));
        item:SetData('hunger', m(itemhunger - addme, 1, item.uses))
        item:SetData('USES', m(amount - 1, 1, item.uses))
        
        client:EmitSound('usesound/eatfood.wav')

        return false;
    end,
    OnCanRun = function(item) local amount = item:GetData('USES', 0) return item.foodtype == 'food' && (amount > 1 and amount != 0) && !item:GetData('IsGarbage') end
}

ITEM.functions.DrinkDown = {
    name = "Выпить",
    OnRun = function(item)
        local client = item.player;
        local t = client:GetLocalVar('thirst');
        client:SetLocalVar('thirst', m(t + item.thirst, 0, 100))
        client:EmitSound('usesound/softdrink.wav')
        if item.canGarbage then item:SetData('IsGarbage', true) return false end;
    end,
    OnCanRun = function(item) return item.foodtype == 'drink' && !item:GetData('IsGarbage') end
}

ITEM.functions.DrinkABit = {
    name = "Выпить немного",
    OnRun = function(item)
        local client = item.player;
        local amount = item:GetData('USES', 0)
        local h = client:GetLocalVar('thirst'); 
        local itemhunger = item:GetData('thirst');
        local addme = itemhunger/amount
        if amount == 1 or amount == 0 then return; end;

        client:SetLocalVar('thirst', m(h + addme, 0, 100));
        item:SetData('thirst', m(itemhunger - addme, 1, item.uses))
        item:SetData('USES', m(amount - 1, 1, item.uses))
        
        client:EmitSound('usesound/softdrink.wav')
        return false;
    end,
    OnCanRun = function(item) local amount = item:GetData('USES', 0) return item.foodtype == 'drink' && (amount > 1 and amount != 0) && !item:GetData('IsGarbage') end
}

function ITEM:OnInstanced()
    if !self:GetData('USES') then
        self:SetData('USES', self.uses or 0);
        self:SetData('hunger', self.hunger)
        self:SetData('thirst', self.thirst)
        self:SetData('sleep', self.sleep)
        self:SetData('IsGarbage', false)
    end;
end;
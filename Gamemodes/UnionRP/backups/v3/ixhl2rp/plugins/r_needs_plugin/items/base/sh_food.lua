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
        local h = client:GetHunger();
        local s = client:GetSleep(); 

        local itemsleep = item:GetData('sleep');
        local itemhunger = item:GetData('hunger');
        
        client:SetHunger(m(h + itemhunger, 0, 125))
        client:SetSleep(m(s + itemsleep, 0, 125));

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
        local h = client:GetHunger();
        local s = client:GetSleep(); 
        local itemhunger = item:GetData('hunger');
        local itemsleep = item:GetData('sleep');
        local addme = itemhunger/amount
        local addme1 = itemsleep/amount
        if amount == 1 or amount == 0 then return; end;

        client:SetHunger(m(h + addme, 0, 125));
        client:SetSleep(m(s + addme, 0, 125));
        item:SetData('thirst', m(itemhunger - addme, 1, item.thirst))
        item:SetData('sleep', m(itemsleep - addme1, 1, item.sleep))
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
        local t = client:GetThirst();
        local s = client:GetSleep(); 

        local itemsleep = item:GetData('sleep');
        local itemthirst = item:GetData('thirst');
        
        client:SetThirst(m(t + itemthirst, 0, 125))
        client:SetSleep(m(s + itemsleep, 0, 125));

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
        local t = client:GetThirst();
        local s = client:GetSleep(); 
        local itemthirst = item:GetData('thirst');
        local itemsleep = item:GetData('sleep');
        local addme = itemthirst/amount
        local addme1 = itemsleep/amount
        if amount == 1 or amount == 0 then return; end;

        client:SetThirst(m(t + addme, 0, 125));
        client:SetSleep(m(s + addme, 0, 125));
        item:SetData('thirst', m(itemthirst - addme, 1, item.thirst))
        item:SetData('sleep', m(itemsleep - addme1, 1, item.sleep))
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

if CLIENT then
    function ITEM:GetAdditionalInfo(x, y, alpha, font, data)
        if data['USES'] > 0 then
            ix.util.DrawText('Количество использований: '..data['USES'], x, y, ColorAlpha(Color(100, 100, 255), alpha), 1, 1, font)
        else
            ix.util.DrawText('Количество использований: Мусор.', x, y, ColorAlpha(Color(100, 100, 255), alpha), 1, 1, font)
        end;
    end;
end;
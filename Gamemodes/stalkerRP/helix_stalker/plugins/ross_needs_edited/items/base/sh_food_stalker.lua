
ITEM.name = "Пища"
ITEM.description = "Пища"
ITEM.category = "Пища"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.1
ITEM.hunger = 0;
ITEM.thirst = 0;
ITEM.sleep = 0;
ITEM.health = 0;

ITEM.foodtype = ""
ITEM.useamount = 1;
ITEM.canGarbage = false;

ITEM.refillable = false;

function ITEM:OnInstanced()
    
    if !self:GetData('hunger') then
        self:SetData('hunger', self.hunger)
    end;
    if !self:GetData('thirst') then
        self:SetData('thirst', self.thirst)
    end;
    if !self:GetData('sleep') then
        self:SetData('sleep', self.sleep)
    end;
    if !self:GetData('health') then
        self:SetData('health', self.health)
    end;
    if !self:GetData('useamount') then
        self:SetData('useamount', self.useamount)
    end;
    if !self:GetData("IsGarbage") then
        self:SetData('IsGarbage', false)
    end;

    if self:GetData('useamount', 1) == 1 && self.canGarbage then
        self:SetData("IsGarbage", true)
    end;
    
end;

ITEM.functions.OnEat = {
    name = "Съесть",
    OnRun = function(item)
     local player = item.player;
     player:EmitSound('stalker/interface/inv_food.mp3')
     player:SetHunger(math.Clamp( player:GetLocalVar('hunger') + item:GetData('hunger'), 0, 100 ))
     player:SetThirst(math.Clamp( player:GetLocalVar('thirst') + item:GetData('thirst'), 0, 100 ))
     player:SetSleep(math.Clamp( player:GetLocalVar('sleep') + item:GetData('sleep'), 0, 100 ))
     player:SetHealth(math.Clamp( player:Health() + item:GetData('health'), 0, 100 ))
     item:SetData('useamount', 1)
     if !item.canGarbage then player:GetCharacter():RemoveCarry(item) return true;
     elseif item.canGarbage then item:SetData('IsGarbage', true) return false; end;
    end,
    OnCanRun = function(item)
       return item.foodtype == 'food' && !item:GetData("IsGarbage")
    end
}
ITEM.functions.OnEatx1 = {
    name = "Съесть часть",
    OnRun = function(item)
     local player = item.player;
     player:EmitSound('npc/barnacle/barnacle_crunch2.wav')
     player:SetHunger(math.Clamp( player:GetLocalVar('hunger') + item:GetData('hunger')/item:GetData('useamount'), 0, 100 ))
     item:SetData('hunger', item:GetData('hunger')/item:GetData('useamount'))
     player:SetThirst(math.Clamp( player:GetLocalVar('thirst') + item:GetData('thirst')/item:GetData('useamount'), 0, 100 ))
     item:SetData('thirst', item:GetData('thirst')/item:GetData('useamount'))
     player:SetSleep(math.Clamp( player:GetLocalVar('sleep') + item:GetData('sleep')/item:GetData('useamount'), 0, 100 ))
     item:SetData('sleep', item:GetData('sleep')/item:GetData('useamount'))
     player:SetHealth(math.Clamp( player:Health() + item:GetData('health'), 0, 100 ))

     item:SetData('useamount', math.Clamp(item:GetData('useamount') - 1, 1, 100))
    
    return false;
    end,
    OnCanRun = function(item)
       return item.foodtype == 'food' && item:GetData('useamount') > 1 && !item:GetData("IsGarbage")
    end
}
ITEM.functions.OnDrink = {
    name = "Выпить",
    OnRun = function(item)
     local player = item.player;
     player:EmitSound('stalker/interface/inv_softdrink.mp3')
     player:SetHunger(math.Clamp( player:GetLocalVar('hunger') + item:GetData('hunger'), 0, 100 ))
     player:SetThirst(math.Clamp( player:GetLocalVar('thirst') + item:GetData('thirst'), 0, 100 ))
     player:SetSleep(math.Clamp( player:GetLocalVar('sleep') + item:GetData('sleep'), 0, 100 ))
     player:SetHealth(math.Clamp( player:Health() + item:GetData('health'), 0, 100 ))

     item:SetData('useamount', 1)
     if !item.canGarbage then player:GetCharacter():RemoveCarry(item) return true;
     elseif item.canGarbage then item:SetData('IsGarbage', true) return false; end;
    end,
    OnCanRun = function(item)
        return item.foodtype == 'drink' && !item:GetData("IsGarbage")
    end
}
ITEM.functions.OnDrinkx1 = {
    name = "Выпить глоток",
    OnRun = function(item)
     local player = item.player;
     player:EmitSound('npc/barnacle/barnacle_gulp1.wav')
     player:SetHunger(math.Clamp( player:GetLocalVar('hunger') + item:GetData('hunger')/item:GetData('useamount'), 0, 100 ))
     item:SetData('hunger', item:GetData('hunger')/item:GetData('useamount'))
     player:SetThirst(math.Clamp( player:GetLocalVar('thirst') + item:GetData('thirst')/item:GetData('useamount'), 0, 100 ))
     item:SetData('thirst', item:GetData('thirst')/item:GetData('useamount'))
     player:SetSleep(math.Clamp( player:GetLocalVar('sleep') + item:GetData('sleep')/item:GetData('useamount'), 0, 100 ))
     item:SetData('sleep', item:GetData('sleep')/item:GetData('useamount'))
     player:SetHealth(math.Clamp( player:Health() + item:GetData('health'), 0, 100 ))

     item:SetData('useamount', math.Clamp(item:GetData('useamount') - 1, 1, 100))
    
    return false;
    end,
    OnCanRun = function(item)
        return item.foodtype == 'drink' && item:GetData('useamount') > 1 && !item:GetData("IsGarbage")
    end
}

ITEM.functions.Refill = {
    name = "Наполнить",
    OnRun = function(item)
        local player = item.player;
        local plyArea = (ix.area.stored[player:GetArea()] or {});
        if player:WaterLevel() > 0 then
            item:SetData('thirst', item.thirst)
            item:SetData("IsGarbage", false)
            item:SetData('useamount', item.useamount)

            if plyArea.type == 'Радиация' then
                item:SetData('health', -(plyArea.properties.level * 2) )
            end;

            player:EmitSound("ambient/water/water_splash"..math.random(1, 3)..".wav")
        end;
        return false;
    end,
    OnCanRun = function(item)
        local player = item.player;
        print(item:GetData('useamount') < item.useamount)
        return item.refillable && item:GetData('useamount') < item.useamount && !IsValid(item.entity) && player:WaterLevel() > 0
    end
}
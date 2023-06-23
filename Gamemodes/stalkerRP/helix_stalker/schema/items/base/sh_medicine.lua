
ITEM.name = "Медикаменты"
ITEM.description = "Медикаменты"
ITEM.category = "Медикаменты"
ITEM.model = "models/Gibs/HGIBS.mdl"

ITEM.timeOfRegen = 0;
ITEM.healthPerSecond = 0;
ITEM.reduceRad = 0;

ITEM.functions.OnMedic = {
    name = "Использовать на себя",
    OnRun = function(item)
     local player = item.player;
     local uniqueNUMMBE = math.random(1, 10000) + item.id;
     player:EmitSound(item.sound or "stalker/interface/inv_medkit.mp3")
     player:SetLocalVar('ishealing', true)
     player:SetHunger(math.Clamp( player:GetLocalVar('hunger') - math.random(5, 10), 0, 100))
     player:SetThirst(math.Clamp( player:GetLocalVar('thirst') - math.random(5, 10), 0, 100))
     player:SetSleep(math.Clamp( player:GetLocalVar('sleep') - math.random(5, 10), 0, 100))
     
     if math.random(100) > 85 then
        player:GetCharacter():UpdateAttrib("medicine", 0.01)
     end;

     timer.Create("MedkitRegen"..uniqueNUMMBE, 1, item.timeOfRegen, function()
        player:SetHealth( math.Clamp(player:Health() + item.healthPerSecond, 0, player:GetMaxHealth()) )
        player:SetRadiation( math.Clamp( player:GetLocalVar('radiation') - item.reduceRad, 0, 1000) )
        if !player:Alive() then
            timer.Remove( "MedkitRegen"..uniqueNUMMBE )
            player:SetLocalVar('ishealing', false)
        end;
        if timer.RepsLeft( "MedkitRegen"..uniqueNUMMBE ) == 1 then
            player:SetLocalVar('ishealing', false)
        end;
     end);
     player:GetCharacter():RemoveCarry(item)
    end,
    OnCanRun = function(item)
       return true;
    end
}
local PLUGIN = PLUGIN;
local math = math;
local m = math.Clamp

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

    if (ec == "ross_repair_table") then
        if (arguments == "weapon_take_table") then
            if entity:InsideWeaponCheck() then
                player:GiveItem(Clockwork.item:CreateInstance(entity:GetweaponUID(), entity:GetweaponItemID(), {Quality = entity:GetQuality()}), true);
                entity:CleanWeaponTables();
            end;
        elseif arguments == "take_repair_item" then
            if entity:GetHasInstruments() then
                player:GiveItem(Clockwork.item:CreateInstance('repair_kit_table', nil, {RepQua = entity:GetRepairQuality()}), true);
                entity:CleanKitTables();
            end;
        elseif arguments == 'weapon_repair_table' then
            if entity:GetQuality() < 10 && entity:InsideWeaponCheck() && entity:GetHasInstruments() && entity:GetRepairQuality() > 0 then

                player:EmitSound('usesound/repair.mp3');
                Clockwork.player:SetAction(player, "WEAPONREPAIR", 5);
                Clockwork.player:ConditionTimer(player, 5, function()
                    if (!player:Alive() || player:GetVelocity():Length() > 0) then
                        return false;
                    end;
                    return true;
                end, function()
                    
                    entity:SetQuality( m(entity:GetQuality() + 2, 0, 10) );
                    entity:SetRepairQuality( m(entity:GetRepairQuality() - 10, 0, 100) );
                    Clockwork.player:SetAction(player, "WEAPONREPAIR", false);
                end);

            end;
        end;
    end;

end;

cable.receive('CleanWeaponUP', function(player, data)

    local wep = player:FindItemByID(data[6], data[7]);
    local repair = player:FindItemByID(data[1]);

    if (repair && repair:IsBasedFrom("repair_base")) && (wep && wep:IsBasedFrom("weapon_base")) then
        local tq = repair:GetData('RepQuality');
		local rp = repair:GetData('AmountOfRepair');
        local mw = repair:GetData('MinimumWeapon');
        local q = wep:GetData('Quality');

        if tq == data[4] && rp == data[2] && mw == data[5] && q == data[8] then
            if data[5] <= q then
                player:EmitSound('usesound/repair.mp3');
                Clockwork.player:SetAction(player, "WEAPONREPAIR", 4);
                Clockwork.player:ConditionTimer(player, 4, function()
                    if (!player:Alive() || player:GetVelocity():Length() > 0) then
                        return false;
                    end;
                    return true;
                end, function()
                    if math.random( math.Clamp(data[3] + 20, 0, 100) ) <= (30 + Clockwork.attributes:Get(player, 'collecting') * 10) then
                        wep:SetData("Quality", m(q + rp, 0, 10))
                        repair:SetData("RepQuality", m(tq - 5.5, 0, 100))
                    end;
                    Clockwork.attributes:Update(player, GetWeaponTFAtype(wep.uniqueID), ( rp/10 ));
                    Clockwork.attributes:Update(player, ATB_COLLECTING, ( rp/10 ));

                    if tq == 0 then
                        player:TakeItem(repair);
                    end;

                    Clockwork.player:SetAction(player, "WEAPONREPAIR", false);
                end);
            end;
        end;

    end;

end);

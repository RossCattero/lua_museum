invaddon.CashModule = invaddon.CashModule or {};

function invaddon.CashModule:CreateCashEntity(money, pos, ang)
    if !ang then ang = Angle(0,0,0) end;
    if !pos then pos = Vector(0,0,0) end;

    local cash = ents.Create("cash_entity")
    cash:SetPos(pos + Vector(0, 0, 25));
    cash:SetAngles(ang);
    cash.cashAmount = money;
    cash:Spawn();
end;

netstream.Hook("[R]_DropCash", function(player, amount)
    local cash = tonumber(player:GetCash());
    local position = player:GetEyeTrace().HitPos
    if cash >= amount && amount > 0 && (cash - amount) >= 0 then
        player:SetCash( math.max(cash - amount, 0) )
        invaddon.CashModule:CreateCashEntity(amount, position)
    end;
end)

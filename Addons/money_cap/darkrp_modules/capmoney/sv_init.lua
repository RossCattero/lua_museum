hook.Add("PlayerDeath", "R::PlayerKilled", function(vic)
		local money = vic:getDarkRPVar("money");
		local percent = math.min(money * ( 1 / 100 ), MOD.capAmount) // 1% of money, capped at 500k
		percent = math.Round(percent)
		
		vic:addMoney( -percent )
		vic:SpawnCashEntity( percent )
end)

local user = FindMetaTable("Player")

function user:SpawnCashEntity(money)
		local cash = ents.Create("prop_cash")
		cash:SetPos(self:GetPos());
		cash:SetAngles(self:GetAngles());
		cash:Spawn()

		cash.money = money;
end;
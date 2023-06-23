local PLUGIN = PLUGIN

function PLUGIN:EntityFireBullets(entity, bulletInfo)
	if not entity:IsPlayer() then return end
	--tables are for losers!
	if entity:GetAmmoCount("Pistol") > 60 then
		entity:SetAmmo(60, "Pistol")
	end
	if entity:GetAmmoCount("ar2") > 120 then
		entity:SetAmmo(120, "ar2")
	end
	if entity:GetAmmoCount("smg1") > 100 then
		entity:SetAmmo(100, "smg1")
	end
	if entity:GetAmmoCount("357") > 12 then
		entity:SetAmmo(12, "357")
	end
	if entity:GetAmmoCount("XBowBolt") > 1 then
		entity:SetAmmo(1, "XBowBolt")
	end
	if entity:GetAmmoCount("SniperPenetratedRound") > 20 then
		entity:SetAmmo(20, "SniperPenetratedRound")
	end	
	if entity:GetAmmoCount("AirboatGun") > 20 then
		entity:SetAmmo(20, "AirboatGun")
	end
	if entity:GetAmmoCount("Buckshot") > 30 then
		entity:SetAmmo(30, "Buckshot")
	end

end
local PLUGIN = PLUGIN

/*
	i = infect
	r = remove
	rot = Смерть от заражения
*/

netstream.Hook("WOUND_ACTION", function(client, id, action)
	local wound = INJURIES.Find(id);
	if !wound then return end;

	if action == "i" && wound:CanInfect() then
		wound:Infect()
	elseif action == "r" && wound:CanRemove() then
		wound:Remove()
	elseif action == "rot" && wound:GetInfected() then
		wound:Remove()
		client:Kill()
	elseif action == "heal" then
		local healed = wound:IsHealed();

		if healed != "" then
			local item = ix.item.list[healed]
			local efficiency = item && item:GetHealEfficiency();
			if !efficiency || !item:CanHeal( wound.index ) then return end;

			local time, amount = wound:GetData("healTime"), wound:GetData("healAmount")

			if time && time > 0 && time <= os.time() then
				wound:SetData("healAmount", (time - wound:GetData("occured")) * amount)
				wound:SetData("expire", wound:GetData("expire") + (time - wound:GetData("occured")) )
				wound:SetData("healTime", 0)
				wound:SetData("bleed", 0)

				local parm = item:GetParams();

				local shock, pain, min, blood = 
				parm.shock, parm.pain, parm.painMin, parm.blood

				client:Shock( (shock || 0) + (client:GetShock() * (1 + (LIMBS.ADD_SHOCK/100))) ) 
				client:SetHurt( pain || 0, min || 0 ) 
				client:Blood( blood || 0, item:CanStopBleeding() && -client:GetBleed() )
				
				if parm.inf && parm.inf > 0 then
					math.randomseed(os.time())

					if wound:GetInfected() && math.random(100) <= item:GetInfChance(100) then
						wound:SetData("Infected", false)
						wound:SetData("expire", os.time() + wound.woundTime )
					end
				end

			end;
		end

	end
end);
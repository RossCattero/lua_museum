local PLUGIN = PLUGIN;

local uniqueID = "Hurts"
timer.Create(uniqueID, 1, 0, function()
	if !timer.Exists(uniqueID) then timer.Remove(uniqueID) return; end;
	local players = player.GetAll()
	local bones = LIMBS_LIST;
	local injury_list = LIMB_INJURIES;

	local i = #players;
	while (i > 0) do
		local player = players[i];
		if IsValid(player) && player:Alive() then
			local character = player:GetCharacter();
			if character then
				local injs = character:GetData("Limbs")
				player:AddHurt(-1);
			end
		end
		i = i - 1;
	end;
end);

local uniqueID = 'Bleeding'
timer.Create(uniqueID, 1, 0, function()
	if !timer.Exists(uniqueID) then timer.Remove(uniqueID) return; end;
	
	for k, v in pairs( LIMBS_BLEED_LIST ) do
		local target = v.player
		if target && target:IsValid() 
		&& target:GetCharacter() && target:GetCharacter():GetID() == k 
		&& (!target.dblood || target.dblood <= CurTime())  then
			local bio = v:GetData("Biology");
			if !target:Alive() || bio.bleeding == 0 then
					target:BloodDrop( nil )
					continue;
			end

			target:SetBlood( bio.bleeding )
			target:ViewPunch( Angle( -0.5, 0, 0 ) )
			target.dblood = CurTime() + LIMB_TICK_BLOOD;
		end
	end
end);
local PLUGIN = PLUGIN

function PLUGIN:OnLimbDamaged( client, wound, dmg )
	local isLegs, isHead = wound:IsLegs(), wound:IsHead();

	if isLegs && dmg > LIMBS.DMG_LEG_FALL && !client:IsRagdolled() then
		client:SetRagdolled(true, math.random(2, 5))
	end

	if isHead then
		client:SetDSP( 35, false )
	end

end;

function PLUGIN:OnBloodDrop( client, blood, bleed )
	local charID = client:GetCharacter():GetID()

	if bleed <= 0 then
		LIMBS.BLEEDS[ charID ] = nil;
	elseif bleed > 0 && !LIMBS.BLEEDS[ charID ] then
		LIMBS.BLEEDS[ charID ] = client:GetCharacter();
	end

	if client:Alive() && blood <= 0 && bleed > 0 then
		client:Kill()
	end
end;

function PLUGIN:OnLimbHurt( client, hurt, minHurt )
	client.decrease_hurt = CurTime() + 5;

	if client:Alive() && hurt >= 95 then
		client:Kill()
	end
end;
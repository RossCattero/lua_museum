local PLUGIN = PLUGIN

function Bleeding()
	for id, char in pairs( LIMBS.BLEEDS ) do
		local target = char.player

		if IsValid(target) && char then
			local blood, bleed = target:GetBlood(), target:GetBleed()
			if bleed then
				if !target:Alive() || bleed <= 0 then
					target:Blood( 0, -bleed )
				else
					target:Blood( bleed )
					target:ViewPunch( Angle( -0.5, 0, 0 ) )
				end;			
			end;
		end
	end
end

timer.Create("Bleeding", LIMBS.TICK_BLOOD, 0, Bleeding)

function ResetBioData()
	for id, target in ipairs( player.GetAll() ) do
		if IsValid(target) && target.GetCharacter && target:GetCharacter() then
			local blood = target:GetBlood()
			
			if !target.decrease_hurt || target.decrease_hurt < CurTime() then
				target:SetHurt(-1);
			end;

			if target:IsFallen() && LIMBS.BLOOD_MIN >= blood then
				target:Fall(true, true)
			end

			if LIMBS.BLOOD_PERCENT >= blood && !target:IsFallen() then 
				target:Fall(true)
			elseif LIMBS.BLOOD_PERCENT < blood && target:IsFallen() then
				target:Fall(false, false)
			end
		end
	end
end

timer.Create("ResetBioData", 1, 0, ResetBioData)
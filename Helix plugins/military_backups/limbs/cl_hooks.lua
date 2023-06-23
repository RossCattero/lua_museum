local PLUGIN = PLUGIN;
BALPHA = 0;
ALPHA = 0;
DMG_COOLDOWN = 0;

netstream.Hook("Limbs::OpenPanel", function(data, isLocal)
	if (!LIMB.INT || !LIMB.INT:IsValid()) && !LIMB.INT_CD then
		local client = LocalPlayer()

		local bio = client:GetLocalVar("Biology")

		Limbs = data && data.Limbs || client:GetLocalVar("Limbs")
		Blood = data && data.blood || bio.blood
		Pain = data && data.pain || client:GetLocalVar("Hurt")
		Bleeding = data && data.bleeding || bio.bleeding || false
		IsLocalPlayerData = isLocal

		LIMB.INT = vgui.Create("Limbs")
		LIMB.INT:Populate()

		LIMB.INT_CD = CurTime() + 1;

		timer.Create("CheckInterface", 1, 0, function()
			local int = PLUGIN:GetLimbInterface();
			if int && !int:IsValid() then
				timer.Remove("CheckInterface")
				return;
			end
			if IsLocalPlayerData then return; end
			local trace = LocalPlayer():Tracer(128)
			local target = trace.Entity;

			if target && target:IsPlayer() && target:GetVelocity() != Vector(0, 0, 0) && int && int:IsValid() then
				int:Close()
			end
		end)
	end;
end)

function PLUGIN:GetLimbInterface()
	return LIMB.INT;
end;

netstream.Hook('limbs::GotDamage', function()
	DMG_COOLDOWN = CurTime() + LIMB.ADD_CD;
end);

netstream.Hook("Limbs::ClosePanel", function()
	if (LIMB.INT && LIMB.INT:IsValid()) then
		LIMB.INT:Close()
	end
end)

-- PrintTable(Entity(1):GetLimbs())
-- print(CurTime())
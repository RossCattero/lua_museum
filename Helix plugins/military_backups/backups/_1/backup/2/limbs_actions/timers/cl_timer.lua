local PLUGIN = PLUGIN

function Infection()
	local ply = LocalPlayer();

	if !(ply && ply.GetCharacter && ply:GetCharacter() && ply:Alive()) then
		return;
	end

	local limbs = ply:GetLimbs();

	for id, wound in pairs( INJURIES.INSTANCES ) do
		local expire, healed = wound:GetData("expire"), wound:IsHealed()

		if healed == "" && expire && expire < os.time() && wound:GetData("healAmount") < 100 then
			if !wound:GetInfected() then
				if wound:CanInfect() then
					netstream.Start("WOUND_ACTION", id, "i")
				elseif !wound:CanInfect() then
					netstream.Start("WOUND_ACTION", id, "r")
				end
			else
				netstream.Start("WOUND_ACTION", id, "rot")
			end;
		end

		if healed != "" then
			local time = wound:GetData("healTime");

			if time && time > 0 && time <= os.time() then
				netstream.Start("WOUND_ACTION", id, "heal")
			end
		end
	end
end

timer.Create("Wounds", 1, 0, Infection)
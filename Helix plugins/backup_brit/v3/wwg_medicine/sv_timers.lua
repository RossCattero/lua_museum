local PLUGIN = PLUGIN

timer.Create("Bleeding", 10, 0, function()
	local plys = player.GetAll();

	for _, user in ipairs(plys) do
		local char = user.GetCharacter && user:GetCharacter();

		if user:IsValid() && char then
			local id = char:GetID();
			local data = ix.wound.FindByID( id, "bleed" )
			
			if data && #data > 0 then
				for _, woundID in ipairs(data) do					
					local time = os.time()
					local wound = ix.wound.instances[woundID]

					if wound then
						if time < wound:GetData("time", time) then
							user:SetHealth( math.Clamp( user:Health() - wound:GetData("damage", 1), 0, user:GetMaxHealth() ) )
							user:ViewPunch( Angle( -5, 0, 0 ) )

							ix.wound.CreateInfection( user, bone, 5 )
						else
							local bone = wound:GetBone();
							ix.wound.CreateInfection( user, bone, 25 )

							user:Notify("Your " .. ix.body.Name( bone, true ) .. " has stopped bleeding.")
							wound:Remove();
						end;
					end;

				end
			end;
		end
	end

end)

timer.Create("Infection", 20, 0, function()
	local plys = player.GetAll();

	for _, user in ipairs(plys) do
		local char = user.GetCharacter && user:GetCharacter();

		if user:IsValid() && char then
			local id = char:GetID();
			local data = ix.wound.FindByID( id, "infection" )

			if data && #data > 0 then
				for _, woundID in ipairs(data) do					
					local time = os.time()
					local wound = ix.wound.instances[woundID]
					if wound then
						if time < wound:GetData("time", time) then
							user:SetHealth( math.Clamp( user:Health() - 1, 0, user:GetMaxHealth() ) )
							user:ViewPunch( Angle( -3, 0, 0 ) )
						else
							user:Notify("Your infection on " .. ix.body.Name( wound:GetBone(), true ) .. " has subsided.")
							wound:Remove()
						end
					end;
				end
			end;
		end
	end
end)

timer.Create("Fracture&Burn", 60, 0, function()
	local plys = player.GetAll();

	for _, user in ipairs(plys) do
		local char = user.GetCharacter && user:GetCharacter();

		if user:IsValid() && char then
			local id = char:GetID();
			local data = ix.wound.FindByID( id, "fracture" )
			
			if data && #data > 0 then
				for _, woundID in ipairs(data) do					
					local time = os.time()
					local wound = ix.wound.instances[woundID]
					if wound then
						if time > wound:GetData("time", time) then
							user:Notify("Your ".. ix.body.Name( wound:GetBone(), true ) .. " has healed from its fracture.")
							wound:Remove()
						end
					end;
				end
			end;

			data = ix.wound.FindByID( id, "burn" )
			if data && #data > 0 then
				for _, woundID in ipairs(data) do					
					local time = os.time()
					local wound = ix.wound.instances[woundID]
					if wound then
						if time > wound:GetData("time", time) then
							user:Notify("Your ".. ix.body.Name( wound:GetBone(), true ) .. " has healed from a burn.")
							wound:Remove()
						end
					end;
				end
			end;
			
		end
	end
end)
local PLUGIN = PLUGIN

timer.Create("WOUND_TIMER", 1, 0, function()
	for _, user in ipairs( player.GetAll() ) do
		local character = user:GetCharacter()

		if character then
			local id = character:GetID()
			local time = CurTime();

			for uniqueID, woundData in pairs( ix.wound.list ) do
				local woundList = ix.wound.FindByID( id, uniqueID )

				if woundList && #woundList > 0 then
					if !client.woundCheck then client.woundCheck = {};

					if !client.woundCheck[ uniqueID ] || ( client.woundCheck[ uniqueID ] <= time ) then

						
						
						client.woundCheck[ uniqueID ] = time + woundData.checkTime;
					end
				end;	

			end
		end
	end
end)

-- timer.Create("Bleeding", 10, 0, function()
-- 	for _, user in ipairs(player.GetAll()) do
-- 		local char = user.GetCharacter && user:GetCharacter();

-- 		if user:IsValid() && char then
-- 			local id = char:GetID();
-- 			local data = ix.wound.FindByID( id, "bleed" )
			
-- 			if data && #data > 0 then
-- 				for _, woundID in ipairs(data) do					
-- 					local time = os.time()
-- 					local wound = ix.wound.instances[woundID]
-- 					if wound then
-- 						local bone = wound:GetBone();
-- 						if time < wound:GetData("time", time) then
-- 							user:SetHealth( math.Clamp( user:Health() - wound:GetData("damage", 1), 0, user:GetMaxHealth() ) )
-- 							user:ViewPunch( Angle( -5, 0, 0 ) )
-- 							ix.wound.CreateInfection( user, bone, 5 )
-- 						else
-- 							ix.wound.CreateInfection( user, bone, 25 )
-- 							user:Notify("Your " .. ix.body.Name( bone, true ) .. " has stopped bleeding.")
-- 							wound:Remove();
-- 						end;
-- 					end;
-- 				end
-- 			end;

-- 			local body = ix.body.instances[ id ]

-- 			// If below 10 hp, speed will decrease by 25%
			-- if user:Health() < 10 && !user:GetLocalVar("speedDecreased", false) then
			-- 	body:SetStats( -25, -25, -25 ) 

			-- 	user:SetLocalVar("speedDecreased", true)
			-- elseif user:Health() >= 10 && user:GetLocalVar("speedDecreased") then
			-- 	body:SetStats( 25, 25, 25 ) 

			-- 	user:SetLocalVar("speedDecreased", false)
			-- end
-- 		end
-- 	end

-- end)

-- timer.Create("Infection", 20, 0, function()
-- 	for _, user in ipairs(player.GetAll()) do
-- 		local char = user:GetCharacter();
-- 		if char then
-- 			local id = char:GetID();
-- 			local data = ix.wound.FindByID( id, "infection" )

-- 			if data && #data > 0 then
-- 				for _, woundID in ipairs(data) do					
-- 					local time = os.time()
-- 					local wound = ix.wound.instances[woundID]
-- 					if wound then
						-- if time < wound:GetData("time", time) then
						-- 	user:SetHealth( math.Clamp( user:Health() - 1, 0, user:GetMaxHealth() ) )
						-- 	user:ViewPunch( Angle( -3, 0, 0 ) )
						-- else
						-- 	user:Notify("Your infection on " .. ix.body.Name( wound:GetBone(), true ) .. " has subsided.")
						-- 	wound:Remove()
						-- end
-- 					end;
-- 				end
-- 			end;
-- 		end
-- 	end
-- end)

-- timer.Create("Fracture&Burn", 60, 0, function()
-- 	for _, user in ipairs(player.GetAll()) do
-- 		local char = user:GetCharacter();
-- 		if char then
-- 			local id = char:GetID();
-- 			local data = ix.wound.FindByID( id, "fracture" )
			
-- 			if data && #data > 0 then
-- 				for _, woundID in ipairs(data) do					
-- 					local time = os.time()
-- 					local wound = ix.wound.instances[woundID]
-- 					if wound then
						-- if time > wound:GetData("time", time) then
						-- 	user:Notify("Your ".. ix.body.Name( wound:GetBone(), true ) .. " has healed from its fracture.")
						-- 	wound:Remove()
						-- end
-- 					end;
-- 				end
-- 			end;

-- 			data = ix.wound.FindByID( id, "burn" )
-- 			if data && #data > 0 then
-- 				for _, woundID in ipairs(data) do					
-- 					local time = os.time()
-- 					local wound = ix.wound.instances[woundID]
-- 					if wound then
						-- if time > wound:GetData("time", time) then
						-- 	user:Notify("Your ".. ix.body.Name( wound:GetBone(), true ) .. " has healed from a burn.")
						-- 	wound:Remove()
						-- end
-- 					end;
-- 				end
-- 			end;

-- 		end
-- 	end
-- end)

// The disease timer;
timer.Create("Diseases", 1, 0, function()
	for _, client in ipairs( player.GetAll() ) do
		local character = client:GetCharacter();
		
		if character then
			
			local characterID = character:GetID();
			local body = ix.body.instances[ characterID ]

			// Find the body for disease check;
			if body then
				// Find the last disease check;
				local diseaseTime = client:GetLocalVar("DiseaseCheck", 0);

				for uniqueID, chance in pairs( body.diseases ) do
					// If disease in body is number - then it's just a chance;
						// Increase the chance and go forward;
					if isnumber(chance) && ( !diseaseTime || ( diseaseTime < os.time() ) ) then
						local disease = ix.disease.list[ uniqueID ]
						// Increase the actual chance;
						if disease.chance && disease.chance > 0 then
							chance = chance + disease.chance;
							body.diseases[ uniqueID ] = chance;
						end
						// If chance > random % then add a disease;
						if chance > math.random(100) then
							ix.disease.Instance( uniqueID, nil, characterID )
						end
						// Add N seconds to next check time;
						client:SetLocalVar("DiseaseCheck", os.time() + 3600); // Each hour
					end;
					// If disease not chance number - then it's an actual disease
					if !isnumber(chance) && chance.id then
						local disease = ix.disease.instances[ chance.id ]
						
						if disease then
							// Check the stage with time of occured disease
							local stageNum = disease:GetStage();

							// Do the stage functionality
							if !disease.lastStage || disease.lastStage != stageNum then
								local stage = disease.stages[stageNum]

								if stage.text && stage.text != "" && !stage.emit then
									// Notify the player locally;
									client:Notify( stage.text );
								elseif stage.emit then
									// Or if stage.emit is set - emit with 'it' chatType;
									local emitStr = string.gsub( stage.text, "%[name%]", client:Name() )
									ix.chat.Send(client, "it", emitStr)
								end;

								// If this stage causes death - then kill;
								if stage.death then
									client:Kill()
								end

								// Buffer the last stage check to prevent re-checking the current stage;
								disease.lastStage = stageNum
							end

							// If sound is not null string;
							if disease.reactionSound != "" then
								// Create sound reaction buffer;
								if !client.reaction then client.reaction = {} end;

								// If delay is not instanced;
								if !client.reaction[uniqueID] || (client.reaction[uniqueID] < os.time()) then
									
									// if stage >= stage for reaction;
									if stageNum >= disease.reactionStage then
										// Emit sound for disease reaction;
										client:EmitSound( disease.reactionSound )
									end

									// Add delay;
									client.reaction[uniqueID] = os.time() + disease.reactionDelay
								end
							end

							// Check if disease can spread around;
							if disease.spreadChance > 0 then
								// Find all players in sphere;							
								for _, receiver in ipairs( ents.FindInSphere(client:GetPos(), 90) ) do
									// If player found and this player not the null patient itself;
									if receiver:IsPlayer() && receiver != client then										
										/*
											If receiver's disease sender is client and
											there's a cooldown for actual transmission
											and this cooldown is already passed 20 seconds
										*/ 
										if receiver.disSender == client && receiver.disTrans && receiver.disTrans <= os.time() then
											local recChar = receiver:GetCharacter();
											
											// If receiver don't have a disease and random < X%
											if !ix.disease.HasDisease( recChar:GetID(), uniqueID ) && math.random(100) < disease.spreadChance then
												ix.disease.Instance( uniqueID, nil, recChar:GetID() )
											end

											// For situation if the receiver don't have actual cooldown or null patient data don't match
										elseif !receiver.disTrans || (receiver.disSender && receiver.disSender != client) then
											receiver.disTrans = os.time() + 20;
											receiver.disSender = client;
										end

									end
								end
							end
							
							// Check the time of disease. If occured + expiration <= os.time() then remove;
							if (disease.occured + disease.time) <= os.time() then
								disease:Remove()
							end
						end
					end;
				end
			end
		end
	end
end)

// Нужно разработать:
/*
	1. Сделать реакции(коричневое)

	5. Документацию

	Потестить распространение!
*/

PrintTable(ix.body)
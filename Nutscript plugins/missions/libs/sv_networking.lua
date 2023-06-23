netstream.Hook("nut.mission.Instance", function(client, uniqueID)
	local char = client:getChar();
	local charID = char:getID();
	local trace = client:GetEyeTraceNoCursor();
	local startEntity = trace.Entity
	local canPick =  nut.mission.CanPickMission( client, uniqueID );

	if canPick then
		local mission = nut.mission.list[ uniqueID ]
		local findEnding = nut.mission.Ending( startEntity:EntIndex(), mission.maxDistance );
		
		if findEnding then
			local mission = nut.mission.Instance(nil, uniqueID, charID, {
				startEntity = startEntity,
				endPoint = findEnding,
				minDistance = mission.minDistance,
				maxDistance = mission.maxDistance
			})
			mission:Sync()

			if char then
				if char:getFaction() != FACTION_DELIVERY then
					client:setWhitelisted(FACTION_DELIVERY, true);
					char:setFaction(FACTION_DELIVERY)
					client:notify("You've been transfered to delivery faction.")
				end;
				char:getInv():add( mission.item )			
				client:notify(Format("You've taken the mission '%s'", mission.name))
			end;

		else
			client:notify("Can't find someone to deliver the goods to.")
		end;
	else
		client:notify("You can't pick this mission.")
	end;
end)

netstream.Hook("nut.mission.FinishByID", function(client, uniqueID)
	if nut.mission.CanFinishThere( client, uniqueID ) then
		local stack = nut.mission.stack.instances[ client:getChar():getID() ];
		if stack then
			local id = stack.list[uniqueID];
			if id then
				stack:RemoveByID( id );
				stack:Sync( client );

				local mission = nut.mission.instances[ id ]
				mission:OnFinish()
				mission:GiveReward()
			end;
		end;
	end;
end)
function PLUGIN:PlayerLoadedChar( client, character, prev )
	local charID = character:getID();

	if prev then
		local prevID = prev:getID();
		local stack = nut.mission.stack.instances[prevID];
		for k, v in pairs( stack.list ) do
			local mission = nut.mission.instances[ v ];
			if mission then
				mission:OnFinish()
				stack:RemoveByID( v )
				mission:Remove();
				mission:Sync();
				client:notify(Format("You failed the %s mission", nut.mission.list[k].name))
			end;
		end;
	end;

	local stack = nut.mission.stack.Instance(charID);
	stack:Sync( client );
end;

function PLUGIN:OnCharDisconnect(client, character)
	local charID = character:getID();
	local stack = nut.mission.stack.instances[charID];
	for k, v in pairs( stack.list ) do
		local mission = nut.mission.instances[ v ];
		if mission then
			mission:OnFinish()
			stack:RemoveByID( v )
			mission:Remove();
		end;
	end;

	nut.mission.stack.instances[charID] = nil;
end;

function PLUGIN:PlayerDeath(client, inflictor, attacker)
	local char = client:getChar();
	if !char then return end
	local charID = char:getID();
	
	local stack = nut.mission.stack.instances[charID];
	for k, v in pairs( stack.list ) do
		local mission = nut.mission.instances[ v ];
		if mission then
			mission:OnFinish()
			stack:RemoveByID( v )
			mission:Remove();
			mission:Sync();
			client:notify(Format("You failed the %s mission", nut.mission.list[k].name))
		end;
	end;
end

function PLUGIN:OnPlayerInteractItem( client, action, item, result, data )
	local taskID = item.missionUniqueID;
	if !result then
		local char = client:getChar();
		local charID = char:getID();
		local stack = nut.mission.stack.instances[ charID ];
		if stack then
			local missionID = stack.list[ taskID ];
			if missionID then
				local mission = nut.mission.instances[ missionID ];
				item:remove();
				stack:RemoveByID( id )
				mission:OnFinish();
				mission:Remove();
				client:notify(Format("You failed the %s mission", mission.name))
			end;
		end
	end
end;

timer.Create("nut.mission.checkMissions", 16, 0, function()
	for id, mission in pairs( nut.mission.instances ) do
		if mission.createTime + mission.finishTime < os.time() then
			local stack = nut.mission.stack.instances[mission.charID];
			if stack then stack:RemoveByID( id ) end;
			mission:OnFinish();
			mission:Remove();
			if mission:GetOwner() then
				mission:GetOwner():notify(Format("You failed the %s mission", mission.name))
			end;
		end;
	end;
end)
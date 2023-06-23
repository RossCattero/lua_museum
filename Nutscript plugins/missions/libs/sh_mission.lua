nut.mission = nut.mission or {};
nut.mission.list = nut.mission.list or {};
nut.mission.instances = nut.mission.instances or {};
nut.mission.entities = nut.mission.entities or {};

function nut.mission.Load(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		nut.mission.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function nut.mission.Register(uniqueID, path)
	if (uniqueID) then
		mission = nut.mission.list[uniqueID] or setmetatable({}, nut.meta.mission)
			mission.uniqueID = uniqueID
			mission.name = mission.name or "Default mission"
			mission.item = mission.item or ""
			mission.reward = mission.reward or 0;
			mission.cooldown = mission.cooldown or 60;
			mission.maximum = mission.maximum or 60;
			mission.minDistance = mission.minDistance or 0;
			mission.maxDistance = mission.maxDistance or 1024;
			mission.createTime = mission.createTime or 0;
			mission.finishTime = mission.finishTime or 300;
			
			if (path) then nut.util.include(path) end;

			nut.mission.list[uniqueID] = mission;
		mission = nil;
	end;
end

function nut.mission.New(uniqueID, id)
	local instance = nut.mission.instances[id]
	if (instance and instance.uniqueID == uniqueID) then
		return instance
	end

	local Mission = nut.mission.list[uniqueID]
	if (Mission) then
		local mission = setmetatable({uniqueID = uniqueID, id = id}, {
			__index = Mission,
			__eq = Mission.__eq,
			__tostring = Mission.__tostring
		})
		nut.mission.instances[id] = mission;

		return mission
	end
end

function nut.mission.RefreshUI()
	if nut.mission.derma && nut.mission.derma:IsValid() then
		nut.mission.derma:Refresh()
	end
end;

function nut.mission.Instance(id, uniqueID, charID, data)
	local mission = nut.mission.New(uniqueID, id or #nut.mission.instances + 1)
	mission.charID = charID;
	mission.startPoint = data.startPoint;
	mission.endPoint = data.endPoint
	mission.createTime = os.time();
	
	nut.mission.stack.instances[charID]:AddByID( uniqueID, mission:GetID() );

	if mission.OnInstance then
		mission:OnInstance()
	end;

	return mission;
end;

function nut.mission.Ending( start, max )
	local entList = {};

	start = Entity(start);
	if start != NULL then
		for entity in pairs( nut.mission.entities ) do
			if entity != start && entity != NULL && !entity:IsPlayer() then
				local distance = start:GetPos():DistToSqr( entity:GetPos() );
				if distance > 64 && distance <= math.pow( max, 2 ) then
					entList[#entList + 1] = entity:EntIndex();
				end;
			end;
		end;

		if #entList > 0 then
			for k, v in ipairs(entList) do
				if math.random(1, 3) == 2 then
					return v
				end
			end;
			return entList[1]
		end
	else
		error("Can't find any near entities to finish this task!")
	end;
end;

function nut.mission.CanPickMission( client, uniqueID )
	local char = client:getChar();
	local stack = nut.mission.stack.instances[char:getID()];
	local item = nut.item.list[ nut.mission.list[uniqueID].item ]

	return stack && !stack.list[uniqueID] && 
	(!stack.cooldowns[uniqueID] || stack.cooldowns[uniqueID] <= os.time())
	&& item && char:getInv():canItemFitInInventory(item, 1, 1)
end;

function nut.mission.CanFinishThere( client, uniqueID )
	local charID = client:getChar():getID();
	local trace = client:GetEyeTraceNoCursor();
	local entityID = trace.Entity && trace.Entity:EntIndex();
	if !charID || !entityID || entityID == 0 then return false end;
	
	local stack = nut.mission.stack.instances[charID]
	local mNumber = stack.list[uniqueID]
	if mNumber then
		local mission = nut.mission.instances[ mNumber ];
		return mission && mission.endPoint == entityID;
	end;
	return false;
end;

function nut.mission.FindEntities( client )
	local char = client:getChar();
	local charID = char && char:getID();
	if !charID then return end;
	
	local stack = nut.mission.stack.instances[charID];
	local entityList = {};

	for k, v in pairs( stack.list ) do
		local mission = nut.mission.instances[ v ]
		if mission then
			table.insert(entityList, Entity(tonumber(mission.endPoint)))
		end
	end

	return entityList;
end;
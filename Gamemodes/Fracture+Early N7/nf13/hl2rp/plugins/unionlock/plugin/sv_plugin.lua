local PLUGIN = PLUGIN;

-- A function to load the Union locks.
function PLUGIN:LoadUnionLocks()
	local unionLocks = Clockwork.kernel:RestoreSchemaData( "plugins/unionlocks/"..game.GetMap() );
	
	for k, v in pairs(unionLocks) do
		local entity = ents.FindInSphere(v.doorPosition, 16)[1];
		
		if (IsValid(entity)) then
			local unionLock = self:ApplyUnionLock(entity);
			
			if (unionLock) then
				Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
				
				unionLock:SetLocalAngles(v.angles);
				unionLock:SetLocalPos(v.position);
				
				if (!v.locked) then
					unionLock:Unlock();
				else
					unionLock:Lock();
				end;
			end;
		end;
	end;
end;

-- A function to save the Union locks.
function PLUGIN:SaveUnionLocks()
	local unionLocks = {};
	
	for k, v in pairs( ents.FindByClass("cw_unionlock") ) do
		if (IsValid(v.entity)) then
			unionLocks[#unionLocks + 1] = {
				key = Clockwork.entity:QueryProperty(v, "key"),
				locked = v:IsLocked(),
				angles = v:GetLocalAngles(),
				position = v:GetLocalPos(),
				uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
				doorPosition = v.entity:GetPos()
			};
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/unionlocks/"..game.GetMap(), unionLocks);
end;

-- A function to apply a Union lock.
function PLUGIN:ApplyUnionLock(entity, position, angles)
	local unionLock = ents.Create("cw_unionlock");
	
	unionLock:SetParent(entity);
	unionLock:SetDoor(entity);
	
	if (position) then
		if (type(position) == "table") then
			unionLock:SetLocalPos( Vector(-1.0313, 43.7188, -1.2258) );
			unionLock:SetPos( unionLock:GetPos() + (position.HitNormal * 4) );
		else
			unionLock:SetPos(position);
		end;
	end;
	
	if (angles) then
		unionLock:SetAngles(angles);
	end;
	
	unionLock:Spawn();
	
	if (IsValid(unionLock)) then
		return unionLock;
	end;
end;
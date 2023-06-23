local missionStack = nut.meta.stack or {}

missionStack.__index = missionStack

missionStack.charID = 0;
missionStack.list = {};
missionStack.cooldowns = {}

function missionStack:__tostring()
	return Format("Mission list[%s]", self:GetID())
end

function missionStack:GetID() 
	return self.charID
end;

function missionStack:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

function missionStack:AddByID( uniqueID, id )
	self.list[ uniqueID ] = id;
end;

function missionStack:RemoveByID( id )
	local mission = nut.mission.instances[ id ];
	if mission then
		self.cooldowns[ mission.uniqueID ] = os.time() + (mission.cooldown or 0)
		self.list[ mission:UniqueID() ] = nil;
	end;
end;

if SERVER then
	function missionStack:Sync( client )
		if client && client != NULL then
			netstream.Start(client, "nut.mission.stack.sync", self)
		end;
	end;
end;

nut.meta.stack = missionStack
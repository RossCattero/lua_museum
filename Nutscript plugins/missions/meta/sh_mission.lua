local mission = nut.meta.mission or {}

mission.__index = mission

mission.id = 0;
mission.charID = 0;
mission.uniqueID = "";
mission.startPoint = 0;
mission.endPoint = 0;

mission.name = "Default mission"
mission.item = "" // item to deliver
mission.reward = 0; // reward for deliver
mission.cooldown = 0 // cooldown in seconds
mission.maxDistance = 1024; // maximum distance between start npc and end npc;
mission.createTime = 0; // Time when mission was instanced;
mission.finishTime = 300; // Time to finish the mission;

function mission:__tostring()
	return Format("Mission[%s][%s]", self:GetID(), self:UniqueID())
end

function mission:GetID() 
	return self.id
end;

function mission:UniqueID()
	return self.uniqueID
end;

function mission:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

function mission:Remove()
	local owner = self:GetOwner()

	nut.mission.instances[ self.id ] = nil;
	if owner && owner != NULL then
		netstream.Start(owner, "nut.mission.remove", self.id)
	end
end;

function mission:CanFinish()
	local owner = self:GetOwner()
	local char = owner && owner:getChar();
	local hasItem = function(itemType)
		for _, item in pairs(char:getInv():getItems()) do
			if (item.uniqueID == itemType) then
				return item
			end
		end
		return false
	end;

	return char && char:getFaction() == FACTION_DELIVERY
	&& char:getInv() && hasItem( self.item );
end;

function mission:OnFinish()
	local owner = self:GetOwner()
	local char = owner && owner:getChar()
	local item = self:CanFinish();
	
	if owner && item then
		char:getInv():removeItem( item:getID(), true );
	end;
end;

function mission:GiveReward()
	local owner = self:GetOwner()
	local char = owner && owner:getChar()
	
	if owner then
		owner:getChar():giveMoney( self.reward )
		self:Remove()

		owner:notify("You finished the deliver mission.")
		owner:notify(Format("You received %s%s for finishing this task.", self.reward, nut.currency.symbol))
	end;
end;

function mission:GetOwner()
	return nut.char.loaded[ tonumber(self.charID) ].player
end;

if SERVER then
	function mission:Sync()
		local owner = self:GetOwner()
		if owner && owner != NULL then
			netstream.Start(owner, "nut.mission.sync", self.id, self)
		end;
	end;
else
	function mission:GetTooltip()
		return Format("Title: %s;\nDeliver: %s;\nReward: %s;", 
		self.name, nut.item.get(self.item).name, self.reward)
	end;
end;

nut.meta.mission = mission
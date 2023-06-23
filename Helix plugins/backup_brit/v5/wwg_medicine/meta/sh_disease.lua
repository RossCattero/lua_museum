--- Disease;
-- @medical Disease

local DISEASE = ix.meta.disease or {}

DISEASE.__index = DISEASE

DISEASE.name = ""

// If chance = 0 then this disease can be only accessed from the code
DISEASE.chance = 0
DISEASE.time = 0
// Chance of this disease to send to anyone near;
DISEASE.outbreakChance = 0
DISEASE.stages = {
	{
		chance = 0, // Chance for this stage to set
		min = 0, // Minimal time for stage
		max = 0, // Maximal time for stage or 0
		emit = false, // Should this be emited in /me
		text = "", // The text to notify the player or emit outside
		death = false, // Kill the character on this choose;
	}
}
DISEASE.reactionSound = ""
DISEASE.reactionDelay = 60
DISEASE.reactionStage = 1
DISEASE.checkedStage = 0;

// The spread chance;
DISEASE.spreadChance = 0;

DISEASE.charID = 0
DISEASE.id = 0

function DISEASE:__tostring()
	return "DISEASE["..self:UniqueID().."]["..self:GetID().."]"
end

function DISEASE:__eq(other)
	return self:GetIndex() == other:GetIndex()
end

function DISEASE:UniqueID()
	return self.uniqueID
end;

function DISEASE:GetID()
	return self.id or 0;
end;

function DISEASE:GetTimeLeft()
	return (self.occured + self.time) - os.time()
end;

function DISEASE:GetTime()
	return os.time() - self.occured
end;

function DISEASE:GetStage()
	local time = self:GetTime()
	local rand = math.random(100)
	
	for i = 1, #self.stages do
		local stage = self.stages[i];

		if stage && (stage.min <= time) && (!stage.max || (stage.max > time)) then
			if (!stage.chance || ( rand <= stage.chance )) then
				return i;
			else
				rand = 100 - stage.chance
			end
		end
	end

	return 0;
end;

function DISEASE:GetOwner()
	return ix.char.loaded[ self.charID ] && ix.char.loaded[ self.charID ].player;
end;

if SERVER then
	function DISEASE:Remove()
		ix.disease.instances[ self:GetID() ] = nil;

		local body = ix.body.instances[self.charID]
		if body then body.diseases[self:UniqueID()] = 0; end;

		local owner = self:GetOwner();

		if owner then
			net.Start("NETWORK_DISEASE_REMOVE")
				net.WriteUInt(self:GetID(), 16)
			net.Send( owner )
		end
	end;

	function DISEASE:Network()
		local owner = self:GetOwner();

		if owner then
			net.Start("NETWORK_DISEASE")
				net.WriteUInt(self:GetID(), 16)
				net.WriteString(self:UniqueID())
			net.Send( owner )
		end
	end;
end

ix.meta.disease = DISEASE
local PLUGIN = PLUGIN;

local ent = FindMetaTable("Entity")
local painSounds = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

function ent:Tracer(amount)
	if !self:IsValid() || !self.GetShootPos then return end;
	if !amount then amount = 2058*2058 end;

	local pos, angle = self:GetShootPos(), self:GetAimVector();
	if !pos then return end;

	return util.TraceLine({start = pos, endpos = pos + (angle * amount),  filter = self});
end;

function ent:EmitPainSound()
		local health = self:Health()
		if ((self.ixNextPain or 0) < CurTime() and health > 0) then
			local painSound = hook.Run("GetPlayerPainSound", self) or painSounds[math.random(1, #painSounds)]

			if (self:IsFemale() and !painSound:find("female")) then
				painSound = painSound:gsub("male", "female")
			end

			self:EmitSound(painSound)
			self.ixNextPain = CurTime() + 0.33
		end
end;
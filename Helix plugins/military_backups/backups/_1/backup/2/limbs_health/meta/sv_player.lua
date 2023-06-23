local PLAYER = FindMetaTable("Player")

function PLAYER:WhoLookMed()
	return self:GetCharacter():GetData("rgn_med", "")
end;

function PLAYER:AddLookMed( id )
	local data = self:WhoLookMed()

	data = data .. ("," .. id .. ",")

	self:SetLocalVar("rgn_med", data )
	self:SetNetVar("rgn_med", data )

	return id;
end;

function PLAYER:SetHurt( hurt, minHurt )
	local bio = self:GetBIO();
	if !bio then return end;

	if minHurt then
		bio.painMin = math.Clamp(bio.painMin + minHurt, 0, 100)
	end
	if hurt then
		bio.pain = math.Clamp(bio.pain + hurt, bio.painMin, 100)
	end;

	self:SetLocalVar("Bio", bio)

	hook.Run( "OnLimbHurt", self, bio.pain, bio.painMin )
end;

function PLAYER:Blood( blood, bleed )
	local bio = self:GetBIO();
	if !bio then return end;

	if blood then
		bio.blood = math.Clamp(bio.blood - blood, 0, LIMBS.MIN_BLOOD);
	end;
	if bleed then
		bio.bleed = math.Clamp(bio.bleed + bleed, 0, 255);
	end

	self:SetLocalVar("Bio", bio)

	hook.Run( "OnBloodDrop", self, bio.blood, bio.bleed )

	self:LimbDamagedCallback()
end;

function PLAYER:Shock( shock )
	local bio = self:GetBIO();
	if !bio then return end;

	if shock then
		bio.shock = math.Clamp(bio.shock + shock, 0, LIMBS.MAX_SHOCK_AMOUNT);
	end

	self:SetLocalVar("Bio", bio)
	
	hook.Run( "OnShockUpdate", self, bio.shock )
end;
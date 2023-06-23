local PLAYER = FindMetaTable("Player")

function PLAYER:GetBIO()
	return self:GetLocalVar( "Bio" )
end;

function PLAYER:GetLimbs()
	return self:GetLocalVar( "Limbs" )
end;

function PLAYER:GetBlood()
	return self:GetBIO() && self:GetBIO().blood or 0;
end;

function PLAYER:GetBleed()
	return self:GetBIO() && self:GetBIO().bleed or 0;
end;

function PLAYER:GetShock()
	return self:GetBIO() && self:GetBIO().shock or 0;
end;

function PLAYER:GetHurt()
	return self:GetBIO() && self:GetBIO().pain or 0;
end;

function PLAYER:IsFallen()
	return self:GetLocalVar("Wounded", false)
end;

function PLAYER:IsRagdolled()
	return self:GetLocalVar("ragdoll");
end;

function PLAYER:IsInspectingCharacter()
	local data = self:GetLocalVar("inspChar")

	return IsValid(data) && data
end;

function PLAYER:Fall(fall, hard)
	self:GetCharacter():SetData("Wounded", fall)
	self:SetLocalVar("Wounded", fall)
	self:SetNetVar("Wounded", fall)
	self:SetNetVar("actEnterAngle", fall && self:GetAngles() || nil)
	if fall then
		self:ForceSequence( LIMBS:GetRandomSequence() || 0, nil, 0 )
		net.Start("ixActEnter")
			net.WriteBool(false)
		net.Send(self)
	else
		self:LeaveSequence()
		net.Start("ixActLeave")
		net.Send(self)
	end;

	self:SetLocalVar("Wounded__hard", hard)
end;
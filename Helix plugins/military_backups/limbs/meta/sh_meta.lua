local PLUGIN = PLUGIN
local user = FindMetaTable("Player")

function user:Confuse(boolean, cons)
	if !boolean then
		self:LeaveSequence();
		self:SetNetVar("actEnterAngle")		
		self:SetNetVar("Wounded")
		self:UpInfo("Wounded")
		self:UpInfo("UnCons")
		
		net.Start("ixActLeave")
		net.Send(self)
		return;
	end

	local sequence = LIMB.WOUNDED_SEQ[math.random(1, #LIMB.WOUNDED_SEQ)]
	self:ForceSequence(sequence || 0, nil, 0)
	self:SetNetVar("actEnterAngle", self:GetAngles())
	self:UpInfo("Wounded", true)
	self:SetNetVar("Wounded", true)

	self:UpInfo("UnCons", cons)

	net.Start("ixActEnter")
		net.WriteBool(false)
	net.Send(self)
end;

function user:UnActive()
	return self:GetLocalVar("restricted") || self:GetLocalVar("UnCons")
end;

function user:GetLimbs()
	return self:GetCharacter():GetData("Limbs")
end;

function user:GetHealed(bone, index)
	local limbs = self:GetLimbs();
	return limbs[bone][index] && limbs[bone][index].heal
end;

/*

*/
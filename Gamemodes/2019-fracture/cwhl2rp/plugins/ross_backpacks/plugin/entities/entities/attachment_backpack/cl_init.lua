include("shared.lua");

function ENT:Think()
	
	local playerEyePos = Clockwork.Client:EyePos();
	local eyePos = EyePos();
	
	if (IsValid(Clockwork.Client)) then
		
		if ((eyePos:Distance(playerEyePos) > 32 or GetViewEntity() != Clockwork.Client or Clockwork.Client != Clockwork.Client)) then
			self:SetNoDraw(false);
		else
			self:SetNoDraw(true);
		end;
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;
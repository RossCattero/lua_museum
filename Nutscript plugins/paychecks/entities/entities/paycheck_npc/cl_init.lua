include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.optionsList = {
		["Take paycheck"] = function()
			netstream.Start("nut.banking.paycheck.take", self:EntIndex())
		end;
	}
end;
include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.optionsList = {
		["Talk to bankeer"] = function()
			netstream.Start("nut.banking.useBankeer")
		end;
	}
end;
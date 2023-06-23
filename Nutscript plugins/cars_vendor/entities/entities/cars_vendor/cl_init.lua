include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.optionsList = {
		["Show cars"] = function()
			if !nut.car_vendor.instances[ LocalPlayer():getChar():getID() ] then
				if nut.car_vendor.derma && nut.car_vendor.derma:IsValid() then
					nut.car_vendor.derma:Close()
				end

				nut.car_vendor.derma = vgui.Create("CarVendor")
			else
				nut.util.notify("You already have a temporary car.")
			end;
		end;
	}
end;
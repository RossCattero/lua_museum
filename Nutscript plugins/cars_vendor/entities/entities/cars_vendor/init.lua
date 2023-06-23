include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:OnSetData()
	self.data.position = self.data.position or Vector(0, 0, 0)
end;

function ENT:Use( activator )
	if !activator:IsAdmin() then
		netstream.Start("nut.car_vendor.openUI")
	end;
end;
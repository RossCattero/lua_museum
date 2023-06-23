include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:OnSetData()
	nut.mission.entities[self] = true;
end;

function ENT:Use( activator )
	if !activator:IsAdmin() then
		netstream.Start("nut.mission.openUI")
	end;
end;

function ENT:OnRemove()
	nut.mission.entities[self] = nil;
end;
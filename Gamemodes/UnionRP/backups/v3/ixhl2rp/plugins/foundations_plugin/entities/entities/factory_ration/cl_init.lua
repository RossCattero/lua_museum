include("shared.lua");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;

function ENT:GetEntityMenu(client)
	local options = {};
	local char = client:GetCharacter();
	local inv = char:GetInventory()

	if !self:GetPacketUp() && inv:HasItem('work_tape') then
		options["Запаковать"] = "ration_packup";
	end;
	return options
end;
include("shared.lua");

function ENT:Draw()
	self:DrawModel();
end;

function ENT:GetEntityMenu(client)
	local options = {};

	if self:GetTurned() then return end;

	if self:GetBodygroup(1) == 0 then
		options["Открыть"] = "";
		options["Включить процесс переработки"] = "";
	elseif self:GetBodygroup(1) == 1 then
		options["Закрыть"] = "";
		options["Посмотреть"] = "";
	end;
	return options
end;
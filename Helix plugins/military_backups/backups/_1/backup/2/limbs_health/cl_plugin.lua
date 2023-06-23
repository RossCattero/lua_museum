local PLUGIN = PLUGIN

function PLUGIN:GetPlayerEntityMenu(client, options)
	local char = LocalPlayer():GetCharacter()

	if client:CanBeMedicalObserved( char:GetID() ) then
		options["Осмотреть"] = true;
	end;
end;
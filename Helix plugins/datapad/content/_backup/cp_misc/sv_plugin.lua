local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
	timer.Simple(.25, function()
        if ix.ranks.Allowed(character:GetFaction()) then
			character:SetCCARank( character:GetCCARank() )
        end;
	end);
end;

local PLUGIN = PLUGIN;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["BackPackTable"] ) then
		data["BackPackTable"] = {
            OccNum = 0,
            NonOccNum = 10
        };
    end;
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["BackPackTable"]) then
		data["BackPackTable"] = data["BackPackTable"];
	else
	    data["BackPackTable"] = {
            OccNum = 0,
            NonOccNum = 10
        };
    end;
end;
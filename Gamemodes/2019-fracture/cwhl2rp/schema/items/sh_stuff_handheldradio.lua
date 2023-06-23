--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "ItemHandheldRadio";
ITEM.uniqueID = "handheld_radio";
ITEM.model = "models/props_generic/walkietalkie.mdl";
ITEM.weight = 1;
ITEM.category = "Средства связи";
ITEM.description = "ItemHandheldRadioDesc";
ITEM.customFunctions = {"Frequency"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Frequency") then
			Clockwork.datastream:Start(player, "Frequency", player:GetCharacterData("Frequency", ""));
		end;
	end;
end;

ITEM:Register();
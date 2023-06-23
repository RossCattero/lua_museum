--[[
	© 2012 Iron-Wall.org do not share, re-distribute or modify
	without permission of its author (ext@iam1337.ru).
--]]

local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharUndeath");
COMMAND.tip = "Undeath a character from being used.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

function COMMAND:OnRun(player, arguments)
	for k, v in pairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:Name() == arguments[1]) then
				Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
				PLUGIN:SetUndeath(player, false);
				
				return;
			else
				for k2, v2 in pairs(v:GetCharacters()) do
					if (v2.name == arguments[1]) then
						Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
						
						v2.data["permakilled"] = false;
						
						return;
					end;
				end;
			end;
		end;
	end;
	
	local charactersTable = Clockwork.config:Get("mysql_characters_table"):Get();
	local charName = arguments[1];
	
	local queryObj = Clockwork.database:Select(charactersTable);
		queryObj:SetCallback(function(result)
			if (Clockwork.database:IsResult(result)) then
				local queryObj = Clockwork.database:Update(charactersTable);
					queryObj:Replace("_Data", "\"permakilled\":true", "\"permakilled\":false");
					queryObj:AddWhere("_Name = ?", charName);
				queryObj:Push();
				
				Clockwork.player:NotifyAll(player:Name().." unbanned the character '"..arguments[1].."'.");
			else
				Clockwork.player:Notify(player, "This is not a valid character!");
			end;
		end);
		queryObj:AddWhere("_Name = ?", charName);
	queryObj:Pull();
end;

COMMAND:Register();
local COMMAND = Clockwork.command:New("ChangeMPFInfo");
COMMAND.tip = "2: Rank, Squad";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] );
	local info = tostring(arguments[2]);
	local info2 = tostring(arguments[3]);
	local CP = player:GetCharacterData("CombinedInfo");
	
		if (target) then
			if info == "Rank" then
				if !Schema:IsCombineRank(info2) then
					return;
				end;
				local nameStart, nameEnd = string.find( target:Name(), Schema:GetCombineRank(target:Name()) )
                if nameStart then
                    local nameReplacedText = string.sub( target:Name(), 1, nameStart - 1 ) .. info2 .. string.sub( target:Name(), nameEnd + 1 )
                    Clockwork.player:SetName(target, nameReplacedText);
                    CP["CombineRank"] = info2;
                end;
			elseif info == "Squad" then
				if Schema:IsCombineRank(info2) then
					return;
				end;
				CP["Squad"] = str;
			else
				return;
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." не игрок!");
		end;
end;

COMMAND:Register();
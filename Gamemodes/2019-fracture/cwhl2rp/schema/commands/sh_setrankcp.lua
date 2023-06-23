
local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharSetRankCP");
COMMAND.tip = "";
COMMAND.text = "<Name> [Rank]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;
-- COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local rank = arguments[2]
	
-- if Schema:PlayerIsCombine(target) then

	if (target) then

	target:SetCharacterData("CombineRank", rank);
	target:SetSharedVar("RankMPF", rank);

	if (player != target) then
		Clockwork.player:Notify(target, player:Name().." изменил ваш ранг на "..rank..".");
		Clockwork.player:Notify(player, "Вы изменили ранг "..target:Name().." на "..rank..".");
	else
		Clockwork.player:Notify(player, "Вы изменили свой ранг на "..rank..".");
	end;

	end;

-- end;

end;

COMMAND:Register();
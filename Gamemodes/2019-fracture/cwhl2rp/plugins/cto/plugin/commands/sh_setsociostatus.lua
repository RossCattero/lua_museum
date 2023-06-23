local Clockwork = Clockwork;
local cwCTO = cwCTO;

local COMMAND = Clockwork.command:New("SetSocioStatus");
COMMAND.tip = "Update the sociostability status of the city.";
COMMAND.text = "<string green|blue|yellow|red|black>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"VisorStatus"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		if (Schema:IsPlayerCombineRank( player, {"SCN", "DvL", "SeC", "CmD", "EpU", "CmR"} ) or player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN or player:IsAdmin()) then
			local tryingFor = string.upper(arguments[1]);

			if (not cwCTO.sociostatusColors[tryingFor]) then
				Clockwork.player:Notify(player, "Это не валидный социостатус!");
			else
				local players = {};

				local pitches = {
					СИНИЙ = 95,
					ЖЕЛТЫЙ = 90,
					КРАСНЫЙ = 85,
					ЧЕРНЫЙ = 80
				};

				local pitch = pitches[tryingFor] or 100;
			
				for k, v in ipairs( _player.GetAll() ) do
					if (Schema:PlayerIsCombine(v) and not v:GetCharacterData("IsBiosignalGone")) then
						players[#players + 1] = v;

						timer.Simple(k / 4, function()
							if (IsValid(v)) then
								v:EmitSound("npc/roller/code2.wav", 75, pitch);
							end;
						end);
					end;
				end;

				cwCTO.socioStatus = tryingFor;

				Schema:AddCombineDisplayLine("ВНИМАНИЕ! Социостатус " .. tryingFor .. "!", cwCTO.sociostatusColors[tryingFor]);
				
				Clockwork.datastream:Start(players, "RecalculateHUDObjectives", {cwCTO.socioStatus, Schema.combineObjectives});
			end;
		else
			Clockwork.player:Notify(player, "Вам нельзя использовать это!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;

COMMAND:Register();
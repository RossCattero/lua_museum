local Clockwork = Clockwork;
local cwCTO = cwCTO;

local COMMAND = Clockwork.command:New("CameraEnable");
COMMAND.tip = "Remotely enable a Combine camera - IDs are shown on the HUD.";
COMMAND.text = "<number CameraID>";
COMMAND.alias = {"CamE"};
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		if (Schema:IsPlayerCombineRank( player, {"SCN", "OfC", "EpU", "DvL", "SeC", "CmD"}, true ) or player:GetFaction() == FACTION_OTA) then
			local camera = Entity(arguments[1]);

			if (not IsEntity(camera) or camera:GetClass() ~= "npc_combine_camera") then
				Clockwork.player:Notify(player, "Нету камеры с этим ID!");

				return;
			end;

			if (camera:GetSequenceName(camera:GetSequence()) ~= "idle") then
				Clockwork.player:Notify(player, "Эта камера сейчас не отключена.");

				return;
			end;

			Clockwork.player:Notify(player, "Включение C-i" .. camera:EntIndex() .. ".");

			camera:Fire("Enable");
		else
			Clockwork.player:Notify(player, "Вам запрещено делать это!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!");
	end;
end;

COMMAND:Register();

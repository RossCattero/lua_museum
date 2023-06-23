/*----------------------\
| Created by Viomi      |
| viomi@openmailbox.org | 
\----------------------*/

local COMMAND = Clockwork.command:New("VisorDiv")
COMMAND.tip = "Send a notification to other units in your division via the visor."
COMMAND.text = "<string Division> <string Text>"
COMMAND.alias = {"Vdiv"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER)
COMMAND.arguments = 2

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Schema:PlayerIsCombine(player)) then
		if (player:GetFaction() == FACTION_OTA or player:GetFaction() == FACTION_ADMIN or player:GetFaction() == FACTION_MPF) then
			if (Schema:IsPlayerCombineRank(player, arguments[1]) or Schema:IsPlayerCombineRank(player, "SeC") or Schema:IsPlayerCombineRank(player, "CmR")) then
				local text = table.concat(arguments, " ", 2)
				
				if (text == "") then
					Clockwork.player:Notify(player, "Вы ввели недостаточное количество!")
					
					return
				end

				if (arguments[1] == "C17" or arguments[1] == "MPF") then
					Clockwork.player:Notify(player, "Вам нужно писать это в /VisorComms")

					return
				end
				
				for k, v in ipairs( _player.GetAll() ) do
					if ((Schema:PlayerIsCombine(v) and Schema:IsPlayerCombineRank(v, arguments[1])) or Schema:IsPlayerCombineRank(v, "SeC") or Schema:IsPlayerCombineRank(v, "CmR")) then
						Schema:AddCombineDisplayLine( "!"..arguments[1]..": "..player:Name()..": "..text, Color(255, 255, 0, 255), v)
					end
				end


				BroadcastLua("LocalPlayer():ConCommand('virgil1')")
			else
				Clockwork.player:Notify(player, "Вы не в этом подразделении.")
			end
		else
			Clockwork.player:Notify(player, "Вы не можете этого сделать!")
		end
	else
		Clockwork.player:Notify(player, "Вы не юнит ГО или ОТА!")
	end
end



COMMAND:Register()
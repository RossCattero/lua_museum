--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.
]]

local COMMAND = Clockwork.command:FindByID("request")

COMMAND.alias = {"Req"};

-- Called when the command is run by the player.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:GetFaction() == FACTION_ADMIN);
	local text = table.concat(arguments, " ");
	local ciD

	if player:GetSharedVar("CitizenID") == "" then 
	ciD = " N/A" 
	else 
	ciD = player:GetSharedVar("CitizenID") 
	end
	
	if (text == "") then
		Clockwork.player:Notify(player, "Вы ввели недостаточное количество текста!");
		
		return;
	end;
	
	if (player:HasItemByID("request_device") or isCityAdmin) then
		local curTime = CurTime();
		
		if (!player.nextRequestTime or isCityAdmin or curTime >= player.nextRequestTime) then
			Schema:AddCombineDisplayLine( "!ЗАП: Гражданин "..player:Name()..", #"..ciD..": "..text, Color(218, 165, 32, 255) );
			player:EmitSound("evo/virgil_2.wav")
			Clockwork.chatBox:SendColored(player, Color(184, 134, 11, 255), "Ваш запрос доставлен...")
			
			if (!isCityAdmin) then
				player.nextRequestTime = curTime + 30;
			end;
		else
			Clockwork.player:Notify(player, "Вы не можете отправить запрос еще "..math.ceil(player.nextRequestTime - curTime).." секунд(ы)!");
		end;
	else
		Clockwork.player:Notify(player, "У вас нету устройства запроса!");
	end;
end;

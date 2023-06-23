local COMMAND = Clockwork.command:New("visorhelp");
COMMAND.tip = "Запросить помощь и указать местоположение всем юнитам.";
COMMAND.text = "";
COMMAND.alias = {"vhelp"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isCombine = Schema:PlayerIsCombine(player)
	local gi = player:GasmaskInfo();
	local pos = player:GetPos(); local name = player:Name()

	if isCombine && gi > 0 then
		if !player.nextRequestTime || CurTime() >= player.nextRequestTime then
		
			Schema:AddCombineDisplayLine('!ВНМ: Юнит '..player:GetName()..' запрашивает помощь на свой 10-20!', Color(255, 100, 100) )
			for k, v in ipairs(cwPlayer.GetAll()) do
                if (Schema:PlayerIsCombine(v)) then
                    cable.send(player, 'CreateWaypoint', pos, name, 120, 'backup');
                end;
            end;
			
		
			player.nextRequestTime = CurTime() + 60;
		else 
			Clockwork.player:Notify(player, 'Вы не можете этого сделать сейчас!')
		end;
	else
		if isCombine then
            if player:GetClothesSlot()['gasmask'] != '' then
                Clockwork.chatBox:SendColored(player, Color(100, 100, 255), 'УВЕД: Ваша маска не поддерживает это действие.');
                Clockwork.player:PlaySound(player, 'buttons/combine_button_locked.wav')
            else
                Clockwork.player:Notify(player, 'На вас не надета маска.')
            end;
        else
            Clockwork.player:Notify(player, 'Вы не юнит ГО или ОТА!')
        end;
	end;

end;

COMMAND:Register();
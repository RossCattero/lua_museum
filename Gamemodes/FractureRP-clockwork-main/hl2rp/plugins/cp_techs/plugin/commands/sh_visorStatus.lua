local COMMAND = Clockwork.command:New("vstatus");
COMMAND.tip = "Изменить свой статус.";
COMMAND.text = "<10-7/10-8>";
COMMAND.alias = {"vs"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local status = table.concat(arguments, " ");
    local tenseven = status == '10-7'; local teneight = status == '10-8';
    local gi = player:GasmaskInfo();
    local iscombine = Schema:PlayerIsCombine(player)
    
    if iscombine && gi > 0 then
        local combineInfo = player:GetCharacterData("CombinedInfo")
        if tenseven then
            combineInfo["Status"] = '10-7';
            Schema:AddCombineDisplayLine(player:Name()..' теперь 10-7.', Color(200, 255, 200) )
        elseif teneight then
            combineInfo["Status"] = '10-8';
            Schema:AddCombineDisplayLine(player:Name()..' теперь 10-8.', Color(100, 255, 100) )
        elseif tenseven && teneight then
            Clockwork.player:Notify(player, 'Вы не можете вводить оба статуса!')
        else
            Clockwork.player:Notify(player, 'Вы не ввели статус!')
        end;
    else
        if iscombine then
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
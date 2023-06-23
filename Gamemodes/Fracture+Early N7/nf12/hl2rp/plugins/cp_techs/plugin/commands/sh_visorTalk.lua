local COMMAND = Clockwork.command:New("vtalk");
COMMAND.tip = "Написать в визор сообщение.";
COMMAND.text = "<текст>";
COMMAND.alias = {"vt"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local iscombine = Schema:PlayerIsCombine(player)
    local gi = player:GasmaskInfo();

    local text = tostring(arguments[1]);
    if iscombine then

        if gi > 0 then
            if utf8.len(text) < 85 then
                Schema:AddCombineDisplayLine(text, Color(100, 100, 255) )
            elseif utf8.len(text) > 85 then
                Schema:AddCombineDisplayLine(utf8.sub(text, 1, 85).."...", Color(100, 100, 255) )
                Schema:AddCombineDisplayLine("..." .. utf8.sub(text, 85, 210) .. "...", Color(100, 100, 255) )
            end;
        else
            if player:GetClothesSlot()['gasmask'] != '' then
                Clockwork.chatBox:SendColored(player, Color(100, 100, 255), 'УВЕД: Ваша маска не поддерживает это действие.');
                Clockwork.player:PlaySound(player, 'buttons/combine_button_locked.wav')
            else
                Clockwork.player:Notify(player, 'На вас не надета маска.')
            end;
        end;

    else
        Clockwork.player:Notify(player, 'Вы не юнит ГО или ОТА!')
    end;

end;

COMMAND:Register();
local COMMAND = Clockwork.command:New("vSetSocialStatus");
COMMAND.tip = "Установить городской статус";
COMMAND.text = "<ЗЕЛЕНЫЙ/ЖЕЛТЫЙ/КРАСНЫЙ/ЧЕРНЫЙ>";
COMMAND.alias = {"vsoc"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local allowedStatus = {
        'ЗЕЛЕНЫЙ',
        'ЖЕЛТЫЙ',
        'КРАСНЫЙ',
        'ЧЕРНЫЙ'
    }
    local iscombine = Schema:PlayerIsCombine(player);
    local fac = player:GetFaction();
    local gi = player:GasmaskInfo();
    local txt = table.concat(arguments, " ");
    txt = string.upper(txt)

    if iscombine && gi > 0 then
        local rank = Schema:GetCombineRank(player:Name());
        local allowed = rank == 'DvL' || rank == "SeC" || fac == FACTION_SCANNER
        local stat = table.HasValue(allowedStatus, txt);

        if allowed && stat then
            local function statusToColor(status)
                if status == 'ЗЕЛЕНЫЙ' then
                    return Color(100, 255, 100);
                elseif status == 'ЖЕЛТЫЙ' then
                    return Color(248, 242, 33);
                elseif status == 'КРАСНЫЙ' then
                    return Color(255, 100, 100);
                elseif status == 'ЧЕРНЫЙ' then
                    return Color(30, 30, 30);
                end;
                return Color(100, 255, 100);
            end;
            Schema:AddCombineDisplayLine('ВНИМАНИЕ: Обновлен статус города. Статус: '..txt..' !', statusToColor(txt) )
            Clockwork.kernel:SetSharedVar("CityStatus", txt);
        else
            Clockwork.player:Notify(player, 'Вам не разрешено использовать эту команду или вы ввели не валидный статус!')
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
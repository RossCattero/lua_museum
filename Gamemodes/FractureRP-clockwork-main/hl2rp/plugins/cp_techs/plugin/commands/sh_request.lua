local COMMAND = Clockwork.command:New("request");
COMMAND.tip = "Запросить поддержку у юнитов ГО. Требуется УЗ в инвентаре.";
COMMAND.text = "<текст>";
COMMAND.alias = {"req"};
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local text = tostring(arguments[1]);
    local hasitem = player:HasItemByID('request_device');
    local pos = player:GetPos(); local name = player:Name();
    local talkradius = Clockwork.config:Get("talk_radius"):Get();

    if hasitem then
        if !text || utf8.len(text) == 0 then
            Clockwork.player:Notify(player, 'Вы не ввели текст!')
            return;
        end;
        if !player.nextRequestTime || CurTime() >= player.nextRequestTime then

            player:EmitSound('buttons/button19.wav')
            Clockwork.player:Notify(player, 'Ваш запрос доставлен юнитам ГО!')

            Clockwork.chatBox:AddInRadius(player, "request_eavesdrop", text, pos, talkradius);
            Schema:AddCombineDisplayLine( name..' запрашивает: '..utf8.sub(text, 1, 77 + utf8.len(name)).."...", Color(255, 180, 80) )
            for k, v in ipairs(cwPlayer.GetAll()) do
                if (Schema:PlayerIsCombine(v)) then
                    cable.send(v, 'CreateWaypoint', pos, name, 120, 'request', text);
                end;
            end;
            
			player.nextRequestTime = CurTime() + 60;
		else 
			Clockwork.player:Notify(player, 'Вы не можете этого сделать сейчас!')
		end;
    else
        Clockwork.player:Notify(player, 'У вас нету устройства запроса!')
    end;
end;

COMMAND:Register();
local COMMAND = Clockwork.command:New("RationPhaseStart");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local time = tonumber(arguments[1])

    if time > 900 then
        time = 900;
    elseif time < 100 then
        time = 100;
    end;

    Clockwork.chatBox:SendColored(player, "Рационная фаза запущена на: "..time.." секунд.")
    for k, v in pairs(cwPlayer.GetAll()) do
        if v:IsAdmin() then
            Clockwork.chatBox:SendColored(v, player:GetName().." начал рационную фазу на "..time.." секунд.")
        end;
    end;
    Clockwork.kernel:SetSharedVar("RationPhase", time)

	sound.Play("ambient/alarms/train_horn_distant1.wav", Vector(4520.531250, 1035.557007, 64.036995), 100, 120);
end;

COMMAND:Register();
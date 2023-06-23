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

    Clockwork.kernel:SetSharedVar("RationPhase", time)
end;

COMMAND:Register();
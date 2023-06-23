local COMMAND = Clockwork.command:New("RationPhaseStop");
COMMAND.tip = "";
COMMAND.flags = CMD_DEFAULT;
-- COMMAND.text = "<имя>";
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)

    if Clockwork.kernel:GetSharedVar("RationPhase") ~= 0 then
        Clockwork.kernel:SetSharedVar("RationPhase", 0)
        for k, v in pairs(cwPlayer.GetAll()) do
            if v:IsAdmin() then
                Clockwork.chatBox:SendColored(v, player:GetName().." отключил рационную фазу!")
            end;
        end;
    else
        Clockwork.chatBox:SendColored(player, "Фаза не запущена!")
    end;

end;

COMMAND:Register();
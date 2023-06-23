
local PLUGIN = PLUGIN;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);
	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "looting") then
			return {text = "", percentage = percentage, flash = percentage < 10};
		end;
	end;
end;

cable.receive("OpenSettingsRandomizer", function( ent, entinfo, items )
	if (PLUGIN.lootpanel and PLUGIN.lootpanel:IsValid()) then
		PLUGIN.lootpanel:Close();
	end;
	if !Clockwork.player:IsAdmin(Clockwork.Client) then 
        return;
    end;
	PLUGIN.lootpanel = vgui.Create("OpenSettingsRandomizer");
	PLUGIN.lootpanel:Populate(ent, entinfo, items)
end);
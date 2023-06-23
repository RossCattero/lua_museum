local PLUGIN = PLUGIN;

netstream.Hook("OpenTerminalInterface", function(data)
	if (PLUGIN.terminal and PLUGIN.terminal:IsValid()) then
		PLUGIN.terminal:Close();
	end;

	PLUGIN.terminal = vgui.Create("TerminalFrame");
	PLUGIN.terminal:Populate(data)
end);
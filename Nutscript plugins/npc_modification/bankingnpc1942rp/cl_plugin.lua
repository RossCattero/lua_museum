local PLUGIN = PLUGIN;

netstream.Hook('Banking::StartTalk', function()
		if INT_TALKING && INT_TALKING:IsValid() then INT_TALKING:Close() end;

		INT_TALKING = vgui.Create('Talking')
		INT_TALKING:Populate()
end);

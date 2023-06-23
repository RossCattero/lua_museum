local PLUGIN = PLUGIN;

netstream.Hook("OpenTalkerTalking", function(tbl, id, tbl2)
	if (PLUGIN.talkerPanel and PLUGIN.talkerPanel:IsValid()) then
		PLUGIN.talkerPanel:Close();
	end;

	PLUGIN.talkerPanel = vgui.Create("OpenTalkingPanel");
	PLUGIN.talkerPanel:Populate(tbl, id, tbl2)
end);

netstream.Hook("OpenTalkerSettings", function(tbl, id, tbl2, ent)
	if (PLUGIN.talkerSettings and PLUGIN.talkerSettings:IsValid()) then
		PLUGIN.talkerSettings:Close();
	end;
	
	PLUGIN.talkerSettings = vgui.Create("RossSalesmanEdit");
	PLUGIN.talkerSettings:Populate(tbl, id, tbl2, ent)
end);
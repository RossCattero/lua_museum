local PLUGIN = PLUGIN;


-- function PLUGIN:GetEntityMenuOptions(entity, options)
-- 	if (entity:GetClass() == "talker_npc") then
-- 		options["Поговорить"] = "talker_npc_talk";
-- 		if entity:GetAllowSell() then
-- 			options["Торговать"] = "talker_npc_vendor";
-- 		end;
-- 		if Clockwork.player:IsAdmin(Clockwork.Client) then
-- 			options["Настроить"] = "talker_npc_settings";
-- 		end;
-- 	end;
-- end;

cable.receive("OpenTalkerTalking", function(tbl, id, tbl2, quests, npc)
	if (PLUGIN.talkerPanel and PLUGIN.talkerPanel:IsValid()) then
		PLUGIN.talkerPanel:Close();
	end;

	PLUGIN.talkerPanel = vgui.Create("RossSalesmanOpen");
	PLUGIN.talkerPanel:Populate(tbl[id], id, tbl2, quests, npc)
end);

cable.receive("OpenTalkerVendor", function(tbl, tbl1, ent, tbl2)
	if (PLUGIN.vendorpanel and PLUGIN.vendorpanel:IsValid()) then
		PLUGIN.vendorpanel:Close();
	end;

	PLUGIN.vendorpanel = vgui.Create("RossSalesmanFleeMarket");
	PLUGIN.vendorpanel:Populate(tbl, tbl1, ent, tbl2)
end);

cable.receive("OpenTalkerSettings", function(tbl, id, tbl2, ent)
	if (PLUGIN.talkerSettings and PLUGIN.talkerSettings:IsValid()) then
		PLUGIN.talkerSettings:Close();
	end;
	
	PLUGIN.talkerSettings = vgui.Create("RossSalesmanEdit");
	PLUGIN.talkerSettings:Populate(tbl[id], id, tbl2, ent)
end);

local PLUGIN = PLUGIN;

netstream.Hook("OpenSettingsRandomizer", function( ent, entinfo, items )
	if (PLUGIN.lootpanel and PLUGIN.lootpanel:IsValid()) then
		PLUGIN.lootpanel:Close();
	end;
	
	PLUGIN.lootpanel = vgui.Create("OpenSettingsRandomizer");
	PLUGIN.lootpanel:Populate(ent, entinfo, items)
end);
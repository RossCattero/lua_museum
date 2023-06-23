
local PLUGIN = PLUGIN;

netstream.Hook("LookNotepad", function(p)
	if (PLUGIN.notepadPnl && PLUGIN.notepadPnl:IsValid()) then
		PLUGIN.notepadPnl:Close();
	end;

	PLUGIN.notepadPnl = vgui.Create("OpenNotepad");
	PLUGIN.notepadPnl:Populate(p);
end);

netstream.Hook("EditNotepad", function(entity, pages, inform)
	if (PLUGIN.notepadEdit && PLUGIN.notepadEdit:IsValid()) then
		PLUGIN.notepadEdit:Close();
	end;

	for k, v in pairs(pages) do
		pages[k]['info'] = pages[k]['info']:gsub("&lt;", '<' ):gsub('&gt;', '>')
		pages[k]['info'] = pages[k]['info']:gsub("%<(/?)([bius])%>", "[%1%2]"):gsub("%<(/?)(h[r1-3])%>", "[%1%2]")
		pages[k]['info'] = pages[k]['info']:gsub('<br />', "\n")
		pages[k]['info'] = pages[k]['info']:gsub('%<font color=\\\"(#?[0-9a-zA-Z]+)\\\"%>', '[color="%1"]' ):gsub("%</font%>", "[/color]")
	end;

	PLUGIN.notepadEdit = vgui.Create("OpenNotepadEdit");
	PLUGIN.notepadEdit:Populate(pages, inform, entity)
end);
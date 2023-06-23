
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "cw_notepad_holder") then
		options["Открыть"] = "cw_notepad_holder_open";
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (entity:GetClass() == "cw_notepad_holder") then
		info.y = Clockwork.kernel:DrawInfo("Шкафчик для блокнотов", info.x, info.y, colorTargetID, info.alpha)
		info.y = Clockwork.kernel:DrawInfo("Вы можете положить в него блокнот.", info.x, info.y, colorWhite, info.alpha)
	end
end;

cable.receive("LookNotepad", function(p)
	if (PLUGIN.notepadPnl && PLUGIN.notepadPnl:IsValid()) then
		PLUGIN.notepadPnl:Close();
	end;

	PLUGIN.notepadPnl = vgui.Create("OpenNotepad");
	PLUGIN.notepadPnl:Populate(p);
end);

cable.receive("EditNotepad", function(entity, pages, inform)
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
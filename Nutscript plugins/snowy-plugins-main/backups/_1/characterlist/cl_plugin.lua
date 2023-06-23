local PLUGIN = PLUGIN;

netstream.Hook('charList::show', function(data)
		if PLUGIN.interface && PLUGIN.interface:IsValid() then PLUGIN.interface:Close() end

		CHARDATA = data;

		PLUGIN.interface = vgui.Create("CharacterList")
		PLUGIN.interface:Populate()
end);

netstream.Hook('charList::updateListData', function(data)
		if PLUGIN.interface && PLUGIN.interface:IsValid() then
				PLUGIN.interface:ReloadData(data)
		end;
end);

function PLUGIN:LoadNutFonts(font, genericFont)	
	font = genericFont
	surface.CreateFont( "SearchFont", {
		font = "Arial",
		size = ScreenScale( 5 ),
		outline = false,
	})
	surface.CreateFont( "InfoFont", {
		font = "Arial",
		size = ScreenScale( 6 ),
		outline = false,
	})
end;
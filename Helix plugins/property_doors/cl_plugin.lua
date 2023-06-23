function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("PropertySolas", {
		font = "Consolas",
		size = ScreenScale(7),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
end;

language.Add( "tool.doors.name", "Door property tool" )
language.Add( "tool.doors.desc", "Left click: Assign door settings to this door; Right click: check door info;" )
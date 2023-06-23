local PLUGIN = PLUGIN;

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont( "Datapad_filter_text", {
		font = "IBM Plex Mono",
		size = ScreenScale(6),
        extended = true,
	})

	surface.CreateFont( "Datapad_names_text", {
		font = "IBM Plex Mono",
		size = ScreenScale(7),
		weight = 600,
        extended = true,
	})

	surface.CreateFont( "Datapad_data_text", {
		font = "IBM Plex Mono",
		size = ScreenScale(5),
        extended = true,
	})

end;
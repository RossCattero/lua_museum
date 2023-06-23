function PLUGIN:LoadNutFonts(font, genericFont)
	
	font = genericFont

	surface.CreateFont( "comfie", {
		font = "Comfortaa",
		extended = false,
		size = 30,
		weight = 1500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

end;
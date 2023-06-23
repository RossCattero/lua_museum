local PLUGIN = PLUGIN;

function PLUGIN:LoadNutFonts(font, genericFont)	
	font = genericFont
	surface.CreateFont( "Gbanking", {
		font = "Indie Flower",
		size = ScreenScale(10),
		scanlines = 1,
		antialias = true,
		extended = true,
		weight = 700,
	})
	surface.CreateFont( "Gbanking-handy", {
		font = "Indie Flower",
		size = ScreenScale(10),
		scanlines = 1,
		antialias = true,
		extended = false,
	})
	surface.CreateFont( "Typewriter", {
		font = "ELEGANT TYPEWRITER",
		weight = 700,
		size = ScreenScale(10),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont( "Typewriter-small", {
		font = "ELEGANT TYPEWRITER",
		weight = 700,
		size = ScreenScale(8),
		antialias = true,
		extended = true,
	})
	surface.CreateFont( "Typewriter-check", {
		font = "ELEGANT TYPEWRITER",
		weight = 700,
		size = ScreenScale(6),
		antialias = true,
		extended = true,
	})
end;
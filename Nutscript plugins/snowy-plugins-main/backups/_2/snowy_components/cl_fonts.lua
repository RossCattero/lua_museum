local PLUGIN = PLUGIN;

function PLUGIN:LoadNutFonts(font, genericFont)	
	font = genericFont
	surface.CreateFont( "Generic Banking", {
		font = "Quicksand Light",
		size = ScreenScale( 9 ),
		outline = true,
	})
  surface.CreateFont( "Banking handly", {
		font = "Indie Flower",
		extended = false,
		size = ScreenScale( 8 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking handly big", {
		font = "Indie Flower",
		extended = false,
		size = ScreenScale( 11 ),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo little", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 6 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 6 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo big", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 12 ),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking info", {
		font = "Courier New",
		extended = false,
		size = ScreenScale( 7 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking info smaller", {
		font = "Consolas",
		extended = false,
		size = ScreenScale( 6 ),
		antialias = true,
	})
	surface.CreateFont( "Banking id", {
		font = "Consolas",
		extended = false,
		size = ScreenScale( 7 ),
		weight = 200,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	
	surface.CreateFont( "ButtonStyle", {
		font = "Comfortaa",
		size = ScreenScale(7),
	})

	surface.CreateFont( "LimbsData", {
		font = "Arial",
		size = ScreenScale( 5 ),
		outline = true,
	})
	surface.CreateFont( "Unconsious", {
		font = "Times New Roman",
		size = ScreenScale( 12 ),
		weight = 700,
		outline = false,
	})
end;
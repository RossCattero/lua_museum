local PLUGIN = PLUGIN;

function PLUGIN:LoadNutFonts(font, genericFont)
	font = genericFont
	surface.CreateFont("JobEditorTitle", {
		font = "Dosis",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("JobHighlight", {
		font = "Dosis",
		size = ScreenScale(8),
		weight = 1000,
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("JobDescription", {
		font = "Dosis",
		size = ScreenScale(7),
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("JobBtns", {
		font = "Dosis",
		size = ScreenScale(6),
		scanlines = 1,
		antialias = true,
	})
	// Taxi
	surface.CreateFont("TaxiFontHuge", {
		font = "Dosis",
		size = ScreenScale(11),
		weight = 500,
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("TaxiFontBigger", {
		font = "Dosis",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("FontSmall", {
		font = "Dosis",
		size = ScreenScale(7),
		scanlines = 1,
		antialias = true,
	})
	surface.CreateFont("TaxiFontSmaller", {
		font = "Dosis",
		size = ScreenScale(6),
		scanlines = 1,
		antialias = true,
	})
end;
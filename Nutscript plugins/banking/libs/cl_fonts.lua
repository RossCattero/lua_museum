local PLUGIN = PLUGIN;

function PLUGIN:LoadNutFonts(font, genericFont)	
	font = genericFont
	surface.CreateFont( "BankingTitle", {
		font = "Century Gothic",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
		extended = true,
		weight = 600,
	})
	surface.CreateFont( "BankingTitleSmaller", {
		font = "Century Gothic",
		size = ScreenScale(7),
		scanlines = 1,
		antialias = true,
		extended = true,
		weight = 500,
	})
	surface.CreateFont( "BankingDataLabel", {
		font = "Consolas",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont( "BankingDataLabelSmaller", {
		font = "Consolas",
		size = ScreenScale(6),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont( "BankingButtons", {
		font = "Consolas",
		size = ScreenScale(7),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont( "BankingDataMoney", {
		font = "Century Gothic",
		size = ScreenScale(12),
		scanlines = 1,
		antialias = true,
		extended = true,
		weight = 600,
	})
end;
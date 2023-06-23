local PLUGIN = PLUGIN

function PLUGIN:LoadFonts(font, genericFont)
	surface.CreateFont("LIMB_TEXT", {
		font = "Consolas",
		size = ScreenScale(5.5),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont("LIMB_SUBTEXT", {
		font = "Candara",
		size = ScreenScale(8),
		scanlines = 1,
		antialias = true,
		extended = true,
	})
	surface.CreateFont("LIMB_EMPTY", {
		font = "Consolas",
		size = ScreenScale(5),
		scanlines = 1,
		antialias = true,
		extended = true,
		italic = true,
	})
end;
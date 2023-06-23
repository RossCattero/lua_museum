
-- I ususally use a ScreenScale for smaller monitors, but in case you have more res your scale idea is better;
local font_scale = (ScrH() / 1080);

surface.CreateFont( "Gambling_title", {
	font = "Arial",
	extended = false,
	size = 40 * font_scale,
	weight = 700,
} )

surface.CreateFont( "Gambling_cross", {
	font = "Arial",
	extended = false,
	size = 70 * font_scale,
} )

surface.CreateFont( "Gambling_cross_small", {
	font = "Arial",
	extended = false,
	size = 50 * font_scale,
} )

surface.CreateFont( "Gambling_4", {
	font = "Segoe UI",
	extended = false,
	size = 15 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_4_5", {
	font = "Segoe UI",
	extended = false,
	size = 15 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_5", {
	font = "Segoe UI",
	extended = false,
	size = 17 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_6", {
	font = "Segoe UI",
	extended = false,
	size = 25 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_6_5", {
	font = "Segoe UI",
	extended = false,
	size = 40 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_7", {
	font = "Segoe UI",
	extended = false,
	size = 27 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_8", {
	font = "Segoe UI",
	extended = false,
	size = 23 * font_scale,
	weight = 800,
} )

surface.CreateFont( "Gambling_12", {
	font = "Segoe UI",
	extended = false,
	size = 50 * font_scale,
	weight = 800,
} )
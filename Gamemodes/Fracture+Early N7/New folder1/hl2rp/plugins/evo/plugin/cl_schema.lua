--[[ 
		Created by Polis, July 2014.
		Do not re-distribute as your own.


	 	Sort of messy, but /much/ better than it was before.  Believe me, god damn.
]]

/*----------------------\
| Edited by Viomi       | // Added " ::>" to the end of all visor messages
| viomi@openmailbox.org | // Removed all the god damn semi-colons
\----------------------*/

CreateClientConVar( "evo_names", 1, true, false )
CreateClientConVar( "evo_hud", 1, true, false )
CreateClientConVar( "evo_outlines", 1, true, false )
CreateClientConVar( "evo_crosshair", 1, true, false )
CreateClientConVar( "evo_outline_distance", 295, true, false )
CreateClientConVar( "evo_hud_distance", 300, true, false )

-- Get rid of them nasty display lines.
Schema.randomDisplayLines = {}

-- White Outlines Fixed
--[[hook.Add("PreDrawHalos", "Outlines", function()
	if (Schema:PlayerIsCombine(LocalPlayer())) then
			halo.Add( player.GetAll(), Color(248,248,255,255), 0, 0, 1, true, false )
	end
end)]]

-- Colours
colormal = Color(255, 10, 0, 255)
coloryel = Color(255, 215, 0, 255)
colorgre = Color(50, 205, 50, 255)
color = Color(0, 128, 255, 255)
colorcitizen = Color(255, 250, 250, 255)

-- Fonts
surface.CreateFont( "HUDFont", {
	font = "BudgetLabel",
	size = 16,
	weight = 500,
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
} )

surface.CreateFont( "NameFont", {
	font = "BudgetLabel",
	size = 18,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = true,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

-- General Interface
hook.Add("HUDPaint", "General Interface", function()
	if (Schema:PlayerIsCombine(LocalPlayer())) then
	for k,e in pairs ( player.GetAll() ) do
		if ( e:IsPlayer() and e != LocalPlayer() and !e:IsNoClipping() and e:GetPos():Distance(LocalPlayer():GetPos()) <= 64) then
		local Position = ( e:GetPos() + Vector( 0,0,80 ) ):ToScreen()
		local font = "HUDFont"

			if (GetConVar("evo_names"):GetInt() == 1 and Schema:PlayerIsCombine(e)) then
					draw.DrawText( e:Name(), "NameFont", Position.x, Position.y + 15, color, 1 )
			end

		if (ConVarExists( "evo_hud" ) and GetConVar("evo_hud"):GetInt() == 1) then	
			local model = e:GetModel()
			if (e:Health() <= 0) then
				draw.DrawText( "<:: !ВНМ: НЕТУ ПРИЗНАКОВ ЖИЗНИ ::>", font, Position.x, Position.y + 81, colormal, 1 )
			elseif (e:Health() <= 10) then
				draw.DrawText( "<:: !ВНМ: ПРИСМЕРТИ ::>", font, Position.x, Position.y + 31, colormal, 1 )
			elseif (e:Health() <= 96) then
				draw.DrawText( "<:: !УВЕД: ОБНАРУЖЕН УРОН ::>", font, Position.x, Position.y + 31, coloryel, 1 )
			end

			if (e:IsRagdolled() and e:Alive()) then
				draw.DrawText( "<:: !УВЕД: БЕЗ СОЗНАНИЯ ::>", font, Position.x, Position.y + 81, coloryel, 1 )
			elseif (e:GetSharedVar("IsTied") != 0 and !Schema:PlayerIsCombine(e)) then
				draw.DrawText( "<:: !УВЕД: СВЯЗАН ::>", font, Position.x, Position.y + 44, colorgre, 1 )
			elseif (e:GetSharedVar("IsTied") != 0 and Schema:PlayerIsCombine(e)) then
				draw.DrawText( "<:: !УВЕД: СВЯЗАННЫЙ ЮНИТ ::>", font, Position.x, Position.y + 44, coloryel, 1 )
			end

			if (e:FlashlightIsOn()) then
					draw.DrawText( "<:: !УВЕД: ИСПОЛЬЗУЕТ ФОНАРИК ::>", font, Position.x, Position.y + 57, colorgre, 1 )
			end

				if (e:IsOnFire()) then
					draw.DrawText( "<:: !ВНМ: ГОРИТ ::>", font, Position.x, Position.y + 57, colormal, 1 )
				elseif (e:InVehicle() and !Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: !ВНМ: ИСПОЛЬЗОВАНИЕ ТРАНСПОРТНОГО СРЕДСТВА ::>", font, Position.x, Position.y + 57, colormal, 1 )
				elseif (e:IsRunning() or e:IsJogging()) then
					if (!Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: !ВНМ: НАРУШЕНИЕ ДВИЖЕНИЯ ::>", font, Position.x, Position.y + 57, coloryel, 1 )
					end
				elseif (e:Crouching() and !Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: !ВНМ: ПЫТАЕТСЯ КРАСТЬСЯ ::>", font, Position.x, Position.y + 57, coloryel, 1 )
				elseif (e:Crouching() and Schema:PlayerIsCombine(e)) then
					draw.DrawText( "<:: !УВЕД: КРАДЕТСЯ ::>", font, Position.x, Position.y + 57, colorgre, 1 )
					end
			
			
				end
			end
		end	
	end
end)



hook.Add("HUDPaint", "Flying Words", function()
if (ConVarExists( "evo_outlines" ) and GetConVar( "evo_outlines" ):GetInt() == 1 and Schema:PlayerIsCombine(LocalPlayer())) then
	for k,ent in pairs (ents.FindByClass("cw_item")) do
		if LocalPlayer():Alive() and (Clockwork.entity:HasFetchedItemData(ent)) then
		local Table = ent:GetItemTable()
		local ita =  Table("category")	
		local Position = ( ent:GetPos() + Vector( 0,0,0 ) ):ToScreen()
		local distance = ent:GetPos():Distance(LocalPlayer():GetPos()) 
	if (ita == "Weapons") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: !ВНМ: "..Table("name").." ::>", "HUDFont", Position.x, Position.y, Color(255, 0, 10, 255), 1 )
		draw.DrawText( "<:: Дистанция: " .. math.floor(distance), "HUDFont", Position.x, Position.y + 10, Color(255, 0, 10, 255), 1 )
		end
	elseif (ita == "Ammunition") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: !ВНМ: "..Table("name").." ::>", "HUDFont", Position.x, Position.y, Color(10, 80, 255, 255), 1 )
		draw.DrawText( "<:: Дистанция: " .. math.floor(distance), "HUDFont", Position.x, Position.y + 10, Color(10, 80, 255, 255), 1 )
		end
	elseif (ita == "Medical" and ita != "Weapons" and ita != "Ammunition") then
		if (ent:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVarNumber("evo_outline_distance")) then
		draw.DrawText( "<:: "..Table("name").." ::>", "HUDFont", Position.x, Position.y, Color(0, 255, 10, 255), 1 )
		draw.DrawText( "<:: Дистанция: " .. math.floor(distance).." ::>", "HUDFont", Position.x, Position.y + 10, Color(0, 255, 10, 255), 1 )
		end
	end
				end
			end

		end	
end)

-- A function that modifies the Combine Display lines.
function Schema:AddCombineDisplayLine(text, color)
	if (self:PlayerIsCombine(Clockwork.Client)) then
		if (!self.combineDisplayLines) then
			self.combineDisplayLines = {}
		end
		
		table.insert(self.combineDisplayLines, {"<:: "..text.." ::>", CurTime() + 90, 5, color})
	end
end
include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

// Stolen from vendors code
local TEXT_OFFSET = Vector(0, 0, 20)
local toScreen = FindMetaTable("Vector").ToScreen
local colorAlpha = ColorAlpha
local drawText = nut.util.drawText
local configGet = nut.config.get
local use = input.LookupBinding( "+use", true ):upper();
local speed = input.LookupBinding( "+speed", true ):upper();
ENT.DrawEntityInfo = true

function ENT:onDrawEntityInfo(alpha)
	local position = toScreen(self:LocalToWorld(self:OBBCenter()) + TEXT_OFFSET)
	local x, y = position.x, position.y
	local info = self:getNetVar("info")

	if info["soil"] != "" && info["seeds"] != "" && info["water"] != "" then
		drawText((!self:getNetVar('grown') && "Seed is growing...") or "Seed is grown, time to harvest!", x, y, colorAlpha(Color(54, 167, 54), alpha), 1, 1, "comfie", alpha * 0.65)
		drawText("Planted: "..info["seeds"], x, y+25, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
		drawText("Hold "..speed.." + "..use.." to dump or harvest this plant.", x, y+45, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
		return;
	end

	if info["soil"] == "" then
		drawText("Empty seed pot", x, y, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
		drawText("Hold "..speed.." + "..use.." to take this pot in your inventory.", x, y+15, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
	else 
			drawText("Pot with soil in it", x, y, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
			drawText("Hold "..speed.." + "..use.." to dump or harvest this plant.", x, y+15, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
			if info["seeds"] != "" then
				drawText("It seems like someone put a seed in soil.", x, y+32, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
			end
			if info["water"] != "" then
				drawText("The seed is watered.", x, y+47, colorAlpha(configGet("color"), alpha), 1, 1, "comfie", alpha * 0.65)
			end
	end;
end

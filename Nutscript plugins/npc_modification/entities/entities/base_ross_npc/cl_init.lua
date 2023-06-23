include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

ENT.DrawEntityInfo = true
function ENT:onDrawEntityInfo(alpha)
	local vector = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 20);
	local position = vector:ToScreen()
	local x, y = position.x, position.y
	local data = self:getNetVar("data")

	nut.util.drawText(
		data.name,
		x, y,
		ColorAlpha(nut.config.get("color"), alpha),
		1, 1,
		nil,
		alpha * 0.65
	)
end
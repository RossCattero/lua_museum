include("shared.lua");

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.optionsList = {
		["Show missions"] = function()
			if nut.mission.derma && nut.mission.derma:IsValid() then
				nut.mission.derma:Close()
			end

			nut.mission.derma = vgui.Create("MissionsList")
			nut.mission.derma:Refresh()
		end;
	}
end;
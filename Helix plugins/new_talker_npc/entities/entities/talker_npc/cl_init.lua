include("shared.lua");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;

function ENT:OnPopulateEntityInfo(tooltip)
	local sellername = tooltip:AddRow("name")
	sellername:SetImportant()
	sellername:SetText(self:GetDefaultName())
	sellername:SetBackgroundColor(Color(255, 255, 255))
	sellername:SetTextInset(8, 0)
	sellername:SizeToContents()
end

function ENT:GetEntityMenu(client)
	local options = {};
	options["Поговорить"] = "talker_npc_talk";
	options["Торговать"] = "talker_npc_vendor";
	options["Настроить"] = "talker_npc_settings";
	return options
end;
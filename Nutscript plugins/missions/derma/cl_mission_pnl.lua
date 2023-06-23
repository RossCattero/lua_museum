local PANEL = {}

function PANEL:Init()
	self.textData = self:Add("DLabel")
	self.textData:Dock(FILL)
	self.textData:SetText("")
	self.textData:SetContentAlignment(5)
	self.textData:SetTextColor(color_white)
	self.textData:SetFont("BankingButtons")
	self.textData:DockMargin(10, 0, 0, 0)

	self:DockMargin(0, 5, 0, 5)
	self:SetCursor("hand")
	self:SetMouseInputEnabled(true)

	timer.Create("nut.mission.derma.update", 1, 0, function()
		if nut.mission.derma && nut.mission.derma:IsValid() then
			nut.mission.derma:Refresh()
		else
			timer.Remove("nut.mission.derma.update")
		end;
	end)
end

function PANEL:SetTitle( title )
	self.textData:SetText(title or "#ERR#")
	self.textData:SizeToContents()
end;

function PANEL:SetData( uniqueID )
	local data = nut.mission.list[uniqueID];
	local canFinish = nut.mission.CanFinishThere( LocalPlayer(), uniqueID );
	local stack = nut.mission.stack.instances[ LocalPlayer():getChar():getID() ];
	local cd = stack.cooldowns[uniqueID];
	local textData = 
	Format("%s %s", data.name, 
	(cd && (cd > os.time()) && os.date( "in %M:%S" , stack.cooldowns[uniqueID] - os.time() ))
	|| (canFinish && "[FINISH]" or ""))
	
	self:SetTitle( textData )
	self.uniqueID = uniqueID;
end;

function PANEL:OnMousePressed( code )
	if self.uniqueID then
		local canPick = nut.mission.CanPickMission( LocalPlayer(), self.uniqueID );
		local canFinish = nut.mission.CanFinishThere( LocalPlayer(), self.uniqueID )
		if canPick then
			netstream.Start("nut.mission.Instance", self.uniqueID)
		else
			if canFinish then
				netstream.Start("nut.mission.FinishByID", self.uniqueID)
			else
				nut.util.notify("You can't pick or finish this mission.")
			end;
		end;
	end
end;

function PANEL:Paint(w, h)
	local canFinish = nut.mission.CanFinishThere( LocalPlayer(), self.uniqueID )
	local mainClr = canFinish && Color(10, 150, 10) || nut.config.get("color");
	local disClr = Color(mainClr.r - 35, mainClr.g - 35, mainClr.b - 35)

	draw.RoundedBox(8, 0, 0, w, h, (self:IsEnabled() && mainClr or disClr) )
end;

vgui.Register("MissionPanel", PANEL, "EditablePanel")
local sw, sh = ScrW(), ScrH()
local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true);

	self:Place(400, 600)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

	self.colWide = sw * 0.05
	self.rowHeight = sh * 0.09

	self.dataList = self:Add("DScrollPanel")
	self.dataList:Dock(FILL)
	self.dataList:DockMargin(10, 10, 10, 0)

	local ConVas, ScrollBar = self.dataList:GetCanvas(), self.dataList:GetVBar()
    ScrollBar:SetWidth(1)
	ScrollBar:SetHideButtons( true )
	function ScrollBar.btnGrip:Paint(w, h) 
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255)) 
	end	

	self.closePanel = self:Add("Panel")
	self.closePanel:Dock(BOTTOM)
	self.closePanel:DockMargin(5, 5, 5, 5)

	self.exit = self.closePanel:Add("BankingButton")
	self.exit:Dock(FILL)
	self.exit:SetText("Exit")
	self.exit.DoClick = function(button)
		self:Close()
	end;
end

function PANEL:Refresh()
	local client = LocalPlayer()
	self.dataList:Clear();

	for k, v in pairs( nut.mission.list ) do
		local pick, finish = 
		nut.mission.CanPickMission( client, k ), nut.mission.CanFinishThere( client, k )

		local mission = self.dataList:Add("MissionPanel")
		mission:Dock(TOP)
		mission:SetTall(sh * 0.085)
		mission:SetData( k )
		mission.nutToolTip = true
		mission:SetTooltip("<font=BankingTitleSmaller>"..tostring(v:GetTooltip()).."</font>")

		mission:SetEnabled( pick || finish )
	end
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

vgui.Register("MissionsList", PANEL, "EditablePanel")
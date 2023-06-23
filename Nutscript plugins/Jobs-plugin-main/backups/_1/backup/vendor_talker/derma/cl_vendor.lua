local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local matGradient = Material("gui/gradient_up")

local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(806.4, 600, 0.28, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
        if PLUGIN.debug then
            self.debugClose = true;
        end;
    end);
end

function PANEL:Populate()
    local REPUTATION = LocalPlayer():GetVendorRep()

    self:CheckWorks()

    self.CloseButton = self:Add("CompButton")
    self.CloseButton:Dock(BOTTOM)
    self.CloseButton:SetText("Close")
    self.CloseButton:DockMargin(sw*0.1, sh * 0.012, sw*0.1, sh * 0.012)
    self.CloseButton.DoClick = function(btn)
        self:Close()
    end;

    self.Reputation = self:Add("DLabel")
    self.Reputation:Dock(BOTTOM)
    self.Reputation:SetText("Reputation: " .. REPUTATION)
    self.Reputation:SetContentAlignment(5)
    self.Reputation:SetFont("JobHighlight")
    self.Reputation:DockMargin(sw*0.1, 5, sw*0.1, 5)
    self.Reputation:SetTextColor( Color(255-REPUTATION, 255, 255-REPUTATION) )
end

function PANEL:CheckWorks()
    if self.ScrollPanel then
        self.ScrollPanel:Remove();
    end
    if self.TimeLeft then
        self.TimeLeft:Remove()
        self.jobName:Remove()
        self.jobPrice:Remove()
    end
    local user = LocalPlayer()
    local worked = user:WorkInProgress();

    if !worked then
        self.ScrollPanel = self:Add("CompHorScroll")
        self.ScrollPanel:Dock( FILL )
    
        for k, v in pairs(PLUGIN.jobsList) do
            local jobPanel = vgui.Create("JobSlice")
            jobPanel.notChoose = !tobool(user:CanPickJob(k))
            jobPanel:Dock(LEFT)
            jobPanel:SetWide(sw * 0.14)
            jobPanel:SetWorkData(v)
            
            self.ScrollPanel:AddPanel(jobPanel)
        end
    else
        self.jobName = self:Add("DLabel")
        self.jobName:Dock(TOP)
        self.jobName:SetText(user:GetJobName())
        self.jobName:SetContentAlignment(5)
        self.jobName:SetFont("JobHighlight")
        self.jobName:DockMargin(0, sh * 0.25, 0, 0)

        self.jobPrice = self:Add("DLabel")
        self.jobPrice:Dock(TOP)
        self.jobPrice:SetText("Job price: " .. nut.currency.get(user:GetJobPrice()))
        self.jobPrice:SetContentAlignment(5)
        self.jobPrice:SetFont("JobHighlight")
        self.jobPrice:DockMargin(0, 0, 0, 0)

        self.TimeLeft = self:Add("DLabel")
        self.TimeLeft:Dock(TOP)
        self.TimeLeft:SetText("")
        self.TimeLeft:SetContentAlignment(5)
        self.TimeLeft:SetFont("JobHighlight")
        self.TimeLeft:DockMargin(0, 0, 0, sh * 0.25)
        self.TimeLeft.Think = function(lbl)
            local uniqueID = "WorkTime: " .. user:getChar():getID();

            if timer.Exists(uniqueID) then
                local time = RFormatTime(timer.RepsLeft(uniqueID))
                lbl:SetText("Job time left: " .. time)
            end;
        end;
    end;
end;

function PANEL:Paint( w, h )
    if PLUGIN.debug then self:DebugClose() end;
    
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	surface.SetDrawColor(Color(50, 50, 50, 225))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(25, 25, 25, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 2 )	
end;

function PANEL:OnRemove()
    VENDOR_INTERFACE = nil;
    JOBPOSES = nil;
end;

vgui.Register( "TalkerVendor", PANEL, "EditablePanel" )
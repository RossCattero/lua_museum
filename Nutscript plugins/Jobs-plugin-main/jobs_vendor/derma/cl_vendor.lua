local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local matGradient = Material("gui/gradient_up")
local math = math;
local appr = math.Approach

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

local PANEL = {}

function PANEL:Init()
		self:SetMouseInputEnabled( true )
		timer.Simple(0, function()
				self:Populate()
		end)
end

function PANEL:SetWorkData(data)
		self.work = data or {}
end;

function PANEL:Populate()
		if !self.work then self:Remove() return end;
		local minAmount, lineAmount, min, max;
    local REPUTATION = LocalPlayer():GetVendorRep()

		local workDesc = self.work.description

		self.job = self:Add("DPanel")
    self.job:Dock(TOP)
		self.job:SetMouseInputEnabled( true )
    self.job.Paint = function(s, w, h) end;
		self.job.OnMousePressed = function()
				self:OnMousePressed()
		end;

		self.title = self.job:Add("DLabel")
    self.title:Dock(TOP)
    self.title:SetText(self.work.title or "Unknown")
    self.title:SetFont("JobHighlight")
    self.title:SetContentAlignment(5)

		if workDesc != "" && workDesc:len() > 0 then
				local x, y = surface.GetTextSize(workDesc)
				minAmount = y
				lineAmount = math.ceil(workDesc:len() / minAmount);
				for i = 1, lineAmount do
						min = (i-1) * minAmount;
						max = i * minAmount

						local stringLine = self.job:Add("DLabel")
						stringLine:SetFont("JobDescription")
						stringLine:Dock(TOP)
						stringLine:SetText( workDesc:sub(min, max-1) )
						stringLine:SetContentAlignment(5)
						stringLine:DockMargin(sw * 0.005, sh * 0.005, sw * 0.002, i == lineAmount && sh * 0.005 || 0)
				end
		end

		self.job:DockMargin(0, sh * 0.15 - (lineAmount or 1 * 5), 0, 0)

		self.price = self.job:Add("DLabel")
		self.price:Dock(TOP)
		self.price:SetText("Price: ".. nut.currency.get(self.work.price or 0))
		self.price:SetContentAlignment(5)
		self.price:SetFont("JobHighlight")

		if REPUTATION > 0 then
			local bonus = 
			(REPUTATION * (JOBREP.repMutli / 100)) 
			+ 
			(self.work.price * (JOBREP.priceMulti / 100));
			bonus = math.Round(bonus, 2)
			self.bonus = self.job:Add("DLabel")
			self.bonus:Dock(TOP)
			self.bonus:SetText("Bonus: +".. nut.currency.get(bonus or 0))
			self.bonus:SetContentAlignment(5)
			self.bonus:SetFont("JobHighlight")
			self.bonus:SetTextColor(Color(100, 200, 100))
		end;

		self.choose = self.job:Add("DLabel")
		self.choose:Dock(TOP)
		self.choose:SetText(!self.notChoose && "Click to choose this work" || "You can't choose this work now")
		self.choose:SetContentAlignment(5)
		self.choose:SetFont("JobDescription")
		self.choose:SetTextColor( Color(150, 150, 150) )
		self.choose:SetAlpha(0)
		self.choose:DockMargin(0, sh * 0.15, 0, 0)

		self.dColor = Color(0, 0, 0, 0);
		self.dCopy = self.dColor
		
		self.job:InvalidateLayout(true)
		self.job:SizeToChildren(true, true)
end;

function PANEL:OnMousePressed()
		if LocalPlayer():GetJobID() != 0 || self.notChoose then
				return
		end
		Derma_Query("Do you want to pick up this work?", self.work.title or "Unknown", 
		"Yes", 
		function() 
				if LocalPlayer():GetJobID() == 0 then
						netstream.Start('jobVendor::pickWork', self.work.uniqueID)
						
						local uniqueID = "WorkTime: " .. LocalPlayer():getChar():getID()
						timer.Simple(0, function()
								if VENDOR_INTERFACE then
										VENDOR_INTERFACE:CheckWorks()
								end;
						end)
						timer.Create(uniqueID, 1, self.work.timeForRepair, function()
								if !timer.Exists(uniqueID) || !LocalPlayer():IsValid() then timer.Remove(uniqueID) return; end;
								
								if timer.RepsLeft(uniqueID) <= 0 then
									timer.Simple(0, function()
										if VENDOR_INTERFACE then
											VENDOR_INTERFACE:CheckWorks()
										end;
									end);
								end
						end);
				end
		end,
		"No")
end;

function PANEL:Paint( w, h )
		if !self.dColor then return end;
		
		local incTo = !self.notChoose && Color(139, 23, 155, 150) || Color(177, 60, 80, 150)
		local cCopy = self.dCopy 
		local hov = self:IsHovered() || self:IsChildHovered()
		local red, green, blue, alpha = self.dColor.r, self.dColor.g, self.dColor.b, self.dColor.a
		self.dColor = {
				r = appr(red, hov && incTo.r || cCopy.r, FrameTime() * 700),
				g = appr(green, hov && incTo.g || cCopy.g, FrameTime() * 700),
				b = appr(blue, hov && incTo.b || cCopy.b, FrameTime() * 700),
				a = appr(alpha, hov && incTo.a || cCopy.a, FrameTime() * 700)
		}
		surface.SetDrawColor( self.dColor )
		surface.SetMaterial( matGradient )
		surface.DrawTexturedRect( 0, 0, w, h )

		if self:IsHovered() || self:IsChildHovered() then
				if self.choose && self.choose:GetAlpha() == 0 then
						self.choose:AlphaTo(255, .3, 0, function() end)
				end
		elseif self.choose && self.choose:GetAlpha() >= 255 then
				self.choose:AlphaTo(0, .3, 0, function() end)
		end;
end;

vgui.Register( "JobSlice", PANEL, "DPanel" )
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}

local TITLE = "Job editor"

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(500, 400, 0.35, 0.35)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
        self.debugClose = true;
    end);
end

function PANEL:Populate()
		self.scroll = self:Add("CompScroll")
		self.scroll:Dock(FILL)
		self.scroll:DockMargin(0, 0, 0, sh * 0.02)

		self.title = self.scroll:Add("DLabel")
		self.title:Dock(TOP)
		self.title:SetText(TITLE)
		self.title:SetContentAlignment(5)
		self.title:SetFont("JobEditorTitle")
		self.title:SetTextColor( Color(255, 255, 255) )
		self.title:DockMargin(0, sh * 0.01, 0, 0)

		self.bgAdd = self.scroll:Add("AddJobToPos")
		self.bgAdd:Dock(TOP)
		self.bgAdd:SetTall(sh * 0.12)

		self.bgRemove = self.scroll:Add("RemJob")
		self.bgRemove:Dock(TOP)
		self.bgRemove:SetTall(sh * 0.15)

		self.CloseButton = self.scroll:Add("CompButton")
    self.CloseButton:Dock(TOP)
    self.CloseButton:SetText("Close")
    self.CloseButton.DoClick = function(btn)
        self:Close()
    end;
end;

function PANEL:Paint( w, h )
		self:DebugClose()
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		surface.SetDrawColor(Color(50, 50, 50, 225))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(25, 25, 25, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 2 )	
end;

function PANEL:OnRemove()
    VENDOR_INTERFACE = nil;
		POSES = nil;
end;

vgui.Register( "AddJobPlace", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:Init()
		local jobPos = LocalPlayer():GetEyeTraceNoCursor()
		self.poslbl = self:Add("DLabel")
		self.poslbl:Dock(TOP)
		self.poslbl:SetText("Position: " .. tostring(jobPos.HitPos))
		self.poslbl:SetContentAlignment(5)
		self.poslbl:SetFont("JobEditorTitle")
		self.poslbl:SetTextColor( Color(255, 255, 255) )
		self.poslbl:DockMargin(0, sh * 0.01, 0, 0)

		self.jobType = self:Add("DComboBox")
		self.jobType:Dock(TOP)
		self.jobType:SetTall(sh * 0.025)
		self.jobType:SetFont("JobBtns")
		self.jobType:SetValue("Click to choose work type")
		self.jobType:DockMargin(sw * 0.05, sh * 0.005, sw * 0.05, 0)
		self.jobType:SetTextColor(color_white)
		self.jobType:SetContentAlignment(5)
		self.jobType.DropButton:SetVisible(false)
		self.jobType.Paint = function(s, w, h)
			surface.SetDrawColor(Color(70, 70, 70, 255))
			surface.DrawRect(0, 0, w, h)
		end;
		self.jobType.OnSelect = function(combo, index, text, data)
				self.addJob.disabled = false;
		end;

		self.addJob = self:Add("CompButton")
    self.addJob:Dock(TOP)
		self.addJob:SetTall(sh * 0.02)
    self.addJob:SetText("Add work at position")
		self.addJob:DockMargin(sw * 0.05, sh * 0.005, sw * 0.05, 0)
		self.addJob.disabled = true; 
    self.addJob.DoClick = function(btn)
				if self.jobType.selected && !btn.disabled then
						netstream.Start('jobVendor::PosAdd', self.jobType:GetOptionData(self.jobType.selected))
						surface.PlaySound("buttons/blip1.wav")
				end;
    end;

		self.notice = self:Add("DLabel")
		self.notice:Dock(TOP)
		self.notice:SetText("Job will be unavailable until the player activates it with vendor")
		self.notice:SetContentAlignment(5)
		self.notice:SetFont("JobBtns")
		self.notice:DockMargin(0, sh * 0.005, 0, 0)

		for k, v in pairs(PLUGIN.jobsList) do
				self.jobType:AddChoice(v.title, k, false)
		end
end
vgui.Register( "AddJobToPos", PANEL, "JobSubPanel" )
///
local PANEL = {}

function PANEL:Init()
		self.remList = self:Add("DListView")
		self.remList:Dock(FILL)
		self.remList:SetMultiSelect(false)
		self.remList:AddColumn("Job name")
		self.remList:AddColumn("Position")
		self.remList:AddColumn("Added by")

		self:Refresh(POSES)
end

function PANEL:Refresh(data)
		self.remList:Clear()
		for k, v in pairs(data) do
				local i = 1;
				while (i <= #v) do
						local line = self.remList:AddLine(k, v[i][1], v[i][2])
						line.jobID = i;
						line.jobUnique = k;
						line.OnSelect = function(line)
							local menu = DermaMenu() 
							local remove = menu:AddOption( "Remove position", function() 
									netstream.Start('jobVendor::removeJob', line.jobUnique, line.jobID)
							end)
              remove:SetIcon("icon16/bin_closed.png")
							local showPos = menu:AddOption( "Show position for 30 seconds", function()

							end)
              showPos:SetIcon("icon16/eye.png")
							menu:Open()
						end;
						i = i + 1;
				end
		end
end;
vgui.Register( "RemJob", PANEL, "JobSubPanel" )


local PLUGIN = PLUGIN;
local matGradient = Material("gui/gradient_up")
local sw, sh = ScrW(), ScrH();
local math = math;
local appr = math.Approach;

local PANEL = {}

function PANEL:Init()	
		timer.Simple(0, function()
			self:Populate()
		end)
end

function PANEL:Populate()
		self.btnLeft.Paint = function(s, w, h) 
				surface.SetDrawColor(Color(255, 255, 255))
				surface.DrawLine( w - 8, 3.5, 2.5, h/2 )
				surface.DrawLine( w - 8, h - 3.5, 2.5, h/2 )
		end
		self.btnRight.Paint = function(s, w, h) 
				surface.SetDrawColor(Color(255, 255, 255))
				surface.DrawLine( 2.5, 3.5, w - 8, h/2 )
				surface.DrawLine( 2.5, h - 3.5, w - 8, h/2 )
		end
end;

vgui.Register( "CompHorScroll", PANEL, "DHorizontalScroller" )


local PANEL = {}

function PANEL:Init()
    local ConVas, ScrollBar = self:GetCanvas(), self:GetVBar()
    ScrollBar:SetWidth(5)
    ScrollBar:DockMargin(5, 5, 5, 5)
		ScrollBar:SetHideButtons( true )
		function ScrollBar:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 50)) end
		function ScrollBar.btnGrip:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 100)) end
end
vgui.Register( "CompScroll", PANEL, "DScrollPanel" )

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SizeToContents()
		self:SetMouseInputEnabled( true )
    self:SetContentAlignment(5)
    self:SetCursor("hand")

		self:SetFont("JobBtns")

		self.clrPaintTo = Color(255, 185, 138)
end

function PANEL:Paint( w, h )
    if self.Disable then
        self:SetColor(Color(100, 100, 100));
        return;
    end
    if self:IsHovered() then
	    if !self.soundPlayed then
			surface.PlaySound("helix/ui/rollover.wav")
			self:ColorTo(self.clrPaintTo, .2, 0, function() self:SetColor(self.clrPaintTo) end);
			self.soundPlayed = true;
		end;
	elseif !self:IsHovered() then
		self:SetColor(color_white)
		self.soundPlayed = false;
	end
end;

function PANEL:SetDisabled( bool )
		self.Disable = bool;
end;

function PANEL:OnMousePressed()
		if self.Disable then
				return;
		end;

		self:DoClick(self)
end

vgui.Register( "CompButton", PANEL, "DLabel" )

local PANEL = {}

function PANEL:Init() 
		self:DockMargin(sw * 0.01, sh * 0.01, sw * 0.01, sh * 0.01)
end

function PANEL:Paint( w, h )
		surface.SetDrawColor(Color(60, 60, 60, 150))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(25, 25, 25, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
end;

vgui.Register( "JobSubPanel", PANEL, "DPanel" )

local PANEL = {}
function PANEL:Init() end

function PANEL:Paint( w, h )
    if self:GetPlaceholderText() && self:GetText():len() == 0 then
        draw.SimpleText(self:GetPlaceholderText(), "TaxiFontSmaller", sw * 0.005, sh * 0, Color(255, 255, 255, self:GetDisabled() && 25 || 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end
		self:DrawTextEntryText( Color(255, 255, 255), Color(75, 75, 75), Color(255 ,255, 255) )

    surface.SetDrawColor(Color(70, 70, 70, self:GetDisabled() && 50 || 100))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(10, 10, 10, self:GetDisabled() && 50 || 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;
vgui.Register( "CompEntry", PANEL, "DTextEntry" )
local PANEL = {}
function PANEL:Init()
    self:Dock(FILL)
    self:SetFont("TaxiFontBigger")
    self:SetContentAlignment(5)
    self:SizeToContents()
end;
vgui.Register( 'CLabel', PANEL, 'DLabel' )

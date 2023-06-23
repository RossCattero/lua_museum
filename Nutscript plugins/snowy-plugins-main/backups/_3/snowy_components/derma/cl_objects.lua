local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH()

local PANEL = {}
function PANEL:Init()
    local ConVas, ScrollBar = self:GetCanvas(), self:GetVBar()
    ScrollBar:SetWidth(5)
    ScrollBar:DockMargin(5, 5, 5, 5)
		ScrollBar:SetHideButtons( true )
		function ScrollBar:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 50)) end
		function ScrollBar.btnGrip:Paint(w, h) draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 100)) end
end
vgui.Register( "ModScroll", PANEL, "DScrollPanel" )

local PANEL = {}
function PANEL:Init()
    self:Dock(TOP)
    self:SetFont("Generic Banking")
end

function PANEL:Paint( w, h )
    if self:GetPlaceholderText() && self:GetText():len() == 0 then
        draw.SimpleText(self:GetPlaceholderText(), "Banking info smaller", sw * 0.005, sh * 0, Color(255, 255, 255, self:GetDisabled() && 25 || 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end
	self:DrawTextEntryText( Color(255, 255, 255), Color(75, 75, 75), Color(255 ,255, 255) )

    surface.SetDrawColor(Color(70, 70, 70, self:GetDisabled() && 50 || 100))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(10, 10, 10, self:GetDisabled() && 50 || 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;
vgui.Register( "ModEntry", PANEL, "DTextEntry" )

local PANEL = {}

function PANEL:Init()
    self:Dock(LEFT)
    self:SetFont("SearchFont")
    self:SetTextColor(Color(255, 255, 255))
end

function PANEL:Paint( w, h )
    surface.SetDrawColor(Color(70, 70, 70, 100))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(10, 10, 10))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;

vgui.Register( "ModCombo", PANEL, "DComboBox" )


local PANEL = {}

function PANEL:Init() 
    self:Dock(TOP)
    self:SetContentAlignment(5)
    self:SizeToContents()
    self:SetAutoStretchVertical(true)
    self:SetFont("Generic Banking")
end;
vgui.Register( "ModLabel", PANEL, "DLabel" )

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:SizeToContents()
	self:SetMouseInputEnabled( true )
    self:SetContentAlignment(5)
    self:SetCursor("hand")
end

function PANEL:Dis(bool)
    self.disabled = bool;
end;

function PANEL:Paint( w, h )
    if self.disabled then
        self:SetColor(Color(100, 100, 100));
        return;
    end
    if self:IsHovered() then
	    if !self.soundPlayed then
			surface.PlaySound("helix/ui/rollover.wav")
			self:ColorTo(Color(255, 185, 138), .2, 0, function() self:SetColor(Color(255, 185, 138)) end);
			self.soundPlayed = true;
		end;
	elseif !self:IsHovered() then
		self:SetColor(color_white)
		self.soundPlayed = false;
	end
end;

vgui.Register( "MButt", PANEL, "DLabel" )

local PANEL = {}

function PANEL:Init()
	self:Dock(BOTTOM)
	self:DockMargin(4, 0, 4, 4)
    self:SetFont("Banking info smaller")
end

function PANEL:Paint( w, h )    
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.DrawRect(0, 0, w, h)
    self:DrawTextEntryText( Color(192, 192, 192), Color(255, 255, 255, 50), Color(192, 192, 192) )

    if self:GetText():len() == 0 then
        draw.SimpleText("Search...", "Banking info smaller", 5, 0, Color(100, 100, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    end;
end;

vgui.Register( "TermEntry", PANEL, "DTextEntry" )

local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment(5)
	self:SetFont("Banking id")
    self:SizeToContents()
	self:SetMouseInputEnabled(true)
end

function PANEL:Paint( w, h )
	if self:IsHovered() && !self.disable || self.choosen then
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
	else
		draw.RoundedBox(0, 0, 0, w, h, Color(45, 45, 45, 255))
	end;
end;

function PANEL:DecodeBITS()
    local bits = DIFF["positions"][pass_INT];
    local row, column, tag = 
    math.IntToBin(self.InRow), 
    math.IntToBin(self.InColumn), 
    math.IntToBin("0x"..self.TAG);
   
    return bits == tag .. column .. row;
end;

function PANEL:OnMousePressed()
    surface.PlaySound("ambient/machines/keyboard"..math.random(1, 6).."_clicks.wav")
    if self.disable then return end;
    
    local interface = VAULT_INTERFACE
    if !interface then return end;

    local text = self:GetText()

    if self:DecodeBITS() then
        PASSWD = PASSWD..text 
        interface.pword:SetText("Password: " .. PASSWD)
        pass_INT = pass_INT + 1;
        if pass_INT <= SCENARIO.INTER then interface.TAG:SetText(DIFF["positions"][pass_INT]) end;
        self.choosen = true;
        self:DISABLE(true)
        netstream.Start('bank::ValidateVaultPassword', PASSWD)
    else
        netstream.Start('bank::SyncVaultAttempts')
        ATTEMPTS = math.max(ATTEMPTS - 1, 0);
        if ATTEMPTS <= 0 then
            interface:Close()
            return;
        end
    end;
    
    
    interface.att:SetText("Attempts: " .. ATTEMPTS .. "/" .. SCENARIO.ATTEMPTS)
end;

function PANEL:DISABLE(bool)
	self.disable = bool;
end;

vgui.Register( "DIGIT", PANEL, "DLabel" )
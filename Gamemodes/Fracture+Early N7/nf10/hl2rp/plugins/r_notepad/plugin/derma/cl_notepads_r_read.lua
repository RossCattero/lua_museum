
local PANEL = {};
local FractureCol = Color(255, 97, 0)
local mat = Material('materials/paper.jpg')

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();

	self:SetPos((scrW/2) - 250, (scrH/2) - 350) 
    self:SetSize( 560, 610 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
	local pnl = self;
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
	draw.DrawText( self.currentPage.."/"..table.Count(self.pages), "DermaDefault", 60, 585, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false); 
end;

function PANEL:Populate(pages)
	local pnl = self;
	self.pages = pages

	self.currentPage = 1;

	self.paper = vgui.Create( "DPanel", self )
	self.paper:SetPos( 10, 10 )
	self.paper:SetSize( 540, 565 )
	self.paper.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;

	self.hp = vgui.Create("DHTML", self.paper);
    self.hp:Dock(FILL)
	self.hp:SetWrap(true);
	self.hp:SetHTML([[
		<!DOCTYPE HTML>
		<html>
			<head><style>
				body {
					-khtml-opacity: .50;
					-moz-opacity: .50;
					-ms-filter: ”alpha(opacity=50)”;
					filter: alpha(opacity=50);
					filter: progid:DXImageTransform.Microsoft.Alpha(opacity=0.5);
					opacity: .90;						
					word-wrap: break-word;
					padding: 2px;
					font-size: 15px;
					color:black;
				}
				</style></head>
			<body>
				
			</body>
		</html>
	]]);
	local text = tostring(pages[pnl.currentPage]['info']);
	pnl.hp:Call( 'document.body.innerHTML = \"'..text..'\";' )
	self.CloseTab = vgui.Create( "DButton", self )
	self.CloseTab:SetSize( 70, 25 )
	self.CloseTab:SetPos(480, 580)
	self.CloseTab:SetText("ЗАКРЫТЬ")
	self.CloseTab:SetTextColor(FractureCol)
	self.CloseTab.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
	self.CloseTab.DoClick = function(self)
		pnl:Close();
	end;

	self.Before = vgui.Create( "DButton", self )
	self.Before:SetSize( 40, 25 )
	self.Before:SetPos(10, 580)
	self.Before:SetText("<")
	self.Before:SetTextColor(FractureCol)
	self.Before.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
	self.Before.DoClick = function(self)
		pnl.currentPage = math.Clamp(pnl.currentPage - 1, 1, table.Count(pages));
		local text = tostring(pages[pnl.currentPage]['info']);
		pnl.hp:Call( 'document.body.innerHTML = \"'..text..'\";' )
	end;
	self.After = vgui.Create( "DButton", self )
	self.After:SetSize( 40, 25 )
	self.After:SetPos(85, 580)
	self.After:SetText(">")
	self.After:SetTextColor(FractureCol)
	self.After.DoClick = function(self)
		pnl.currentPage = math.Clamp(pnl.currentPage + 1, 1, table.Count(pages));
		local text = tostring(pages[pnl.currentPage]['info']);
		pnl.hp:Call('document.body.innerHTML = \"'..text..'\";')
	end;
	self.After.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

function dohover(pnl, w, h)
	if !pnl.nol then
		pnl.nol = 0
	end;
	if pnl:IsHovered() then
		pnl.nol = math.Approach( pnl.nol, w, 300 * FrameTime() )
		draw.RoundedBox(0, 0, 0, pnl.nol, h, Color(255, 255, 255, 100));
	else
		pnl.nol = 0
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100));
	end;
end;

vgui.Register( "OpenNotepad", PANEL, "DFrame" )
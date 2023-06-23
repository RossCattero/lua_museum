local dermaMeta = FindMetaTable( 'Panel' )

baseColor = Color(12, 12, 12, 100);
whiteColor = Color(231, 234, 217);
lightColor = Color(249, 106, 17, 255);
lightColorHover = Color(242, 157, 17, 255);

function dermaMeta:Adaptate(w, h, x, y)
    local sW, sH = ScrW(), ScrH()
    x = x or 0.1; y = y or 0.1
    w = w or 100; h = h or 100

    self:SetPos( sW * math.min(x, 0.95), sH * math.min(y, 0.95) ) 
    self:SetSize( sW * (w / 1920), sH * (h / 1080) )
end;

function dermaMeta:CreateCloseDebug()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:CloseMe();

        function self:OnRemove()
            listOfAll = {}
            GetAllPanels = {}
            toolTiped = false;            
            GlobalOpened = false;
        end;
    end;
end;

function dermaMeta:CloseMe()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function dermaMeta:dohover(w, h)
    if !self.zeroed then self.zeroed = 0 end;
    local frameTime = 600 * FrameTime()
	if self:IsHovered() then
        self.zeroed = math.Approach( self.zeroed, 150, frameTime)
        self:SetTextColor(lightColorHover)
    else
        self.zeroed = math.Approach( self.zeroed, 0, frameTime )
        self:SetTextColor(lightColor)
	end;
    draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, self.zeroed));
end;

function draw.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )
	x, y, w, h = math.Round( x ), math.Round( y ), math.Round( w ), math.Round( h )
	draw.RoundedBox( bordersize, x, y, w, h, color )
	surface.SetDrawColor( bordercol )
	surface.DrawTexturedRectRotated( x + bordersize/2, y + bordersize/2, bordersize, bordersize, 0 ) 
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + bordersize/2, bordersize, bordersize, 270 ) 
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + h - bordersize/2, bordersize, bordersize, 180 ) 
	surface.DrawTexturedRectRotated( x + bordersize/2, y + h - bordersize/2, bordersize, bordersize, 90 ) 
	surface.DrawLine( x + bordersize, y, x + w - bordersize, y )
	surface.DrawLine( x + bordersize, y + h - 1, x + w - bordersize, y + h - 1 )
	surface.DrawLine( x, y + bordersize, x, y + h - bordersize )
	surface.DrawLine( x + w - 1, y + bordersize, x + w - 1, y + h - bordersize )
end;

--[[ ЭКСПОРТ ]]--

function dermaMeta:ExportFunctionCall()
    file.CreateDir('__DermaExports');
    local directory = '__dermaexports/' .. tostring(os.time())

    PrintTable(dermaMeta)

    -- local exportedDerma = 
    -- [[
    -- local test = vgui.Create('DPanel')
    -- test:SetPos( 10, 10 )
    -- test:SetSize( 100, 100 )
    -- test.Paint = function(s, w, h)
    --     draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255))
    -- end;
    -- ]]

    file.Write(directory .. '.txt', exportedDerma)

end;

--[[ ЭКСПОРТ ]]--
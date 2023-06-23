local panelMeta = FindMetaTable('Panel')
local PLUGIN = PLUGIN;

function panelMeta:Adaptate(w, h, x, y)
    local sW, sH = ScrW(), ScrH()
    local positions = (x && y && x + y > 0)

    w = clamp(w, 10, 1920);
    h = clamp(h, 10, 1080);
    self:SetSize( sW * (w / 1920), sH * (h / 1080) )

    x = positions && clamp(x, 0, 1.25) || 0;
    y = positions && clamp(y, 0, 1.25) || 0;
    self:SetPos( sW * x, sH * y )
    if !positions then self:Center() end
end;
    
function panelMeta:DebugClose()
	local use = input.IsKeyDown( KEY_PAD_MINUS );

	if use && CLOSEDEBUG then
        CLOSEDEBUG = false;
    	surface.PlaySound("ui/buttonclick.wav");
    	self:Close();
    end;
end;

function panelMeta:Close()
	gui.EnableScreenClicker(false);
	self:AlphaTo(0, .2, 0, function() self:SetVisible(false); self:Remove() end)
end;

function panelMeta:DrawBlur()
    return Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
end

function panelMeta:PaintLess()
    self.Paint = function(s, w, h) end;
end;

function draw.OutlineRectangle(x, y, w, h, clr, bclr)
    surface.SetDrawColor(clr)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(bclr)
    surface.DrawOutlinedRect(x, y, w, h)
end;
local math = math;
local appr = math.Approach;
local panelMeta = FindMetaTable('Panel')
local PLUGIN = PLUGIN;
function panelMeta:Adaptate(w, h, x, y)
    local sW, sH = ScrW(), ScrH()
    x = x or 0.1; y = y or 0.1
    w = w or 100; h = h or 100
    
    self:SetPos( sW * math.min(x, 1.25), sH * math.min(y, 1.25) ) 
    self:SetSize( sW * (w / 1920), sH * (h / 1080) )
end;
    
function panelMeta:DebugClose()
		local use = input.IsKeyDown( KEY_PAD_MINUS );

	if use && self.debugClose then
			self.debugClose = false;
    	surface.PlaySound("ui/buttonclick.wav");
    	self:Close();
  end;
end;

function panelMeta:InitHover(defaultColor, incrementTo, colorSpeed, borderColor)
		self.initedHover = true;
    self.dColor = !defaultColor && Color(60, 60, 60) || defaultColor
    self.IncTo = !incrementTo && Color(70, 70, 70) || incrementTo
    self.cSpeed = !colorSpeed && 7 * 100 || colorSpeed * 700;
    self.cCopy = self.dColor // color copy to decrement
    self.bColor = !borderColor && Color(90, 90, 90) || borderColor
end;

function panelMeta:HoverButton(w, h)
		if !CLIENT then return end;
		if !self.initedHover then return end;

		local incTo = self.IncTo; // Increment color to;
    local cCopy = self.cCopy;
    local dis = self.Disable
    local hov = self:IsHovered()
    if dis then
        surface.SetDrawColor(Color(cCopy.r, cCopy.g, cCopy.b, 100));
        surface.DrawRect(0, 0, w, h)
        return;
    end
    local red, green, blue = self.dColor.r, self.dColor.g, self.dColor.b
    self.dColor = {
        r = appr(red, hov && incTo.r || cCopy.r, FrameTime() * self.cSpeed),
        g = appr(green, hov && incTo.g || cCopy.g, FrameTime() * self.cSpeed),
        b = appr(blue, hov && incTo.b || cCopy.b, FrameTime() * self.cSpeed)
    }
    surface.SetDrawColor(self.dColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(40, 40, 40))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;
    
function panelMeta:Close()
	gui.EnableScreenClicker(false);
	self:AlphaTo(0, .2, 0, function() 
    self:SetVisible(false); self:Remove();
	end)
end;

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

function PLUGIN:LoadNutFonts(font, genericFont)	
	font = genericFont
	surface.CreateFont( "Generic Banking", {
		font = "Quicksand Light",
		size = ScreenScale( 9 ),
		outline = true,
	})
  surface.CreateFont( "Banking handly", {
		font = "Indie Flower",
		extended = false,
		size = ScreenScale( 8 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking handly big", {
		font = "Indie Flower",
		extended = false,
		size = ScreenScale( 11 ),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo little", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 6 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 6 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking typo big", {
		font = "Times New Roman",
		extended = false,
		size = ScreenScale( 12 ),
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking info", {
		font = "Courier New",
		extended = false,
		size = ScreenScale( 7 ),
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
	surface.CreateFont( "Banking info smaller", {
		font = "Consolas",
		extended = false,
		size = ScreenScale( 6 ),
		antialias = true,
	})
	surface.CreateFont( "Banking id", {
		font = "Consolas",
		extended = false,
		size = ScreenScale( 7 ),
		weight = 200,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})
end;

function PLUGIN:BankStorage(storage)
		-- Number of pixels between the local inventory and storage inventory.
		local PADDING = 4

		if !storage then return end

		-- Get the inventory for the player and storage.
		local localInv = LocalPlayer():getChar() and LocalPlayer():getChar():getInv()
		if (!localInv) then
			return
		end

		-- Show both the storage and inventory.
		local localInvPanel = nut.inventory.show(localInv)
		local storageInvPanel = nut.inventory.show(storage)
		storageInvPanel:SetTitle("Local storage")

		-- Allow the inventory panels to close.
		localInvPanel:ShowCloseButton(true)
		storageInvPanel:ShowCloseButton(true)

		-- Put the two panels, side by side, in the middle.
		local extraWidth = (storageInvPanel:GetWide() + PADDING) / 2
		localInvPanel:Center()
		storageInvPanel:Center()
		localInvPanel.x = localInvPanel.x + extraWidth
		storageInvPanel:MoveLeftOf(localInvPanel, PADDING)

		-- Signal that the user left the inventory if either closes.
		local firstToRemove = true
		localInvPanel.oldOnRemove = localInvPanel.OnRemove
		storageInvPanel.oldOnRemove = storageInvPanel.OnRemove

		local function exitStorageOnRemove(panel)
			if (firstToRemove) then
				firstToRemove = false
				nutStorageBase:exitStorage()
				local otherPanel =
					panel == localInvPanel and storageInvPanel or localInvPanel
				if (IsValid(otherPanel)) then otherPanel:Remove() end
			end
			panel:oldOnRemove()
		end

		hook.Run("OnCreateStoragePanel", localInvPanel, storageInvPanel, storage)

		localInvPanel.OnRemove = exitStorageOnRemove
		storageInvPanel.OnRemove = exitStorageOnRemove
	end
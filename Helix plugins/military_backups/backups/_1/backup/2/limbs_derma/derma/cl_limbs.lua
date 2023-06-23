local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
    self:MakePopup()
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl) 
		if IsValid(pnl) then
			pnl:SetAlpha(255) 
		end;
	end);

	self:Adaptate(sw, sh, 0, 0)
	self._list = {}
end

function PANEL:Populate()
	local defaultText, secondText = "> Кто может меня осмотреть <", "> Показать мои характеристики <"

	self.Body = self:Add("DPanel")
	self.Body:Adaptate(700, 700)
	self.Body.Paint = function(s, w, h)
		draw.OutlineRectangle(0, 0, w, h, Color(60, 60, 60), Color(100, 100, 100))
	end;

	self.left = self.Body:Add("DPanel")
	self.left:Dock(LEFT)
	self.left:Adaptate(350, 0)
	self.left.Paint = function(s, w, h)
		draw.BodyLimb( sw * 0, sh * 0.005, w, h * 0.95, 255 )
		draw.BodyData( sw * 0, sh * 0.005, w, h * 0.95 )
	end;

	self.canSee = self.Body:Add("DButton")
	self.canSee:Dock(BOTTOM)
	self.canSee:SetText("> Кто может меня осмотреть <")
	self.canSee:DockMargin(2, 0, 2, 5)
	self.canSee:SetFont("LIMB_EMPTY")
	self.canSee.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
	end;

	self.canSee.DoClick = function(btn)
		if btn.clicked && btn.clicked > CurTime() then return end;
		btn.clicked = CurTime() + 1.5;

		local inj, chList = self.injuries, self.charList;
		local iVisible, chVisible = inj:IsVisible(), chList:IsVisible();

		if !iVisible then inj:SetVisible(true) end;
		inj:AlphaTo(!iVisible && 255 || 0, .5, 0, function(data, pnl)
			if iVisible then inj:SetVisible(!iVisible) end;
		end)
		
		if !chVisible then chList:SetVisible(true) end;
		chList:AlphaTo(!chVisible && 255 || 0, .5, 0, function(data, pnl)
			if chVisible then chList:SetVisible(!chVisible) end;
		end)

		btn:SetText(!chVisible && secondText || defaultText)
	end;

	self.injuries = self.Body:Add("LScroll")
	self.injuries:Dock(FILL)
	self.injuries:DockMargin(2, 5, 2, 5)
	self.injuries.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
	end;

	self.charList = self.Body:Add("LimbCharList")
	self.charList:Dock(FILL)
	self.charList:SetVisible(false)
	self.charList:SetAlpha(0)
	self.charList:DockMargin(2, 5, 2, 5)

	self.bloodLevel = self.injuries:Add("BloodDrop")
	self.painLevel = self.injuries:Add("PainDraw")

	for i = 1, #LIMBS.LIST do
		local limb = LIMBS.LIST[i];

		self.list = self.injuries:Add("LimbList");
		self.list.data = limb;
		self.list:Populate()

		self.list:ReloadInjuries()

		self._list[limb] = self.list
	end;
end;

function PANEL:OnRemove()
	netstream.Start("LIMBS_DERMA_REMOVE")
	LIMBS_DATA = nil;

	CloseDermaMenus() 
end

function PANEL:Paint(w, h)
	self:DrawBlur()
end;

function PANEL:OnKeyCodePressed( key )
	if key == LIMBS.INT_KEY then
		if !IsValid(self) then return end;
		
		timer.Simple(.5, function()
			if input.IsKeyDown( LIMBS.INT_KEY ) then
				self:Close()
			end
		end)
	end
end;

vgui.Register( "Limbs", PANEL, "EditablePanel" )
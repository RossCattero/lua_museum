local PLUGIN = PLUGIN;
local PANEL = {}
local sw, sh = ScrW(), ScrH()

LIMB_ACCESS = "";

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(600, 215, 0.35, 0.30)
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl) self.CanCloseE = true; end);
end

function PANEL:Populate(closebtn, refData, access)
		if !access then
				LIMB_ACCESS = "admin"
		else
				LIMB_ACCESS = access;
		end

		self.HealthList = self:Add("ModScroll")
		self.HealthList:Dock(FILL)

		self:Refresh(refData);

		if closebtn then
    		self:Adaptate(600, 245, 0.35, 0.30)
				self.CloseBG = self:Add("Panel")
				self.CloseBG:Dock(TOP)
				self.CloseBG:DockMargin(0, 7, 7, 0)

				self.CloseButton = self.CloseBG:Add("MButt")
				self.CloseButton:Dock(RIGHT)
				self.CloseButton:SetWide(sw * 0.02)
				self.CloseButton:SetText("X")
				self.CloseButton.Paint = function(s, w, h)
					if s:IsHovered() then
							draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
					end;
				end;
				self.CloseButton.DoClick = function(btn)
						self:Close()
				end;
		end
end;

function PANEL:Paint( w, h )
		surface.SetDrawColor(Color(50, 50, 50, 100))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 99, 191))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;

function PANEL:Refresh(refData)
		local Limbs = LocalPlayer():GetLimbs()
		for k, v in pairs(refData or Limbs) do
				local health = self.HealthList:Add("HealthBar")
				health:SetLimb(k, v.amount);
		end
end;

vgui.Register( "HealthPanel", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:Init()
		self:Dock(TOP)
		self:SetTall(sh * 0.024)
		self:DockMargin(5, 5, 5, 0)
end

function PANEL:SetLimb(num, amount)
		self.limbName = num;

		self.amount = amount;

		local DEF = PLUGIN.DEFAULT_LIMBS[self.limbName]
		if !DEF then self:Remove() return; end;

		self.limbLabel = self:Add("ModLabel")
		self.limbLabel:SetFont("LimbsData")
    self.limbLabel:SetAutoStretchVertical(false)
		if LIMB_ACCESS != "user" then
			self.limbLabel:SetText(DEF.name:upper())
		else
			self.limbLabel:SetText("")
		end;
		self.limbLabel:Dock(FILL)
end;

function PANEL:Paint( w, h )
		local limb = LocalPlayer():GetLimbs()[self.limbName];
		if self.amount then
				limb = {
					name = self.limbName,
					amount = self.amount
				}
		end;
		if !limb then return end;
		local offsetH = h - (sh * 0.005)
		local DEF = DefaultLimb(self.limbName)
		local amount, maxAmount = limb.amount * (sw * 0.00304), DEF * (sw * 0.00304)
		local clr = Color(0, 99, 191, 200);
		if limb.name == 7 then
			clr = Color(116, 4, 4)
		end
		
		draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 100))

		if LIMB_ACCESS == "user" then 
			local str = PLUGIN.DEFAULT_LIMBS[self.limbName].name .. ": " .. GetLimbSituation(limb.amount)
			draw.SimpleText(str:upper(), "LimbsData", sw * 0.155, sh * 0.012, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return 
		end;
		draw.RoundedBox(0, sw * 0.002, sh * 0.003, math.Clamp(amount, 0, maxAmount), offsetH, clr)
end;

vgui.Register( "HealthBar", PANEL, "EditablePanel" )
// TAXI panel components:

local PANEL = {}

function PANEL:Init()
		self:Dock(RIGHT)
		self:SetWide(sw * 0.02)
		self:DockMargin(sw * 0.0, sh * 0.005, sw * 0.005, sh * 0.01)
		self:SetCursor("hand")

		self:SetMouseInputEnabled(true)

		self.closeLbl = self:Add("DLabel")
		self.closeLbl:Dock(FILL)
		self.closeLbl:SetText("X")
		self.closeLbl:SetContentAlignment(5)

		self:InitHover(Color(50, 50, 50, 255), Color(70, 70, 70, 255), 0.2, Color(0,0,0,0))
end

function PANEL:Paint( w, h ) 
		self:HoverButton(w, h)
end;

function PANEL:OnMousePressed()
		if TINT && TINT:IsValid() then
				TINT:Close()
		end
end

vgui.Register( "TaxiCloseButton", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:Init() end

function PANEL:SetIndex(i)
		self.index = i;
end;

function PANEL:Populate()
		if !self.index then self:Remove() return end;
		if !TAXI_DATA.jobs[self.index] then self:Remove() return end;

		local position = TAXI_DATA.jobs[self.index].position;
		position = math.Round(LocalPlayer():GetPos():Distance( position ) / 28);
		local price = TAXI_DATA.jobs[self.index].price;

		if TAXI_DATA.jobs[self.index].take then
				self.label = self:Add("DLabel")
				self.label:Dock(FILL)
				self.label:SetText("TAKEN")
				self.label:SetContentAlignment(5)
				self.label:SetFont("TaxiBtnsLower")
				return;
		end;

		self.label = self:Add("DLabel")
		self.label:Dock(TOP)
		self.label:SetText("Position: ")
		self.label:SetContentAlignment(5)

		self.pos = self:Add("DLabel")
		self.pos:Dock(TOP)
		self.pos:SetText(position .. " meters")
		self.pos:SetContentAlignment(5)

		self.label = self:Add("DLabel")
		self.label:Dock(TOP)
		self.label:SetText("Price: ")
		self.label:SetContentAlignment(5)

		self.price = self:Add("DLabel")
		self.price:Dock(TOP)
		self.price:SetText(nut.currency.get( price ))
		self.price:SetContentAlignment(5)

		self.acceptBtn = self:Add("DButton")
		self.acceptBtn:Dock(TOP)
		self.acceptBtn:SetText("Accept")
		self.acceptBtn:DockMargin(sw * 0.01, sh * 0.005, sw * 0.01, 0)
		self.acceptBtn:SetTextColor(Color(255, 255, 255))
		self.acceptBtn.Think = function(btn)
				btn:SetDisabled(LocalPlayer():TaxiTakenOrder() != "")
		end;

		self.acceptBtn.DoClick = function(btn)
				if LocalPlayer():TaxiTakenOrder() != "" then
						return;
				end
				if !TAXI_DATA.jobs[self.index].take then
						netstream.Start('taxi::TakeJob', self.index)
						TAXI_DATA.taken = TAXI_DATA.taken + 1;
						surface.PlaySound("buttons/button17.wav")
				end
		end;

		local children = self:GetChildren();
		local i = #children;
		while (i > 0) do
				if children[i].SetFont then
					children[i]:SetFont("TaxiBtnsLower")
				end;
				i = i - 1;
		end
end;

function PANEL:Paint( w, h )
		surface.SetDrawColor(Color(199, 85, 180, 150))
    surface.DrawRect(0, 0, w, h)
end;

vgui.Register( "TaxiJob", PANEL, "EditablePanel" )

local PANEL = {}

function PANEL:Init()
		self:Dock(TOP)
		self:SetCursor("hand")
		self:DockMargin(sw * 0.05, sh * 0.02, sw * 0.05, sh * 0.01)

		self:SetMouseInputEnabled(true)

		self.text = self:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetText("")
		self.text:SetFont("TaxiBtnsLower")
		self.text:SetContentAlignment(5)

		self:InitHover(Color(50, 50, 50, 255), Color(70, 70, 70, 255), 0.2, nil)
end

function PANEL:SetText(text)
		self.text:SetText(text)
end;

function PANEL:Paint( w, h ) 
		self:HoverButton(w, h)
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

vgui.Register( "TaxiUtilityButton", PANEL, "EditablePanel" )
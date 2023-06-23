local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true);

	self:Place(400, 600)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

	self.carInfo = self:Add("CarInfo")
	self.carInfo:Dock(FILL)

	self.exit = self:Add("BankingButton")
	self.exit:Dock(BOTTOM)
	self.exit:SetText("Exit")
	self.exit:DockMargin(5, 5, 5, 5)
	self.exit.DoClick = function(button)
		self:Close()
	end;

	local car = nut.car_vendor.Get( self.carInfo.currently );
	local canAfford = nut.car_vendor.CanAfford( car.uniqueID, LocalPlayer():getChar():getMoney() );

	self.buy = self:Add("BankingButton")
	self.buy:Dock(BOTTOM)
	self.buy:SetText("Buy")
	self.buy:DockMargin(5, 5, 5, 0)
	self.buy.DoClick = function(button)
		if canAfford then
			netstream.Start("nut.car_vendor.order", self.carInfo.currently)
		else
			nut.util.notify("You can't afford this car.")
		end;
	end;

	self.buy:SetEnabled( canAfford )

	self:DockPadding( 5, 5, 5, 5 )

	self.carInfo:Reload( self.carInfo.currently )
end

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

vgui.Register("CarVendor", PANEL, "EditablePanel")
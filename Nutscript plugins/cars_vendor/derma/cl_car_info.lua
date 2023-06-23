local PANEL = {}

function PANEL:Init()
	self.currently = 1;

	self.carInfo = self:Add("DModelPanel")
	self.carInfo:Dock(FILL)
	self.carInfo:SetModel( "" )
	self.carInfo.Angles = Angle(0, 0, 0)
	self.carInfo:SetCamPos(Vector(200, 50, 50))

	function self.carInfo:DragMousePress()
		self.PressX, self.PressY = gui.MousePos()
		self.Pressed = true
	end

	function self.carInfo:DragMouseRelease() 
		self.Pressed = false 
	end

	function self.carInfo:LayoutEntity( Entity )
		if ( self.Pressed ) then
			local mx, my = gui.MousePos()
			self.Angles = self.Angles - Angle( ( self.PressY or my ) - my, ( self.PressX or mx ) - mx, 0 )
			
			self.PressX, self.PressY = gui.MousePos()
		end

		Entity:SetAngles( self.Angles )
	end

	self.buttons = self:Add("Panel")
	self.buttons:Dock(BOTTOM)

	self.prev = self.buttons:Add("BankingButton")
	self.prev:SetText("<")
	self.prev:Dock(LEFT)
	self.prev.PerformLayout = function(s, w, h)
		self.prev:SetWide( s:GetParent():GetWide()/2 )
	end;
	self.prev.Paint = nil;
	self.prev.DoClick = function( btn )
		self.currently = self.currently - 1;
		if self.currently <= 0 then
			self.currently = #nut.car_vendor.ilist
		end;
		self:Reload( self.currently )
	end;

	self.next = self.buttons:Add("BankingButton")
	self.next:SetText(">")
	self.next:Dock(FILL)
	self.next.Paint = nil;
	self.next.DoClick = function( btn )
		self.currently = self.currently + 1;
		if self.currently > #nut.car_vendor.list then
			self.currently = 1;
		end;
		self:Reload( self.currently )
	end;

	self.data = self:Add("Panel")
	self.data:Dock(BOTTOM)
end

function PANEL:Reload( uniqueID )
	for k, v in pairs( self.data:GetChildren() ) do
		v:Remove()
	end;
	uniqueID = nut.car_vendor.ilist[ uniqueID ]

	local symCar = list.Get("simfphys_vehicles")
	if !symCar[ uniqueID ] then
		return;
	end;

	self.carInfo:SetModel( symCar[ uniqueID ].Model )
	
	local foundCar = nut.car_vendor.list[ uniqueID ]

	local name = self.data:Add("DLabel")
	name:Dock(TOP)
	name:SetFont("BankingButtons")
	name:SetText( foundCar.name )
	name:SetContentAlignment(5)
	name:SizeToContents()

	local price = self.data:Add("DLabel")
	price:Dock(TOP)
	price:SetFont("BankingButtons")
	price:SetText( "Price: " .. foundCar.price )
	price:SetContentAlignment(5)
	price:SizeToContents()

	local baggage = self.data:Add("DLabel")
	baggage:Dock(TOP)
	baggage:SetFont("BankingButtons")
	baggage:SetText( Format("Baggage: %sx%s", foundCar.baggageW, foundCar.baggageH) )
	baggage:SetContentAlignment(5)
	baggage:SizeToContents()

	self:GetParent().buy:SetEnabled( nut.car_vendor.CanAfford( uniqueID, LocalPlayer():getChar():getMoney() ) )

	self.data:InvalidateLayout( true )
	self.data:SizeToChildren( false, true )
end;

vgui.Register("CarInfo", PANEL, "EditablePanel")
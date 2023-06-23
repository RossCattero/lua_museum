local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:SetTall(500)

	self.list = self:Add("DScrollPanel")
	self.list:Dock(FILL)

	self.sector = self.list:Add("PropertyPanel")
	self.sector:Dock(TOP)
	self.sector:SetTitle("Choose sector:")
	self.sectorList = self.sector:Insert("DComboBox")
	self.sectorList.Paint = function( s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
	end;
	self.sectorList.OnSelect = function(combo)
		self:ChangeName()
		surface.PlaySound("buttons/button16.wav")
	end;
	for k, v in pairs(ix.doors.sector.list) do self.sectorList:AddChoice(v.name) end;

	self.category = self.list:Add("PropertyPanel")
	self.category:Dock(TOP)
	self.category:SetTitle("Choose category:")
	self.categoryList = self.category:Insert("DComboBox")
	self.categoryList.Paint = function( s, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
	end;
	self.categoryList.OnSelect = function(combo, index, value, data)
		self.price:SetText("Price " .. data .. ix.currency.symbol )
		surface.PlaySound("buttons/button16.wav")
	end;
	for k, v in pairs(ix.doors.category.list) do self.categoryList:AddChoice(v.name, v.price) end;

	self.blockLetter = self.list:Add("PropertyPanel")
	self.blockLetter:Dock(TOP)
	self.blockLetter:SetTitle("Type block letter:")
	self.blockLetterText = self.blockLetter:Insert("DTextEntry")
	self.blockLetterText:SetText("A")
	self.blockLetterText.AllowInput  = function( entry, text )
		return entry:GetText():len() >= 1;
	end;

	self.blockLetterText.OnChange = function( input )
		self:ChangeName()
	end

	self.blockNumber = self.list:Add("PropertyPanel")
	self.blockNumber:Dock(TOP)
	self.blockNumber:SetTitle("Choose block number:")
	self.blockNumberText = self.blockNumber:Insert("DNumSlider")
	self.blockNumberText:SetMinMax(1, 9999)
	self.blockNumberText:SetDecimals(0)
	self.blockNumberText:SetDefaultValue(1)
	self.blockNumberText:ResetToDefaultValue()
	self.blockNumberText.Label:SetVisible(false)
	self.blockNumberText.OnValueChanged = function( input )
		self:ChangeName()
	end

	self.price = self.list:Add("ixLabel")
	self.price:Dock(TOP)
	self.price:SetFont("PropertySolas")
	self.price:SetText("Price: 0" .. ix.currency.symbol)
	self.price:SetContentAlignment( 5 )
	self.price:SizeToContents()
	self.price:DockMargin(0, 10, 0, 10)

	self.result = self.list:Add("ixLabel")
	self.result:Dock(TOP)
	self.result:SetFont("PropertySolas")
	self.result:SetText("Result: " )
	self.result:SetContentAlignment( 5 )
	self.result:SizeToContents()
	self.result:DockMargin(0, 10, 0, 10)

	self:ChangeName()
	self.sectorList:ChooseOptionID( 1 )
	self:DockPadding(10,10,10,10)
end

function PANEL:MakeName( ... )
	local found = {...};
	local str = "RB:{1}-UNIT {2}{3}"
	
	for k, v in pairs(found) do
		str = str:gsub("{"..k.."}", v)
	end;

	return str
end;

function PANEL:ChangeName()
	self.result:SetText("Result: " .. self:GetDoorName() )
end;

function PANEL:GetDoorName()
	return self:MakeName( 
	self.sectorList:GetSelected() or "", 
	self.blockLetterText:GetText(), 
	math.Round(self.blockNumberText:GetValue()) )
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
end;

vgui.Register("PropertySystem", PANEL, "EditablePanel")
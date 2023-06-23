local PANEL = {}

function PANEL:Init()
	gui.EnableScreenClicker(true);

	self:Place(450, 500)

	self:SetFocusTopLevel( true )
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

	self:DockPadding( 10, 10, 10, 10 )
end

function PANEL:Populate( index, data )
	if data.name then
		self.name = self:Add("BankTextEntry")
		self.name:Dock(TOP)
		self.name:SetLabel("NPC name:")
		self.name.entry:SetText(data.name)
		self.name.entry:SetPlaceholderText("Write the name")
		self.name.entry.OnChange = function( self )
			data.name = self:GetValue()
		end;
	end;

	if data.model then
		self.model = self:Add("BankTextEntry")
		self.model:Dock(TOP)
		self.model:SetLabel("Model path:")
		self.model.entry:SetText(data.model)
		self.model.entry:SetPlaceholderText("Write the model path")
		self.model.entry.OnChange = function( self )
			data.model = self:GetValue()
		end;
	end;

	if data.sequence then
		self.sequence = self:Add("Panel")
		self.sequence:Dock(TOP)

		self.sequenceSlider = self.sequence:Add("DNumSlider")
		self.sequenceSlider:Dock(FILL)
		self.sequenceSlider.Label:SetFont("BankingButtons")
		self.sequenceSlider:SetText("Sequence")
		self.sequenceSlider.Label:SizeToContents()
		self.sequenceSlider:SetDecimals( 0 )
		self.sequenceSlider:SetMinMax(0, 256)
		self.sequenceSlider:SetDefaultValue( data.sequence )
		self.sequenceSlider:ResetToDefaultValue()
		self.sequenceSlider.OnValueChanged = function( self, value )
			data.sequence = value
		end;
	end;

	if data.factions then
		self.factionPanel = self:Add("FactionChecker")
		self.factionPanel:Dock(TOP)
		self.factionPanel:SetTall(300)
		self.factionPanel:SetLockedFactions( data.factions )
		self.factionPanel:ReloadLeft()
		self.factionPanel:ReloadRight()

		self.factionPanel.OnReload = function( pnl, factionList )
			data.factions = factionList;
		end;
	end;

	if data.time then
		self.time = self:Add("Panel")
		self.time:Dock(TOP)

		self.timeSlider = self.time:Add("DNumSlider")
		self.timeSlider:Dock(FILL)
		self.timeSlider.Label:SetFont("BankingButtons")
		self.timeSlider:SetText("Minutes per pay")
		self.timeSlider:SetDecimals( 0 )
		self.timeSlider:SetMinMax(5, 60)
		self.timeSlider:SetDefaultValue( data.time )
		self.timeSlider:ResetToDefaultValue()
		
		self.timeSlider.OnValueChanged = function( self, value )
			data.time = value
		end;
	end;

	self.save = self:Add("BankingButton")
	self.save:Dock(TOP)
	self.save:SetText("Save")
	self.save:DockMargin(0, 5, 0, 5)
	self.save.DoClick = function( btn )
		netstream.Start("nut.rossnpc.updateData", index, data)
		surface.PlaySound("buttons/button14.wav")
	end;

	self.exit = self:Add("BankingButton")
	self.exit:Dock(TOP)
	self.exit:SetText("Exit")
	self.exit:DockMargin(0, 5, 0, 5)
	self.exit.DoClick = function(btn)
		self:Close()
	end;

	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )
end;

function PANEL:Paint(w, h)
	draw.RoundedBox(8, 0, 0, w, h, Color(50, 50, 50, 250))
end;

function PANEL:OnRemove()
	for k, v in pairs(nut.menu.list) do
		table.remove(nut.menu.list, k)
	end
end;

vgui.Register("NPCSettings", PANEL, "EditablePanel")
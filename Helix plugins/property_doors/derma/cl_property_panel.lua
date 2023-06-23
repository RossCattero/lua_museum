local PANEL = {}

function PANEL:Init()
	self.label = self:Add("ixLabel")
	self.label:Dock(TOP)
	self.label:SetFont("PropertySolas")
	self.label:SetText("")
	self.label:SetContentAlignment( 5 )
	self.label:SizeToContents()
	self.label:DockMargin( 0, 10, 0, 10 )

	self.content = self:Add("Panel")
	self.content:Dock(TOP)
	self.content:SetTall(25)
end

function PANEL:SetTitle(text)
	self.label:SetText(tostring(text) or "")
	self.label:SizeToContents()
end;

function PANEL:Insert( class )
	local panel = self.content:Add( class );
	panel:Dock(FILL)
	self:InvalidateLayout( true )
	self:SizeToChildren( false, true )

	return panel;
end;

vgui.Register("PropertyPanel", PANEL, "EditablePanel")
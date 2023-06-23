local PANEL = {}

function PANEL:Init()
	self:SetTall( ScrH() * 0.025 )
	self.label = self:Add("DLabel")
	self.label:Dock(LEFT)
	self.label:SetFont("BankingButtons")
	self.label:SetText("")
	self.label:SetContentAlignment(5)
	self.label:DockMargin(10, 0, 10, 0)
	self.label:SizeToContents()

	self.entry = self:Add("DTextEntry")
	self.entry:Dock(FILL)
end

function PANEL:SetLabel(stringText)
	self.label:SetText(stringText)
	self.label:SizeToContents()
end;

vgui.Register("BankTextEntry", PANEL, "EditablePanel")
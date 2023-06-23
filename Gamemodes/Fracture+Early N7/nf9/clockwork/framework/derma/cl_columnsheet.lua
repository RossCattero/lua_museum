--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;
local Color = Color;
local derma = derma;
local vgui = vgui;

local ourMat = Material( "gui/gradient" )

local PANEL = {};

-- A function to add a new sheet.
function PANEL:AddSheet(label, panel, material)
	if (!IsValid(panel)) then
		return;
	end;
	
	local newSheet = {};
	
	if (self.ButtonOnly) then
		newSheet.Button = vgui.Create("DImageButton", self.Navigation);
		newSheet.Button:Dock(TOP);
		newSheet.Button:DockMargin(0, 1, 0, 0);
	else
		newSheet.Button = vgui.Create("cwIconButton", self.Navigation);
		
		local size = Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_tiny"), 20);
	
		newSheet.Button:SetTall(32);
		newSheet.Button:Dock(TOP);
		newSheet.Button:DockMargin(0, 0, 0, 8);
		newSheet.Button:SetFont(size);
		
		function newSheet.Button:Paint(w, h)
			surface.SetDrawColor( self.ColorToShow.red, self.ColorToShow.green, self.ColorToShow.blue, self.ColorToShow.alpha )
			surface.SetMaterial( ourMat	)
			surface.DrawTexturedRect( 0, 0, w, h )

			draw.RoundedBox( 0, 0, 0, 5, h, self.ColorToShow["BorderColor"] )
		end;
	end;
	
	newSheet.Button:SetImage(material);
	newSheet.Button.Target = panel;
	newSheet.Button:SetText(label);
	newSheet.Button.DoClick = function()
		self:SetActiveButton(newSheet.Button)
	end;
	
	newSheet.Panel = panel;
	newSheet.Panel:SetParent(self.Content);
	newSheet.Panel:SetVisible(false);
	newSheet.Button.ColorToShow = {
		red = 0,
		green = 0,
		blue = 0,
		alpha = 200,
		BorderColor = Color(100, 100, 100, 255);
	}
	
	if (self.ButtonOnly) then
		newSheet.Button:SizeToContents();
	end;
	
	newSheet.Button:SetColor(Clockwork.option:GetColor("columnsheet_text_normal"));
	newSheet.Button:SetExpensiveShadow(1, Clockwork.option:GetColor("columnsheet_shadow_normal"));
	
	table.insert(self.Items, newSheet)
	
	if (!IsValid(self.ActiveButton)) then
		self:SetActiveButton(newSheet.Button);
	end;
end;

-- A function to set the active button.
function PANEL:SetActiveButton(active)
	if (self.ActiveButton == active) then
		return;
	end;

	if (self.ActiveButton && self.ActiveButton.Target) then	
		self.ActiveButton.Target:SetVisible(false)
		self.ActiveButton:SetSelected(false)
		
		self.ActiveButton.ColorToShow.red = 0;
		self.ActiveButton.ColorToShow.green = 0;
		self.ActiveButton.ColorToShow.blue = 0;
		self.ActiveButton.ColorToShow["BorderColor"] = Color(100, 100, 100)
	end
	
	if (self.ActiveButton && self.ActiveButton.Target) then	
		self.ActiveButton.Target:SetVisible(false)
		self.ActiveButton:SetSelected(false)
		self.ActiveButton:SetColor(Clockwork.option:GetColor("columnsheet_text_normal"));
		self.ActiveButton:SetExpensiveShadow(1, Clockwork.option:GetColor("columnsheet_shadow_normal"));
	end

	self.ActiveButton = active;
	
	active.Target:SetVisible(true);
	active:SetSelected(true);
	active:SetColor(Clockwork.option:GetColor("columnsheet_text_active"));
	active:SetExpensiveShadow(1, Clockwork.option:GetColor("columnsheet_shadow_active"));

	self.ActiveButton.ColorToShow.red = 255;
	self.ActiveButton.ColorToShow.green = 58;
	self.ActiveButton.ColorToShow.blue = 0;
	self.ActiveButton.ColorToShow["BorderColor"] = Color(255, 58, 0, 255);
	
	self.Content:InvalidateLayout();
end
	
vgui.Register("cwColumnSheet", PANEL, "DColumnSheet");
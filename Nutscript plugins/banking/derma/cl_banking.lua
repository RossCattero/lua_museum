local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Populate()
	self.bankingData = self.body:Add("BankingData__Account")
	self.bankingData:Dock(TOP)
	self.bankingData:SetTitle("ACCOUNT DETAILS #" .. LocalPlayer():getChar():getID())
	self.bankingData:SetTall(sh * 0.14)
	self.bankingData:Populate()

	self.buttonsWrapper = self.body:Add("DScrollPanel")
	self.buttonsWrapper:Dock(FILL)
	self.buttonsWrapper:DockMargin(0, 10, 0, 10)
	local ConVas, ScrollBar = self.buttonsWrapper:GetCanvas(), self.buttonsWrapper:GetVBar()
    ScrollBar:SetWidth(1)
	ScrollBar:SetHideButtons( true )
	function ScrollBar.btnGrip:Paint(w, h) 
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255)) 
	end

	self:Refresh()
end;

function PANEL:Refresh()
	self.buttonsWrapper:Clear();
	self.bankingData:Populate()

	for intButtonID, tableButtons in pairs(nut.banking.option.list) do
		local button = self.buttonsWrapper:Add("BankingButton")
		button.index = intButtonID;
		button:Dock(TOP)
		button:SetTall(sh * 0.04)
		button:SetText(tableButtons.name)
		button:SetIcon(tableButtons.icon)
		button:DockMargin(0, 0, 0, 5)
		button.clr = tableButtons.clr;
		button.DoClick = function(self)
			if tableButtons.Callback && (!tableButtons.CanRun || tableButtons.CanRun()) then
				tableButtons.Callback(self)
				
				if !tableButtons.isExit && nut.banking.derma && nut.banking.derma:IsValid() then
					nut.banking.derma:Refresh()
				end
			end;
		end;
		if tableButtons.CanRun && !tableButtons.CanRun() then
			button:SetEnabled(false)
		end
	end;
end;

vgui.Register("Banking", PANEL, "BankingBaseUI")
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}
function PANEL:Init()
		self:Adaptate(500, 800)
end;

function PANEL:Populate()
		self.Content = self:Add("DPanel")
		self.Content:Dock(FILL)
		self.Content:DockMargin(sw * 0.015, sh * 0.025, sw * 0.017, sh * 0.028)
		self.Content.Paint = nil;

		self.Header = self.Content:Add("DLabel")
		self.Header:SetFont("Typewriter")
		self.Header:Dock(TOP)
		self.Header:SetText("Bank account creation")
		self.Header:SetContentAlignment(5)
		self.Header:SizeToContents()
		self.Header:SetTextColor(Color(0, 0, 0))

		local lbl = self.Content:Add("DLabel")
		lbl:SetFont("Typewriter-small")
		lbl:SetText("Create the banking account for:")
		lbl:Dock(TOP)
		lbl:SetContentAlignment(5)
		lbl:SizeToContents()
		lbl:SetTextColor(Color(0, 0, 0))
		lbl:DockMargin(0, sh * 0.2, 0, 0)

		self.charList = self.Content:Add("DComboBox")
		self.charList:SetFont("Typewriter-small")
		self.charList:Dock(TOP)
		self.charList:SetValue("(Choose a character you recognize)")
		self.charList:SetContentAlignment(5);
		self.charList:DockMargin(0, sh * 0.02, 0, 0)
		self.charList.Paint = function(s, w, h)
				surface.SetDrawColor(0, 0, 0)
				surface.DrawLine(0, h - 0.001, w, h - 0.001)
		end;

		local players = player.GetAll();
		local i = #players;
		while (i > 0) do
				local user = players[i]
				
				if user && user:getChar() && user != LocalPlayer() && LocalPlayer():getChar():doesRecognize(user:getChar()) then 
						self.charList:AddChoice(user:GetName(), user:getChar():getID())
				end
				i = i - 1;
		end;

		self.charList.OnSelect = function(s, index, text, data)
				self.apply:SetEnabled(true);
				surface.PlaySound(PLUGIN.TypeWriter)
		end

		local lbl = self.Content:Add("DLabel")
		lbl:SetFont("Typewriter-small")
		lbl:SetText("With status:")
		lbl:Dock(TOP)
		lbl:SetContentAlignment(5)
		lbl:SizeToContents()
		lbl:SetTextColor(Color(0, 0, 0))
		lbl:DockMargin(0, sh * 0.03, 0, 0)

		self.statuses = self.Content:Add("DComboBox")
		self.statuses:SetFont("Typewriter-small")
		self.statuses:Dock(TOP)
		self.statuses:SetValue("(Choose a status)")
		self.statuses:SetContentAlignment(5);
		self.statuses:DockMargin(0, sh * 0.02, 0, 0)
		self.statuses.Paint = function(s, w, h)
				surface.SetDrawColor(0, 0, 0)
				surface.DrawLine(0, h - 0.001, w, h - 0.001)
		end;

		local i = #PLUGIN.bankingStatuses;
		while (i > 0) do
				self.statuses:AddChoice( PLUGIN.bankingStatuses[i], i )
				i = i - 1;
		end;

		function self.statuses:OnSelect( index, text, data )
				surface.PlaySound(PLUGIN.TypeWriter)
		end

		local lbl = self.Content:Add("DLabel")
		lbl:SetFont("Typewriter-small")
		lbl:SetText("Created by:")
		lbl:Dock(TOP)
		lbl:SetContentAlignment(5)
		lbl:SizeToContents()
		lbl:SetTextColor(Color(0, 0, 0))
		lbl:DockMargin(0, sh * 0.02, 0, 0)

		self.name = self.Content:Add("DLabel")
		self.name:SetFont("Typewriter-small")
		self.name:SetText(LocalPlayer():GetName())
		self.name:Dock(TOP)
		self.name:SetContentAlignment(5)
		self.name:SizeToContents()
		self.name:SetTextColor(Color(0, 0, 0))
		self.name:DockMargin(0, sh * 0.02, 0, 0)

		local close = self.Content:Add("DButton")
		close:Dock(BOTTOM)
		close:SetFont("Gbanking")
		close:SetText("Close")
		close:SizeToContents()

		close.DoClick = function(btn)
				if INT_TW && INT_TW:IsValid() then
						sound.Play( PLUGIN.PaperRip, LocalPlayer():GetPos(), 50 )
						INT_TW:Close()
				end;
		end;

		self.apply = self.Content:Add("DButton")
		self.apply:Dock(BOTTOM)
		self.apply:SetFont("Gbanking")
		self.apply:SetText("Apply")
		self.apply:SizeToContents()

		self.apply.DoClick = function(btn)
				if INT_TW && INT_TW:IsValid() then
						sound.Play( PLUGIN.PaperRip, LocalPlayer():GetPos(), 50 )
						local id, data = self.charList:GetSelected();
						local id, status = self.statuses:GetSelected();
						netstream.Start('Banking::BankingAction', "createAcc", {id = data, status = status})
						INT_TW:Close()
				end;
		end;
		self.apply:SetEnabled(false);

		self.apply.Paint = nil;
		close.Paint = nil;
end;

function PANEL:Paint( w, h )
		if CLOSEDEBUG then self:DebugClose() end;
		self:DrawBlur()

		surface.SetMaterial( PLUGIN.BankPage )
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect( 0, 0, w, h )
end;
vgui.Register( 'TypeWriter', PANEL, 'SPanel' )

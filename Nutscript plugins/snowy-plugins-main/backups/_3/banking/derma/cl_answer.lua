local PLUGIN = PLUGIN;

local PANEL = {}

function PANEL:Init()
  self:SetContentAlignment(5)
	self:Dock(TOP)
	self:DockMargin(10, 0, 10, 0)
	self:SetCursor("hand")
	self:SetMouseInputEnabled( true )
end

function PANEL:SetData(index, data)
    self.data = data;
		self.index = index;

    self:Populate()
end;

function PANEL:Paint(w, h)
		if self:IsHovered() then
			if !self.soundPlayed then
				surface.PlaySound("helix/ui/rollover.wav")
				self:ColorTo(Color(255, 185, 138), .2, 0, function() self:SetColor(Color(255, 185, 138)) end);
				self.soundPlayed = true;
			end;
		elseif !self:IsHovered() then
			self:SetColor(color_white)
			self.soundPlayed = false;
		end
end;

function PANEL:Populate()
    if !self.data then return end;
    local data = self.data;
		
		self:SetText(data.text)
end;

function PANEL:DoClick()
		local data = self.data;
		local interface = PLUGIN.interface
		if !interface || data.close then interface:Close() return end;
		index = self.index;

		buff = interface:Reinform(data)

		if data.EntryCreate then
				interface.answers:Clear();
				interface.numEntry = interface.answers:Add("ModEntry")
    		interface.numEntry:DockMargin(200, 5, 200, 5)

				interface.numEntry_btn = interface.answers:Add("ModLabel")
				interface.numEntry_btn:SetContentAlignment(5)
				interface.numEntry_btn:SetText("Enter")
				interface.numEntry_btn:Dock(TOP)
				interface.numEntry_btn:DockMargin(10, 0, 10, 0)
				interface.numEntry_btn:SetCursor("hand")
				interface.numEntry_btn:SetMouseInputEnabled( true )

				interface.numEntry_btn.DoClick = function(btn)
						
						if data.Execute && LocalPlayer():ValidateNPC("banking_npc") then
								netstream.Start('bankeer::exec', index, interface.numEntry:GetText())
						end

						timer.Simple(0, function()
							buff = interface:Reinform(data, true)
							interface:Remake(buff)
						end);
				end;
				return;
		end

		if data.Execute && LocalPlayer():ValidateNPC("banking_npc") then
				netstream.Start('bankeer::exec', index)
		end
			
		timer.Simple(0, function()
				buff = interface:Reinform(data)
				interface:Remake(buff)
		end)
end;

vgui.Register( "Answer", PANEL, "ModLabel" )
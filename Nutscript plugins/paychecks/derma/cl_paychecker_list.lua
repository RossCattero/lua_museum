local PANEL = {}

function PANEL:Init()
	self.left = self:Add("DScrollPanel")
	self.left:Dock(LEFT)
	self.left.PerformLayout = function(s, w, h)
		s:SetWide( s:GetParent():GetWide()/2 )
	end;

	self.right = self:Add("DScrollPanel")
	self.right:Dock(FILL)
end

function PANEL:SetLockedFactions( tableData )
	self.lockedFactions = tableData;	
end;

function PANEL:ReloadRight()
	self.right:Clear();
	
	for k, v in pairs( self.lockedFactions ) do
		local faction = nut.faction.indices[k]
		if faction then
			local facRight = self.right:Add("BankingButton")
			facRight:Dock(TOP)
			facRight:SetText(faction.name)
			facRight:DockMargin(5, 5, 5, 5)

			facRight.DoClick = function(button)
				button:Remove();

				self.lockedFactions[k] = nil;
				self:ReloadLeft()

				if self.OnReload then
					self.OnReload(self, self.lockedFactions)
				end;
			end;
		end;
	end;
end;

function PANEL:ReloadLeft()
	self.left:Clear();
	for k, v in pairs( nut.faction.indices ) do
		if !self.lockedFactions[k] then
			local facLeft = self.left:Add("BankingButton")
			facLeft:Dock(TOP)
			facLeft:SetText(v.name)
			facLeft:DockMargin(5, 5, 5, 5)

			facLeft.DoClick = function(button)
				button:Remove();

				self.lockedFactions[k] = true;
				self:ReloadRight()

				if self.OnReload then
					self.OnReload(self, self.lockedFactions)
				end;
			end;
		end;
	end;
end;

vgui.Register("FactionChecker", PANEL, "EditablePanel")
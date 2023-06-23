local PLUGIN = PLUGIN;

function PLUGIN:DrawCharInfo(client, character, info)
	local data = nut.loyalty.instances[ character:getID() ]
	
	if data && data:GetTier() then
		local tier = data:GetTier();
		
		if tier then
			info[#info + 1] = { "Tier " .. tier.title .. " Party Member.", tier.color }	
		end;
	end;
end

function PLUGIN:OnCharInfoSetup( panel )
	local data = nut.loyalty.instances[ LocalPlayer():getChar():getID() ]
	if data && data:GetTier() then
		local tier = data:GetTier();
		
		self.tier = panel.info:Add("DLabel")
		self.tier:Dock(TOP)
		self.tier:SetFont("nutMediumFont")
		self.tier:SetText("Tier " .. tier.title .. " Party Member.")
		self.tier:SetTextColor(tier.color)
		self.tier:SetExpensiveShadow(1, Color(0, 0, 0, 150))
		self.tier:SizeToContents()
	end;
end;
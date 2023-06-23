local PLUGIN = PLUGIN;

local buttonList = {
		{
			index = "remacc",
			name = "Remove the account",
			click = function(btn, data)
					Derma_Query("This account will be removed forever!", "Are you sure?", 
					"Ja", 
					function()
							sound.Play( PaperRip, LocalPlayer():GetPos(), 50 )
							netstream.Start('Banking::BankingAction', "deleteAcc", {id = data})							
					end,
					"Nein", function()	end)
			end,
			color = Color(200, 100, 100),
		},
		{
			index = "loanset",
			name = "Set loan amount",
			click = function(btn, data)
				local info = BankingAccounts[data];
				Derma_StringRequest("Achtung!", "Set the loan for character (0 means removing the loan):", info && info.loan or "0",
				function(text) 
						netstream.Start('Banking::BankingAction', "setLoan", {id = data, loan = text})	
						sound.Play( PenWrite, LocalPlayer():GetPos(), 50 )						
				end, nil, "Set the loan", "Exit")
			end,
		},
		{
			index = "statusset",
			name = "Change status",
			click = function(btn, data)
				local buffer = {}
				local i = #PLUGIN.bankingStatuses;
				while (i > 0) do
						local status = PLUGIN.bankingStatuses[i];
						if status then
							local id = #buffer + 1
							buffer[id] = status
							buffer[id + 1] = function()
									netstream.Start('Banking::BankingAction', "changeStatus", {id = data, status = status})	
									sound.Play( PenWrite, LocalPlayer():GetPos(), 50 )
							end;
						end;
						i = i - 1;
				end;
				Derma_Query("Choose the account type", "Account type", unpack(buffer))
			end,
		},
		{
			index = "itemsLook",
			name = "Look at bank inventory",
			click = function(btn, data)
					netstream.Start('Banking::BankingAction', "itemsLook", {id = data})	
			end,
		},
}

local sw, sh = ScrW(), ScrH();
local PANEL = {}

function PANEL:Init()
		self:Adaptate(1024, 800)
		self.sides = {};

		PAGE = 1;
end;

function PANEL:Populate()
		local i = 1;
		while (i <= 2) do
				local side = self:Add("BookSide")
				side:Populate(i)
				self.sides[i] = side;
				i = i + 1;
		end
		
		self:ReloadItems()
end;

function PANEL:ReloadItems()	
		if #HASH_MASSIVE <= 0 then 
			self:ButtonsCheck();
			self:ClearDatas()
			return 
		end;

		local max = PAGE + 1;
		local i = PAGE;
		local s = 1;
		while (i <= max) do
			local side = self.sides[s]
			side.info:Clear();
			side.number:SetText(i)
			side.number:SizeToContents()

			local id = HASH_MASSIVE[i];
			local account = BankingAccounts[id] 
			if account then
					if side.actions && side.actions:IsValid() then
							side.actions:SetVisible(true);
					end
					local j = 1;
					while (j <= #PLUGIN.enums) do
							local info = PLUGIN.enums[j]
							if info then
									side.data = HASH_MASSIVE[i]

									local value = info.tomoney && account[info.id] .. " " .. BANKING_REICHMARK || account[info.id];

									local lbl = side.info:Add("DLabel")
									lbl:Dock(TOP)
									lbl:SetText(info.name .. ": " .. value .. (info.percents && "%" || ""))
									lbl:SetFont("Typewriter-small")
									lbl:SizeToContents()
									lbl:SetTextColor(Color(0,0,0))
									lbl:DockMargin( sw * 0.01, j <= 1 && sh * 0.01 || 0, 0, 0 )										
							end;

							j = j + 1;
					end;

						s = s + 1;
				else
						if side.actions && side.actions:IsValid() then
								side.actions:SetVisible(false);
						end
				end
				i = i + 1;
		end;

		self:ButtonsCheck();
		surface.PlaySound(BookFlip)
end;

function PANEL:ButtonsCheck()
		if !HASH_MASSIVE[PAGE - 2] && !HASH_MASSIVE[PAGE - 3] then
				self.sides[1].button:SetEnabled(false)
		else
				self.sides[1].button:SetEnabled(true)
		end;
		if !HASH_MASSIVE[PAGE + 2] && !HASH_MASSIVE[PAGE + 3] then
				self.sides[2].button:SetEnabled(false)
		else
				self.sides[2].button:SetEnabled(true)
		end;
end;

function PANEL:ClearDatas()
		self.sides[1].actions:SetVisible(false);
		self.sides[1].info:Clear();

		self.sides[2].actions:SetVisible(false);
		self.sides[2].info:Clear();
end;

function PANEL:Paint( w, h )
		self:DrawBlur()

		surface.SetMaterial( BankBook )
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect( 0, 0, w, h )
end;

vgui.Register( 'BankingBook', PANEL, 'SPanel' )

local PANEL = {}
function PANEL:Init() end;
function PANEL:Populate(i)
	self:Dock(i == 1 && LEFT || RIGHT)
	self:SetWide(i == 1 && sw * 0.245 || sw * 0.255)
	self:DockMargin( 
		i == 1 && sw * 0.0135 || 0, 
		sh * 0.025, 
		i == 1 && 0 || sw * 0.012,
		i == 1 && sh * 0.025 || sh * 0.024
	)

	self.info = self:Add("DScrollPanel")
	self.info:Dock(FILL)

	self.footer = self:Add("DPanel")
	self.footer:Dock(BOTTOM)
	self.footer:SetTall(sh * 0.03)

	self.number = self.footer:Add("DLabel")
	self.number:SetFont("Gbanking")
	self.number:Dock(i == 1 && LEFT || RIGHT)
	self.number:SetText(i)
	self.number:SizeToContents();
	self.number:SetTextColor( Color(0, 0, 0) )
	self.number:DockMargin(
		i == 1 && sw * 0.01 || 0, 
		0, 
		i == 1 && 0 || sw * 0.01, 
		0 
	)

	self.button = self.footer:Add("DButton")
	self.button:Dock(i == 1 && RIGHT || LEFT)
	self.button:SetFont("Gbanking")
	self.button:SetText(i == 1 && "Previous" || "Next")
	self.button:SizeToContents()
	self.button.index = i;
	self.button:DockMargin(
		i == 1 && 0 || sw * 0.015,
		0,
		i == 1 && sw * 0.015 || 0,
		0
	)

	self.button.DoClick = function(btn)
			if INT_BOOK && INT_BOOK:IsValid() then
					PAGE = PAGE + (btn.index == 2 && 2 || -2);
					INT_BOOK:ReloadItems()
			end;
	end;

	if i == 1 then
			self.close = self.footer:Add("DButton")
			self.close:Dock(FILL)
			self.close:SetFont("Gbanking")
			self.close:SetText("Close book")
			self.close:SizeToContents()
			self.close.Paint = nil;
			self.close.DoClick = function(btn)
					if INT_BOOK && INT_BOOK:IsValid() then
						INT_BOOK:Close()
					end;
			end;
	else
			self.funds = self.footer:Add("DLabel")
			self.funds:Dock(FILL)
			self.funds:SetFont("Gbanking")
			self.funds:SetText("Funds: " .. PLUGIN.moneyFunds .. " " .. BANKING_REICHMARK);
			self.funds:SizeToContents()
			self.funds:SetTextColor( Color(0, 0, 0) )
			self.funds:SetContentAlignment( 5 )
	end;

	self.actions = self:Add("DScrollPanel")
	self.actions:Dock(BOTTOM)
	self.actions:SetTall(sh * 0.15)

	self.actions.label = self.actions:Add("DLabel")
	self.actions.label:Dock(TOP)
	self.actions.label:SetFont("Gbanking")
	self.actions.label:SetText("Actions:")
	self.actions.label:SizeToContents()
	self.actions.label:SetTextColor( Color(0, 0, 0) )
	self.actions.label:SetContentAlignment( 5 )

	local i = #buttonList;
	while (i > 0) do
			local but = buttonList[i]
			local button = self.actions:Add("DButton")
			button:Dock(TOP)
			button:SetFont("Gbanking")
			button:SetText(but.name)
			button:SetContentAlignment( 5 )
			button.defClr = but.color || Color(0, 0, 0)
			button:SetTextColor(button.defClr)
			button:SetAutoStretchVertical(true)

			button.index = i;
			button.DoClick = function(btn)
				buttonList[btn.index].click(btn, self.data)
			end;
			button.Paint = function(s, w, h)
					if s:IsHovered() then
							s:SetTextColor(Color(255, 255, 255))
					else
							s:SetTextColor(s.defClr)
					end
			end;
			i = i - 1;
	end;

	self.actions:SetVisible(false)
	
	-- self.actions.Paint = nil;
	self.footer.Paint = nil;
	self.button.Paint = nil
	self.info.Paint = nil

end;
function PANEL:Paint( w, h ) end;
vgui.Register( 'BookSide', PANEL, 'EditablePanel' )
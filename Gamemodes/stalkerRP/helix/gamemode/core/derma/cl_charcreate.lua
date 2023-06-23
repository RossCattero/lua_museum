
local padding = ScreenScale(32)

local panelmat = Material('materials/textures/menu_hud_attributes.png')
local littlemat = Material('materials/textures/menu_hud_back.png')

-- create character panel
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}

function PANEL:Init()
	local sw, sh = ScrW(), ScrH()
	local parent = self:GetParent()
	local modelFOV = (sw > sh * 1.8) and 100 or 78
	self:ResetPayload(true)
	self.repopulatePanels = {} self.factionButtons = {}

	self.factionPanel = self:Add("Panel")
	self.factionPanel:SetPos(sw * 0.01, sh * 0.01)
	self.factionPanel:SetSize(sw * 0.25, sh * 0.9)
	self.factionPanel.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( panelmat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;
	self.scrollPanelFacs = self.factionPanel:Add( "DScrollPanel" )
	self.scrollPanelFacs:Dock( FILL );
	
	self.modelInfo = self:Add("ixModelPanel")
	self.modelInfo:SetPos(sw * 0.27, sh * 0.01)
	self.modelInfo:SetSize(sw * 0.25, sh * 0.9)
	self.modelInfo:SetModel("")
	self.modelInfo:SetFOV(modelFOV - 13)
	self.modelInfo.PaintModel = self.modelInfo.Paint
	
	self.charInfoPanel = self:Add("Panel")
	self.charInfoPanel:SetPos(sw * 0.53, sh * 0.01)
	self.charInfoPanel:SetSize(sw * 0.25, sh * 0.9)
	self.charInfoPanel.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( panelmat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;

	self.attributesPanel = self:Add("Panel")
	self.attributesPanel:SetPos(sw * 0.79, sh * 0.01)
	self.attributesPanel:SetSize(sw * 0.2, sh * 0.9)
	self.attributesPanel.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( panelmat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;

	self.backButton = self:Add("ixMenuButton")
	self.backButton:SetText("Назад")
	self.backButton:SetPos(sw * 0.01, sh * 0.92)
	self.backButton:SetSize(sw * 0.25, 75)
	self.backButton.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( littlemat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;
	self.backButton.DoClick = function()
		self:SetActiveSubpanel("faction", 0)
		self:SlideDown()
		parent.mainPanel:Undim()
	end;
	self.createButton = self:Add("ixMenuButton")
	self.createButton:SetText("Создать")
	self.createButton:SetPos(sw * 0.79, sh * 0.92)
	self.createButton:SetSize(sw * 0.2, 75)
	self.createButton.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( littlemat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;
	self.createButton.DoClick = function()
		self:SendPayload()
	end;
	self:AddPayloadHook("model", function(value)
		local faction = ix.faction.indices[self.payload.faction]

		if (faction) then
			local model = faction:GetModels(LocalPlayer())[value]

			-- assuming bodygroups
			if (istable(model)) then
				self.modelInfo:SetModel(model[1], model[2] or 0, model[3])
			else
				self.modelInfo:SetModel(model)
			end
		end
	end)
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		self:SlideDown()

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()
			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			self:SlideDown()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		self:SlideDown()

		parent.mainPanel:Undim()
		parent:ShowNotice(3, L(fault, unpack(args)))
	end)
end

function PANEL:Populate()
	if !self.bInitialPopulate then

	self.factionButtons = {}
	for k, v in SortedPairs(ix.faction.teams) do
		if (ix.faction.HasWhitelist(v.index)) then
			local faction = self.scrollPanelFacs:Add("ixMenuSelectionButton")
			faction:SetBackgroundColor(v.color or color_white)
			faction:SetText(L(v.name):upper())
			faction:SetButtonList(self.factionButtons)
			faction:SizeToContents()
			faction:Dock(TOP)
			faction.faction = v.index
			faction.OnSelected = function(panel)
				local faction = ix.faction.indices[panel.faction]
				local models = faction:GetModels(LocalPlayer())

				self.payload:Set("faction", panel.faction)
				self.payload:Set("model", math.random(1, #models))				
			end
			faction.Paint = function(s, w, h)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( littlemat )
				surface.DrawTexturedRect( 0, 0, w, h )
			end;
		end;
	end;

	end;

	for i = 1, #self.repopulatePanels do
		self.repopulatePanels[i]:Remove()
	end
	self.repopulatePanels = {}

	local sel_cted = false;
	if (!self.payload.faction) then
		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				sel_cted = true;
				v:SetSelected(true)
				break
			end
		end
	end
	if !sel_cted then
		self.factionButtons[1]:SetSelected(true)
	end;

	local zPos = 1;
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (!v.bNoDisplay and k != "__SortedIndex") then
			local container = self.charInfoPanel

			if v.field == 'attributes' then
				container = self.attributesPanel
			end;

			if (v.ShouldDisplay and v:ShouldDisplay(container, self.payload) == false) then
				continue
			end

			local panel

			if (v.OnDisplay) then
				panel = v:OnDisplay(container, self.payload)
			elseif (isstring(v.default)) then
				panel = container:Add("ixTextEntry")
				panel:Dock(TOP)
				panel:DockMargin( 15, 15, 15, 15 )
				panel:SetFont("ixMenuButtonHugeFont")
				panel:SetUpdateOnType(true)
				panel.OnValueChange = function(this, text)
					self.payload:Set(k, text)
				end
			end

			if v.field == "model" then
				panel:DockMargin( 15, 15, 15, 15 )
				panel.Paint = function(s, w, h) end;
			end;
			if v.field == 'attributes' then
				panel:DockMargin( 15, 15, 15, 15 )
			end;

			if (IsValid(panel)) then
				-- add label for entry
				local label = container:Add("DLabel")
				label:SetFont("ixMenuButtonLabelFont")
				label:SetText(L(k):upper())
				label:SizeToContents()
				label:DockMargin(15, 16, 0, 2)
				label:Dock(TOP)

				self:AttachCleanup(label)
				self:AttachCleanup(panel)

				-- we need to set the docking order so the label is above the panel
				label:SetZPos(zPos - 1)
				panel:SetZPos(zPos)

				if (v.OnPostSetup) then
					v:OnPostSetup(panel, self.payload)
				end

				zPos = zPos + 2
			end
		end
	end
	self.bInitialPopulate = true
end;

function PANEL:SendPayload()
	if (self.awaitingResponse) then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			local parent = self:GetParent()

			self.awaitingResponse = false
			self:SlideDown()

			parent.mainPanel:Undim()
			parent:ShowNotice(3, L("unknownError"))
		end
	end)

	self.payload:Prepare()

	net.Start("ixCharacterCreate")
		net.WriteTable(self.payload)
	net.SendToServer()
end
function PANEL:ResetPayload(bWithHooks)
	if (bWithHooks) then
		self.hooks = {}
	end

	self.payload = {}

	-- TODO: eh..
	function self.payload.Set(payload, key, value)
		self:SetPayload(key, value)
	end

	function self.payload.AddHook(payload, key, callback)
		self:AddPayloadHook(key, callback)
	end

	function self.payload.Prepare(payload)
		self.payload.Set = nil
		self.payload.AddHook = nil
		self.payload.Prepare = nil
	end
end
function PANEL:SetPayload(key, value)
	self.payload[key] = value
	self:RunPayloadHook(key, value)
end
function PANEL:AddPayloadHook(key, callback)
	if (!self.hooks[key]) then
		self.hooks[key] = {}
	end

	self.hooks[key][#self.hooks[key] + 1] = callback
end
function PANEL:RunPayloadHook(key, value)
	local hooks = self.hooks[key] or {}

	for _, v in ipairs(hooks) do
		v(value)
	end
end

function PANEL:OnSlideUp()
	self:ResetPayload()
	self:Populate()
	self:SetActiveSubpanel("faction", 0)
end

function PANEL:AttachCleanup(panel)
	self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
	BaseClass.Paint(self, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")

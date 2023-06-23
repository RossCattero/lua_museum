
local ourMat = Material( "materials/textures/menu_repair.png" )
local sizePanel = Material( "materials/textures/menu_hud_back.png" )
local littlemat = Material('materials/textures/menu_hud_back.png')
local littleGradient = Material( "gui/gradient" )

local PANEL = {};

function PANEL:Init()

    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw = ScrW()
    local sh = ScrH()
    local pnl = self;

	self:SetPos(sw * 0.3, sh * 0.1) 
    self:SetSize( sw * 0.3, sh * 0.6 )
    self:ShowCloseButton( false )
    self:SetTitle('')
	self:MakePopup()
	self:SetDraggable(false)

    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(itemtable, entity)
	local sw, sh = ScrW(), ScrH()

	local player = LocalPlayer();
	local character = player:GetCharacter();

	local ChoosenRepairKits = {};
	local ChoosenMaterials = {};
	local ChoosenBlueprint = {};

	local repairAmount = 0;

	local inv = character:GetInventory();
	local findItems = inv:GetItemsByBase("base_stalker_repairkit")

	if itemtable.model then
		self.modelInfo = self:Add("ixSpawnIcon")
		self.modelInfo:SetPos(sw * 0.0045, sh * 0.01)
		self.modelInfo:SetSize(sw * 0.08, sh * 0.14)
		self.modelInfo:SetModel(itemtable.model)

		self.getName = self:Add("DLabel")
		self.getName:SetPos(sw * 0.089, sh * 0.01)
		self.getName:SetSize(sw * 0.079, sh * 0.0325)
		self.getName:SetText(itemtable.name)
		self.getName:SetFont("StalkerFont")
	
		self.getWeight = self:Add("DLabel")
		self.getWeight:SetPos(sw * 0.089, sh * 0.062)
		self.getWeight:SetSize(sw * 0.079, sh * 0.0325)
		self.getWeight:SetText("Вес: "..itemtable.weight)
		self.getWeight:SetFont("StalkerFont")

		self.getQuality = self:Add("DLabel")
		self.getQuality:SetPos(sw * 0.089, sh * 0.115)
		self.getQuality:SetSize(sw * 0.079, sh * 0.0325)
		self.getQuality:SetText("Качество: "..itemtable.quality)
		self.getQuality:SetFont("StalkerFont")	

		self.getRepairAmount = self:Add("DLabel")
		self.getRepairAmount:SetPos(sw * 0.005, sh * 0.525)
		self.getRepairAmount:SetSize(sw * 0.079, sh * 0.0325)
		self.getRepairAmount:SetText("Качество: +0%")
		self.getRepairAmount:SetFont("StalkerFont")

		self.getRepairAmount.Think = function(self)
			self:SetText("Качество: +"..repairAmount.."%")
		end;
	end;

	self.GetListOfRepairs = self:Add("DScrollPanel")
	self.GetListOfRepairs:SetPos(sw * 0.0048, sh * 0.158)
	self.GetListOfRepairs:SetSize(sw * 0.162, sh * 0.176)
	
	self.RepairsGrid = self.GetListOfRepairs:Add( "DGrid" )
	self.RepairsGrid:Dock(FILL)
	self.RepairsGrid:SetCols( 6 )
	self.RepairsGrid:SetColWide( 55 )

	for k, item in pairs(findItems) do
		if !itemtable.name then
			break;
		end;
		if item.layTable then
			local repairKit = vgui.Create( "ixSpawnIcon" )
			repairKit:SetModel(item.model)
			repairKit:SetSize( 55, 30 )

			function repairKit:DoClick()
				self.pinned = !self.pinned;
				if self.pinned then
					table.insert(ChoosenRepairKits, item)
					repairAmount = math.Clamp(repairAmount + item.tableAddRepair, 0, 10000);
				else
					repairAmount = math.Clamp(repairAmount - item.tableAddRepair, 0, 10000);
					table.RemoveByValue(ChoosenRepairKits, item)
				end;
			end;
			function repairKit:PaintOver(w, h)
				if self.pinned then
					draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 0), Color(100, 255, 100, 255) )
				end;
			end;

			self.RepairsGrid:AddItem( repairKit )
		end;
	end;

	self.GetListOfMaterials = self:Add("DScrollPanel")
	self.GetListOfMaterials:SetPos(sw * 0.0045, sh * 0.34)
	self.GetListOfMaterials:SetSize(sw * 0.162, sh * 0.19)
	self.MaterialsGrid = self.GetListOfMaterials:Add( "DGrid" )
	self.MaterialsGrid:Dock(FILL)
	self.MaterialsGrid:SetCols( 6 )
	self.MaterialsGrid:SetColWide( 50 )

	for k, item in pairs(inv:GetItems()) do
		if !itemtable.name then
			break;
		end;
		if item.category == "Материалы" then
			local material = vgui.Create( "ixSpawnIcon" )
			material:SetModel(item.model)
			material:SetSize( 55, 30 )

			function material:DoClick()
				self.pinned = !self.pinned;
				if self.pinned then
					table.insert(ChoosenMaterials, item)
					repairAmount = math.Clamp(repairAmount + item.addPercent, 0, 10000);
				else
					repairAmount = math.Clamp(repairAmount - item.addPercent, 0, 10000);
					table.RemoveByValue(ChoosenMaterials, item)
				end;
			end;
			function material:PaintOver(w, h)
				if self.pinned then
					draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 0), Color(100, 255, 100, 255) )
				end;
			end;

			self.MaterialsGrid:AddItem( material )
		end;
	end;
	
	self.GetListOfModifications = self:Add("DScrollPanel")
	self.GetListOfModifications:SetPos(sw * 0.172, sh * 0.01)
	self.GetListOfModifications:SetSize(sw * 0.122, sh * 0.58)

	for k, item in pairs(inv:GetItemsByBase("base_stalker_blueprints")) do
		if !itemtable.name then
			break;
		end;
		local modification = self.GetListOfModifications:Add( "DPanel" )
		modification:SetSize(0, 55)
		modification:Dock( TOP )
		modification:DockMargin( 5, 5, 5, 5 )
		modification.colorGradient = {r = 100, g = 100, b = 100}
		function modification:Paint(w, h)
			surface.SetDrawColor( self.colorGradient.r, self.colorGradient.g, self.colorGradient.b, 255 )
			surface.SetMaterial( littleGradient	);
			surface.DrawTexturedRect( 0, 0, w, h );
		end;
		local iSpawnIcon = modification:Add( "ixSpawnIcon" )

		if !item["canModificate"][itemtable.type] then
			iSpawnIcon:SetDisabled(true)
			modification.colorGradient = {r = 255, g = 100, b = 100}
		end;

		iSpawnIcon:SetPos(0, 0);
		iSpawnIcon:SetSize(55, 55)
		iSpawnIcon:SetModel( item.model );
		iSpawnIcon.DoClick = function(self)

			if self:GetDisabled() then
				return;
			end;

			self.pinned = !self.pinned;
			if self.pinned then
				self:GetParent().colorGradient = {
					r = 100,
					g = 255,
					b = 100
				}
				ChoosenBlueprint = item
			else
				ChoosenBlueprint = {}
				self:GetParent().colorGradient = {
					r = 100,
					g = 100,
					b = 100
				}
			end;
		end;
	end;

	self.repairButton = self:Add("DButton")
	self.repairButton:SetPos( sw * 0.006, sh * 0.555 )
	self.repairButton:SetText('Починить')
	self.repairButton:SetSize( sw * 0.054, sh * 0.033 )
	self.repairButton.Paint = function(self, w, h)
		surface.SetDrawColor( 100, 100, 100, 255 )
		surface.SetMaterial( littlemat );
		surface.DrawTexturedRect( 0, 0, w, h );

		if !itemtable.name then
			self:SetDisabled(true)
			self:SetTextColor(Color(255, 100, 100))
		end;
	end;
	self.repairButton.DoClick = function()
		self:Close() netstream.Start("Table_repairAction", entity, itemtable, ChoosenRepairKits, ChoosenMaterials, ChoosenBlueprint)
	end;
	
	self.closePanel = self:Add("DButton")
	self.closePanel:SetPos( sw * 0.062, sh * 0.555 )
	self.closePanel:SetSize( sw * 0.054, sh * 0.033 )
	self.closePanel:SetText('Закрыть')
	self.closePanel.Paint = function(self, w, h)
		surface.SetDrawColor( 100, 100, 100, 255 )
		surface.SetMaterial( littlemat );
		surface.DrawTexturedRect( 0, 0, w, h );
	end;
	self.closePanel.DoClick = function()
		self:Close()
	end;
	self.modificateButton = self:Add("DButton")
	self.modificateButton:SetPos( sw * 0.118, sh * 0.555 )
	self.modificateButton:SetSize( sw * 0.049, sh * 0.033 )
	self.modificateButton:SetText('Модифицировать')
	self.modificateButton.Paint = function(self, w, h)
		surface.SetDrawColor( 100, 100, 100, 255 )
		surface.SetMaterial( littlemat );
		surface.DrawTexturedRect( 0, 0, w, h );

		if !itemtable.name or !ChoosenBlueprint.name then
			self:SetDisabled(true)
			self:SetTextColor(Color(255, 100, 100))
		end;
	end;
	
end;

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( ourMat )
	surface.DrawTexturedRect( 0, 0, w, h )
	self:CloseOnMinus()
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

vgui.Register( "STALKER_OpenRepair", PANEL, "DFrame" )
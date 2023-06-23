local PANEL = {};

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw = ScrW()
    local sh = ScrH()
    local pnl = self;
	self:SetPos(sw * 0.3, sh * 0.25) 
    self:SetSize( sw * 0.35, sh * 0.3 )
    self:ShowCloseButton( false )
    self:SetTitle('')
	self:MakePopup()
	self:SetDraggable(false)
    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(item)
    local sw, sh = ScrW(), ScrH()
    local inventory = LocalPlayer():GetCharacter():GetInventory():GetItems()

    self.weaponsList = self:Add('DScrollPanel')
    self.weaponsList:SetPos( sw * 0.1, sh * 0.01 )
    self.weaponsList:SetSize(sw * 0.24, sh * 0.12)
    self.weaponsList.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
    end;

    self.AmountOfRepair = self:Add("DLabel")
    self.AmountOfRepair:SetPos(sw * 0.22, sh * 0.26)
    self.AmountOfRepair:SetSize(sw * 0.059, sh * 0.035)
    self.AmountOfRepair:SetFont("StalkerGraffitiFontLittle")
    self.AmountOfRepair:SetText("Количество: +"..item.repairAmount)
    self.AmountOfRepair.amountAdd = item.repairAmount

    self.weaponImage = self:Add('ixSpawnIcon')
    self.weaponImage:SetPos( sw * 0.01, sh * 0.01 )
    self.weaponImage:SetSize(sw * 0.07, sh * 0.12)
    for k, v in pairs(inventory) do
        if ((item.repairType == 'Оружие' or item.repairType == 'Разное') && v.base == "base_weapons" && item.weaponType[GetWeaponTFAtype(v.uniqueID)] && v:GetData('WeaponQuality') >= item.minrepair) or
        ((item.repairType == 'Броня' or item.repairType == 'Разное') && v.base == 'base_outfit' && item.armorType[v.armorType] && v:CountQualityPercent() >= item.minrepair) then
            local weapon = self.weaponsList:Add( "DButton" )
            weapon:SetText( v.name )
            weapon:Dock( TOP )
            weapon.IsChecked = false
            weapon:DockMargin( 5, 5, 5, 5 )
            weapon.DoClick = function(s)
                self.itemTable = v;
                self.weaponImage:SetModel(v.model)

                if self.checkedWeapon then
                    self.checkedWeapon.checked = false
                end;
                self.checkedWeapon = s;
                self.checkedWeapon.checked = true;
            end;
            weapon.PaintOver = function(self, w, h)
                if self.checked then
                    draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(0, 0, 0, 0), Color(100, 255, 100) )
                end;
            end;
        end;
    end;

    self.repairImage = self:Add('ixSpawnIcon')
    self.repairImage:SetPos( sw * 0.01, sh * 0.135 )
    self.repairImage:SetSize(sw * 0.07, sh * 0.12)
    self.repairImage:SetModel(item.model)

    self.itemsList = self:Add('DScrollPanel')
    self.itemsList:SetPos( sw * 0.1, sh * 0.135 )
    self.itemsList:SetSize(sw * 0.24, sh * 0.12)
    self.itemsList.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
    end;

    for k, v in pairs(inventory) do
        if v.category == "Материалы" then
            local material = self.itemsList:Add( "DButton" )
            material:SetText( v.name )
            material:Dock( TOP )
            material:DockMargin( 5, 5, 5, 5 )
            material.DoClick = function(s)
                if self.checkedMaterial then
                    self.checkedMaterial.checked = false
                end;
                self.itemMaterial = v;
                self.checkedMaterial = s;
                self.checkedMaterial.checked = true;
                self.AmountOfRepair:SetText("Количество: +"..item.repairAmount + v.addPercent)
                self.AmountOfRepair.amountAdd = item.repairAmount + v.addPercent
            end;
            material.PaintOver = function(self, w, h)
                if self.checked then
                    draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(0, 0, 0, 0), Color(100, 255, 100) )
                end;
            end;
        end;
    end;

    self.closeButton = self:Add('DButton')
    self.closeButton:SetPos(sw * 0.1, sh * 0.26)
    self.closeButton:SetSize(sw * 0.059, sh * 0.035)
    self.closeButton:SetText('Выйти')
    self.closeButton.DoClick = function()
        self:Close()
    end;

    self.repair = self:Add('DButton')
    self.repair:SetPos(sw * 0.16, sh * 0.26)
    self.repair:SetSize(sw * 0.059, sh * 0.035)
    self.repair:SetText('Починка')
    self.repair.DoClick = function()
        if self.itemTable then
            self:Close()
            netstream.Start("ToolRepair_action", self.AmountOfRepair.amountAdd, self.itemTable, self.itemMaterial, item)
        end;
    end;
end;

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
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

vgui.Register( "STALKER_OpenLittleRepair", PANEL, "DFrame" )
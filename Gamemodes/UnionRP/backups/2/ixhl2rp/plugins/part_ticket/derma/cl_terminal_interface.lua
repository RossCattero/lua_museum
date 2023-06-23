local PANEL = {};
local FractureCol = Color(255, 97, 0)

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw = ScrW()
    local sh = ScrH()

	self:SetPos(sw * (750/sw), sh * (270/sh)) 
    self:SetSize( sw * (260/sw), sh * (240/sh) )
    self:ShowCloseButton( false )
    self:SetTitle('')
	self:MakePopup()
	self:SetDraggable(false)
    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30))
    self:CloseOnMinus()
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function PANEL:Populate(data)
    local sw = ScrW()
    local sh = ScrH()

    self.chooseName = vgui.Create('DLabel', self)
    self.chooseName:SetText('Выберите имя')
    self.chooseName:SetPos(sw * (6/sw), sh * (6/sh))
    self.chooseName:SizeToContents()

    self.chooseID = vgui.Create('DLabel', self)
    self.chooseID:SetText('Идентификатор')
    self.chooseID:SetPos(sw * (6/sw), sh * (30/sh))
    self.chooseID:SizeToContents()

    self.chooseStatus = vgui.Create('DLabel', self)
    self.chooseStatus:SetText('Выберите статус')
    self.chooseStatus:SetPos(sw * (6/sw), sh * (82/sh))
    self.chooseStatus:SizeToContents()

    self.chooseStatus = vgui.Create('DLabel', self)
    self.chooseStatus:SetText('Место жительства')
    self.chooseStatus:SetPos(sw * (6/sw), sh * (105/sh))
    self.chooseStatus:SizeToContents()

    self.typeAge = vgui.Create('DLabel', self)
    self.typeAge:SetText('Возраст(10 - 95)')
    self.typeAge:SetPos(sw * (6/sw), sh * (128/sh))
    self.typeAge:SizeToContents()

    self.GetTown = vgui.Create('DLabel', self)
    self.GetTown:SetText('С какого города')
    self.GetTown:SetPos(sw * (6/sw), sh * (155/sh))
    self.GetTown:SizeToContents()

    self.listName = vgui.Create( "DComboBox", self )
    self.listName:SetPos( sw * (104/sw), sh * (5/sh) )
    self.listName:SetSize( sw * (150/sw), sh * (20/sh) )
    self.listName:SetValue( data['name'] or "Выберите персонажа" )
    self.listName.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
    end;
    for k, v in ipairs(player.GetAll()) do
        self.listName:AddChoice( v:GetName() )
    end;
    
    self.getID = vgui.Create('DLabel', self)
    self.getID:SetText(data['partyID'] or Schema:ZeroNumber(math.random(1, 999999), 6))
    self.getID:SetPos(sw * (104/sw), sh * (30/sh))
    self.getID:SetSize(sw * (150/sw), sh * (20/sh))
    self.getID:SetContentAlignment(5)
    self.getID.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
    end;

    self.refreshNumber = vgui.Create('DButton', self)
    self.refreshNumber:SetText('Обновить')
    self.refreshNumber:SetPos(sw * (104/sw), sh * (55/sh))
    self.refreshNumber:SetSize(sw * (150/sw), sh * (20/sh))
    self.refreshNumber.DoClick = function(btn)
        self.getID:SetText(Schema:ZeroNumber(math.random(1, 999999), 6))
    end;

    self.typeLivePlace = vgui.Create( "DTextEntry", self )
    self.typeLivePlace:SetPos( sw * (104/sw), sh * (105/sh) )
    self.typeLivePlace:SetSize( sw * (150/sw), sh * (20/sh) )
    self.typeLivePlace:SetValue( data['liveplace'] or "" )
    self.typeLivePlace.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
        self:DrawTextEntryText( color_white, color_white, color_white )
    end;

    self.AgePlace = vgui.Create( "DNumberWang", self )
    self.AgePlace:SetPos( sw * (104/sw), sh * (130/sh) )
    self.AgePlace:SetSize( sw * (150/sw), sh * (20/sh) )
    self.AgePlace:SetValue( data['age'] or 10 )
    self.AgePlace:SetMinMax(10, 95);
    self.AgePlace.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
        self:DrawTextEntryText( color_white, color_white, color_white )
    end;

    self.TypeTown = vgui.Create( "DTextEntry", self )
    self.TypeTown:SetPos( sw * (104/sw), sh * (155/sh) )
    self.TypeTown:SetSize( sw * (150/sw), sh * (20/sh) )
    self.TypeTown:SetValue( data['town'] or '' )
    self.TypeTown.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
        self:DrawTextEntryText( color_white, color_white, color_white )
    end;

    self.submitInfo = vgui.Create('DButton', self)
    self.submitInfo:SetText('Сохранить')
    self.submitInfo:SetPos(sw * (5/sw), sh * (187/sh))
    self.submitInfo:SetSize(sw * (250/sw), sh * (20/sh))
    self.submitInfo.DoClick = function(btn)
        local name, age, live, town, status, partyID = self.listName:GetValue(), self.AgePlace:GetValue(), self.typeLivePlace:GetValue(), self.TypeTown:GetValue(), self.citizenStatus:GetValue(), self.getID:GetText();
        netstream.Start('SaveCardInformation', {
            ['name'] = name,
			['age'] = age,
			['liveplace'] = live,
			['town'] = town,
			['status'] = status,
			['partyID'] = partyID
        })
        surface.PlaySound('buttons/bell1.wav')
        
    end;

    self.doClose = vgui.Create('DButton', self)
    self.doClose:SetText('Закрыть')
    self.doClose:SetPos(sw * (5/sw), sh * (212/sh))
    self.doClose:SetSize(sw * (250/sw), sh * (20/sh))
    self.doClose.DoClick = function(btn)
        self:Close();
        surface.PlaySound('buttons/button16.wav')
    end;
    
    self.citizenStatus = vgui.Create( "DComboBox", self )
    self.citizenStatus:SetPos( sw * (104/sw), sh * (80/sh) )
    self.citizenStatus:SetSize( sw * (150/sw), sh * (20/sh) )
    self.citizenStatus:SetValue( "Статус" )

    self.citizenStatus:AddChoice( 'Альфа' )
    self.citizenStatus:AddChoice( 'Бета' )
    self.citizenStatus:AddChoice( 'Гамма' )
    self.citizenStatus:AddChoice( 'Дельта' )
    self.citizenStatus:AddChoice( 'ЭПСИЛОН' )

    self.citizenStatus:SetValue( data['status'] or "Статус" )

    self.citizenStatus.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
    end;
end;

vgui.Register( "TerminalFrame", PANEL, "DFrame" )
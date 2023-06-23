local PANEL = {};

function PANEL:Init()
    local sw, sh = ScrW(), ScrH()
    
    self:SetFocusTopLevel( true )
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )

    self:ShowCloseButton( false )
    self:SetTitle('')
    self:SetPos( sw * (550/sw), sh * (300/sh) )
    self:SetSize( sw * (500/sw), sh * (155/sh) )
    self:MakePopup()
    self:SetDraggable(false)

	gui.EnableScreenClicker(true);
end;

function PANEL:Populate()
    local sw, sh = ScrW(), ScrH()

    self.SleepPanel = self:Add('Panel')
    self.SleepPanel:SetPos(sw * (10/sw), sh * (10/sh))
    self.SleepPanel:SetSize(sw * (480/sw), sh * (60/sh))

    self.sleepSlider = self.SleepPanel:Add( "DNumSlider" )
    self.sleepSlider:Dock(FILL)
    self.sleepSlider:SetText( "Количество времени для сна: " )
    self.sleepSlider:SetMin( 0 )
    self.sleepSlider:SetMax( 60 )
    self.sleepSlider:SetDecimals( 0 )

    self.startSleep = self:Add("DButton")
    self.startSleep:SetSize( sw * (480/sw), sh * (25/sh) )
    self.startSleep:SetPos(sw * (10/sw), sh * (90/sh))
    self.startSleep:SetColor(Color(255, 255, 255))
    self.startSleep:SetText('Спать')

    self.startSleep.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;

    self.startSleep.DoClick = function(btn)
        netstream.Start('SleepStart', self.sleepSlider:GetValue())
    end;

    self.closeButton = self:Add("DButton")
    self.closeButton:SetSize( sw * (480/sw), sh * (25/sh) )
    self.closeButton:SetPos(sw * (10/sw), sh * (120/sh))
    self.closeButton:SetColor(Color(255, 255, 255))
    self.closeButton:SetText('ЗАКРЫТЬ')

    self.closeButton.DoClick = function(btn)
        self:Close();
    end;

    self.closeButton.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;

end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
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
end;

vgui.Register( "SleepPanel", PANEL, "DFrame" )
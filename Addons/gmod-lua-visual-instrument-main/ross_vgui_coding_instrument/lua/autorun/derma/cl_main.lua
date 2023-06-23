local PANEL = {};

listOfAll = {}
GetAllPanels = {}
toolTiped = false;

function PANEL:Init()
    self:SetFocusTopLevel( true )
    self:Adaptate(1920, 1080, 0, 0)
    self:MakePopup()
    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    self:CreateCloseDebug()
end;

function PANEL:Populate()
    
    self.panelsList = self:Add('Panel')
    self.panelsList:SetSize( 200, 1080 )
    self.panelsList:SetPos(1920, 0)
    self.panelsList:DockPadding(5, 5, 5, 5)
    self.panelsList.closed = false;
    self.panelsList.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(30, 30, 30, 255) )
    end;

    self.CloseButton = self.panelsList:Add('DButton')
    self.CloseButton:SetText('Закрыть')
    self.CloseButton:Dock(TOP);

    self.CloseButton.DoClick = function(btn)

        if !timered or CurTime() >= timered then
            local add = 0;
            if self.panelsList.closed then add = 200
            elseif !self.panelsList.closed then add = 10 end;
            self.panelsList:MoveTo( 1920 - add, 0, 1, 0, -1, function()
                self.panelsList:Dock(0)
                self.panelsList.closed = !self.panelsList.closed
            end)

            timered = CurTime() + 1;
        end;
    end;

    self.CloseButton.Paint = function(s, w, h)
        s:dohover(w, h)
    end;
    
    self.panelsListScroll = self.panelsList:Add( "DScrollPanel" )
    self.panelsListScroll:Dock( TOP )
    self.panelsListScroll:SetSize(0, 500)

    self.settingsList = self.panelsList:Add('SettingsList')
    self.settingsList:Dock( BOTTOM )
    self.settingsList:SetSize( 0, 580 )


    self.panelsList:MoveTo( 1920-200, 0, 1, 0, -1, function()
        self.panelsList:Dock( RIGHT )
    end)

    local baseParent = self;
    for i = 1, #PanelList do
        local contentButton = self.panelsListScroll:Add( "DButton" )
        contentButton:SetText( PanelList[i] )
        contentButton:SizeToContents()
        contentButton:Dock( TOP )
        contentButton:DockMargin( 5, 5, 5, 5 )

        contentButton.Paint = function(s, w, h)
            s:dohover(w, h)
        end;

        function contentButton:OnMousePressed( mousecode )
            if mousecode == MOUSE_RIGHT then
                gui.OpenURL( 'https://wiki.facepunch.com/gmod/' .. PanelList[i] )
            elseif mousecode == MOUSE_LEFT then
                self.DoClick(self);
            end;
        end;

        contentButton.DoClick = function(button)
            local playablePanel = vgui.Create(button:GetText(), self)
            playablePanel:SetMouseInputEnabled( true )
	        playablePanel:SetKeyboardInputEnabled( true )
            playablePanel.placedColor = Color(30, 30, 30)

            playablePanel:Droppable( 'MakeDroppableForMe' )

            if playablePanel.ShowCloseButton then
                playablePanel:ShowCloseButton(false)
                playablePanel:SetTitle('')
            end;

            playablePanel.numberInLine = #GetAllPanels + 1

            self.settingsList.parentList:AddChoice( playablePanel.numberInLine .. ' - ' .. playablePanel:GetName() )
            self.settingsList.GetAllListBox:AddChoice( playablePanel.numberInLine .. ' - ' .. playablePanel:GetName() )
            GetAllPanels[playablePanel.numberInLine] = playablePanel
            self.settingsList.GetAllListBox:ChooseOptionID( playablePanel.numberInLine )
            
            function playablePanel:OnMousePressed( mousecode )
                if !toolTiped then
                    toolTiped = self
                    local sizeX, sizeY = self:GetSize();
                    local x, y = self:GetPos();
                    baseParent.settingsList.titleList:SetText(toolTiped:GetName())
                    baseParent.settingsList.panelSizeX:SetValue(sizeX)
                    baseParent.settingsList.panelSizeY:SetValue(sizeY)
                    baseParent.settingsList.XText:SetValue( x )
                    baseParent.settingsList.YText:SetValue( y )
                    baseParent.settingsList.GetAllListBox:ChooseOptionID( self.numberInLine )
                    ShowStackPanels()                
                else
                    baseParent.settingsList.GetAllListBox:SetText('Выберите предмет')
                    toolTiped = false;
                    baseParent.settingsList.titleList:SetText('')  
                    HideStackPanels()
                end;
            end

            playablePanel.Paint = function(s, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, s.placedColor )
                if toolTiped == s then 
                    draw.RoundedBoxOutlined( 1, 0, 0, w, h, s.placedColor, Color(100, 200, 100, 255) ) 

                    if s:IsHovered() then
                        local sizeX, sizeY = s:GetSize();
                        local curPosX, curPosY = s:CursorPos()
                        local CursorHoversX = curPosX >= sizeX-15 && curPosY >= 0
                        local CursorHoversY = curPosX >= 0 && curPosY >= sizeY - 15
    
                        if CursorHoversX then
                            if input.IsMouseDown( 107 ) then 
                                s:SetSize(gui.MouseX() + 25, sizeY) 
                            end;
                        elseif CursorHoversY then
                            if input.IsMouseDown( 107 ) then 
                                s:SetSize(sizeX, gui.MouseY() + 25) 
                            end;
                        end;
                    end;
                end;
            end;
        end;

    end

end;

--[[ Compability functions ]]--

function AddPanelToStack( panel )
    listOfAll[#listOfAll + 1] = panel;
end

function HideStackPanels()
    for k, v in pairs(listOfAll) do
        v:SetVisible(false)
    end;
end

function ShowStackPanels()
    for k, v in pairs(listOfAll) do
        v:SetVisible(true)
    end;
end

--[[ Compability functions ]]--

vgui.Register( "MainCreatorPanel", PANEL, "EditablePanel" )
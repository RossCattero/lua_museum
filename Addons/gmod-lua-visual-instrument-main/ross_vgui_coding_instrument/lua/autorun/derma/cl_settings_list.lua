local PANEL = {};

function PANEL:Init() 

    self.GetAllListBox = self:Add('DComboBox')
    self.GetAllListBox:Dock(TOP)
    self.GetAllListBox:SetValue( "Выбрать предмет" )

    self.GetAllListBox.OnSelect = function( combo, index, value )
        value = tonumber(string.gmatch(value, "[%d_]+")());
        toolTiped = GetAllPanels[value]
        ShowStackPanels()
    end

    self.titleList = self:Add('DLabel')
    self.titleList:Dock(TOP)
    self.titleList:SetText("")
    self.titleList:SetContentAlignment( 5 )
    
    self.panelSizeX = self:Add('DNumSlider')
    self.panelSizeX:Dock(TOP)
    self.panelSizeX:SetValue(0)
    self.panelSizeX:GetTextArea():SetTextColor(Color(255, 255, 255))
    self.panelSizeX:SetText('Ширина')
    self.panelSizeX:SetMinMax( 10, 1920 )
    self.panelSizeX.OnValueChanged = function( numSlider, value )
        if toolTiped && numSlider:IsHovered() then
            local sizeX, sizeY = toolTiped:GetSize();
            toolTiped:SetSize(value, sizeY)
        end;
    end

    self.panelSizeX.Think = function( numSlider )
        if toolTiped then
            local sizeX = toolTiped:GetSize();
            numSlider:SetValue(sizeX)
        end;
    end

    self.panelSizeY = self:Add('DNumSlider')
    self.panelSizeY:Dock(TOP)
    self.panelSizeY:SetValue(0)
    self.panelSizeY:GetTextArea():SetTextColor(Color(255, 255, 255))
    self.panelSizeY:SetText('Длина')
    self.panelSizeY:SetMinMax( 10, 1920 )
    self.panelSizeY.OnValueChanged = function( numSlider, value )
        if toolTiped && numSlider:IsHovered() then
            local sizeX, sizeY = toolTiped:GetSize();
            toolTiped:SetSize(sizeX, value)
        end;
    end

    self.panelSizeY.Think = function( numSlider )
        if toolTiped then
            local sizeX, sizeY = toolTiped:GetSize();
            numSlider:SetValue(sizeY)
        end;
    end

    self.XText = self:Add( "DNumSlider" )
    self.XText:Dock(TOP)
    self.XText:SetValue( 0 )
    self.XText:GetTextArea():SetTextColor(Color(255, 255, 255))
    self.XText:SetText('Ось X')
    self.XText:SetMinMax( 0, 1920 )
    self.XText.OnValueChanged = function( numSlider, value )
        if toolTiped then
            local x, y = toolTiped:GetPos()
            toolTiped:SetPos( value, y )
        end;
    end

    self.YText = self:Add( "DNumSlider" )
    self.YText:Dock(TOP)
    self.YText:SetValue( 0 )
    self.YText:GetTextArea():SetTextColor(Color(255, 255, 255))
    self.YText:SetText('Ось Y')
    self.YText:SetMinMax( 0, 1920 )
    self.YText.OnValueChanged = function( numSlider, value )
        if toolTiped then
            local x, y = toolTiped:GetPos()
            toolTiped:SetPos( x, value )
        end;
    end

    self.parentList = self:Add('DComboBox')
    self.parentList:Dock(TOP)
    self.parentList:SetValue( "Родитель" )
    self.parentList:AddChoice( 'Ничего' )
    self.parentList.OnSelect = function( combo, index, value )
        if toolTiped != false && value != 'Ничего' then
            value = tonumber(string.gmatch(value, "[%d_]+")());

            if toolTiped != GetAllPanels[value] then
                toolTiped:SetParent( GetAllPanels[value] )
            end;
        end;
    end

    self.reloadPlace = self:Add('DButton')
    self.reloadPlace:SetText('Обновить')
    self.reloadPlace:Dock(TOP)
    self.reloadPlace.DoClick = function(btn)
        toolTiped:SetPos(0, 0)
    end;
    self.reloadPlace.Paint = function(s, w, h)
        s:dohover(w, h)
    end;

    self.deletePanel = self:Add('DButton')
    self.deletePanel:SetText('Удалить')
    self.deletePanel:Dock(TOP)
    self.deletePanel.DoClick = function(btn)
        GetAllPanels[toolTiped.numberInLine] = nil
        toolTiped:Remove();
        toolTiped = false;
        self.parentList:Clear()
        self.GetAllListBox:Clear()
        for k, v in pairs(GetAllPanels) do
            if v && v.numberInLine then
                self.parentList:AddChoice( v.numberInLine .. ' - ' .. v:GetName() )
                self.GetAllListBox:AddChoice( v.numberInLine .. ' - ' .. v:GetName() )
            end;
        end;     
    
    end;
    self.deletePanel.Paint = function(s, w, h)
        s:dohover(w, h)
    end;

    self.mixer = self:Add("DColorMixer")
    self.mixer:Dock(TOP)
    self.mixer:SetPalette(true)
    self.mixer:SetAlphaBar(true)
    self.mixer:SetWangs(true)
    self.mixer:SetColor( Color(30, 100, 160) ) 
    self.mixer.ValueChanged = function(palette, color)
        toolTiped.placedColor = color;
    end;

    self.getDock = self:Add('DComboBox')
    self.getDock:Dock(TOP)
    self.getDock:SetValue( "Уравнивание" )
    self.getDock:AddChoice( '0 - NODOCK' )
    self.getDock:AddChoice( '1 - FILL' )
    self.getDock:AddChoice( '2 - LEFT' )
    self.getDock:AddChoice( '3 - RIGHT' )
    self.getDock:AddChoice( '4 - TOP' )
    self.getDock:AddChoice( '5 - BOTTOM' )
    self.getDock.OnSelect = function( combo, index, value )
        value = tonumber(string.gmatch(value, "[%d_]+")());

        toolTiped:Dock( value )
    end

    self.changeText = self:Add('DTextEntry')
    self.changeText:Dock(TOP)
    self.changeText.OnChange = function( entry )
        if toolTiped:GetText() then
            toolTiped:SetText( entry:GetText() )
        end;
    end
    
    self.ExportButton = self:Add('DButton')
    self.ExportButton:SetText('Экспортировать')
    self.ExportButton:Dock(TOP)
    self.ExportButton.DoClick = function(btn)
        local mainPanel = self:GetParent():GetParent();

        mainPanel:ExportFunctionCall();

    end;
    self.ExportButton.Paint = function(s, w, h)
        s:dohover(w, h)
    end;
    
    local brotherPanel = self:GetChild(0);
    for index, children in pairs(brotherPanel:GetChildren()) do
        if index > 1 then
            AddPanelToStack( children )
        end;
    end;
    HideStackPanels()
    
end;

vgui.Register( "SettingsList", PANEL, "DScrollPanel" )
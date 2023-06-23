local PANEL = {};
local FractureCol = Color(255, 97, 0)

function PANEL:Init()
    local sw = ScrW()
    local sh = ScrH()
    
	self:SetPos(sw * (400/sw), sh * (200/sh)) 
    self:SetSize( sw * (560/sw), sh * (600/sh) )
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetTitle( '' )
    
    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBox( 0, 0, 0, w, h, Color(255, 255, 255, 255) )
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

local delay = nil;

    local function AllowedByCooldown()
        if !delay or delay < CurTime() then
            delay = CurTime() + 0.5;
            return true;
        end;

        return false;
    end;

local function AddLogNotification(scrollList, time, type, text)

    local notificationPlayer = scrollList:Add( "Panel" )
    notificationPlayer:Dock( TOP )
    notificationPlayer:DockMargin( 5, 5, 5, 5 )
    notificationPlayer:SetTall(50)
    notificationPlayer:DockPadding(5, 5, 5, 5)
    notificationPlayer.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    local timeLabel = notificationPlayer:Add('DLabel')
    timeLabel:SetText(time)
    timeLabel:Dock(TOP)
    timeLabel:SetContentAlignment(7)
    timeLabel:SetWrap(true)
    local SeeTheType = notificationPlayer:Add('DLabel')
    SeeTheType:SetText(type)
    SeeTheType:Dock(TOP)
    SeeTheType:SetContentAlignment(7)
    SeeTheType:SetWrap(true)

    local descriptionLabel = notificationPlayer:Add('DLabel')
    descriptionLabel:SetText(text)
    descriptionLabel:Dock(FILL)
    descriptionLabel:SetContentAlignment(7)
    descriptionLabel:SetWrap(true)
    
    notificationPlayer.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;
    
    notificationPlayer:SetTall(80 + (utf8.len(descriptionLabel:GetText()) / 50) * 8);

end;

local function CreateChatMessage(pnl, who, time, text)

    local chatMessage = pnl:Add( "Panel" )
    chatMessage:Dock( TOP )
    chatMessage:DockMargin( 5, 5, 5, 5 )
    chatMessage:SetTall(50)
    chatMessage:DockPadding(5, 5, 5, 5)
    chatMessage.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    local chatTime = chatMessage:Add('DLabel')
    chatTime:SetText(time)
    chatTime:Dock(TOP)
    chatTime:SetContentAlignment(7)
    chatTime:SetWrap(true)
    local WhoIs = chatMessage:Add('DLabel')
    WhoIs:SetText(who)
    WhoIs:Dock(TOP)
    WhoIs:SetContentAlignment(7)
    WhoIs:SetWrap(true)

    local messageText = chatMessage:Add('DLabel')
    messageText:SetText(text)
    messageText:Dock(FILL)
    messageText:SetContentAlignment(7)
    messageText:SetWrap(true)
    
    chatMessage.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;
    
    chatMessage:SetTall(80 + (utf8.len(messageText:GetText()) / 50) * 8);

end;

local function CreateUnitChat(panel, options, messages)
    local pnlW, pnlH = panel:GetSize();

    panel.ChatPanel = panel:Add('Panel')
    panel.ChatPanel:Dock(FILL)
    panel.ChatPanel.Paint = function(s, w, h)
    end;

    
    panel.chatList = panel.ChatPanel:Add('DScrollPanel')
    panel.chatList:SetPos(10, 10)
    panel.chatList:SetSize(pnlW - 20, pnlH - 150)
    panel.chatList.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;
    for k, v in pairs(messages or {}) do
        CreateChatMessage(panel.chatList, v.name, v.time, v.message)
    end;
    
    panel.chatBox = panel.ChatPanel:Add('DTextEntry')
    panel.chatBox:SetPos(10, pnlH - 130)
    panel.chatBox:SetMultiline(true)
    panel.chatBox:SetSize(pnlW - 20, 80)
    panel.chatBox.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )

        s:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
    end;

    local backButton = panel.ChatPanel:Add( "DButton" )
	backButton:SetText( 'Назад' )
    backButton:SetPos(10, 550)
    backButton:SetSize(100, 40)
    backButton:SetColor( Color(255, 255, 255) )
    backButton:SetContentAlignment( 5 )

    backButton.Paint = function(btn, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    local sendButton = panel.ChatPanel:Add( "DButton" )
	sendButton:SetText( 'Отправить' )
    sendButton:SetPos(120, 550)
    sendButton:SetSize(100, 40)
    sendButton:SetColor( Color(255, 255, 255) )
    sendButton:SetContentAlignment( 5 )

    sendButton.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    sendButton.DoClick = function(s)
        local TimeString = ix.date.GetFormatted("%H:%M:%S - %d/%m/%Y", ix.date.Get())

        netstream.Start('ChatboxMessageAdd', LocalPlayer():GetName(), TimeString, panel.chatBox:GetText())

        messages[#messages + 1] = {
            name = LocalPlayer():GetName(),
            time = TimeString,
            message = panel.chatBox:GetText()
        }
    end;
    
    backButton.DoClick = function(s)
        panel.ChatPanel:Remove();
        options:SetEnabled(true)
        options:SetAlpha(255)
    end;

end;

local function OpenCitizenInformation(panel, information, identificator)

    panel.nameLabel = panel:Add('DLabel')
    panel.nameLabel:SetText('Имя: '..information.name)
    panel.nameLabel:SetPos(10, 10)
    panel.nameLabel:SizeToContents()

    panel.status = panel:Add('DLabel')
    panel.status:SetText('Статус: '..information.class)
    panel.status:SetPos(10, 30)
    panel.status:SizeToContents()

    panel.authorized = panel:Add('DLabel')
    panel.authorized:SetText('Авторизирован: '..tostring(information.authorized))
    panel.authorized:SetPos(10, 50)
    panel.authorized:SizeToContents()

    panel.idcard = panel:Add('DLabel')
    panel.idcard:SetText('ID карты: '..information.cardID)
    panel.idcard:SetPos(10, 70)
    panel.idcard:SizeToContents()

    panel.warned = panel:Add('DLabel')
    panel.warned:SetText('В розыске: '..tostring(information.warned))
    panel.warned:SetPos(10, 90)
    panel.warned:SizeToContents()

    panel.lastSeen = panel:Add('DLabel')
    panel.lastSeen:SetText('Видели последний раз: '..information.lastseen)
    panel.lastSeen:SetPos(10, 110)
    panel.lastSeen:SizeToContents()

    local addNote = panel.CharPNL:Add( "DButton" )
	addNote:SetText( 'Добавить запись' )
    addNote:SetPos(220, 530)
    addNote:SetSize(100, 20)
    addNote:SetContentAlignment( 5 )
    addNote.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    local RegisterCard = panel.CharPNL:Add( "DButton" )
	RegisterCard:SetText( 'Подтвердить' )
    RegisterCard:SetPos(325, 530)
    RegisterCard:SetSize(100, 20)
    RegisterCard:SetContentAlignment( 5 )
    RegisterCard.Paint = function(s, w, h)
        if !s:IsEnabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 150, 150) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;    
    end;

    if information.authorized then RegisterCard:SetDisabled(true) end;
    
    RegisterCard.DoClick = function(btn)
        if !information.authorized then
            panel.authorized:SetText('Авторизирован: Да')
            panel.authorized:SetColor(Color(100, 255, 100))
            panel.authorized:SizeToContents()
            RegisterCard:SetDisabled(true)

            netstream.Start('PDA_MakeSomeNoise', identificator, 'authorize', true)
        end;
    end;

    local WarnedRegister = panel.CharPNL:Add( "DButton" )
	WarnedRegister:SetText( 'Объявить в розыск' )
    WarnedRegister:SetPos(430, 530)
    WarnedRegister:SetSize(100, 20)
    WarnedRegister:SetContentAlignment( 5 )
    WarnedRegister.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    WarnedRegister.DoClick = function(btn)
        if !information.warned then
            panel.warned:SetText('В розыске: Да')
            panel.warned:SetColor(Color(255, 100, 100))
        elseif information.warned then
            panel.warned:SetText('В розыске: Нет')
            panel.warned:SetColor(Color(255, 255, 255))
        end;

        information.warned = !information.warned
        netstream.Start('PDA_MakeSomeNoise', identificator, 'warned', information.warned)
        panel.warned:SizeToContents()
    end;

    local RefreshLastSeen = panel.CharPNL:Add( "DButton" )
	RefreshLastSeen:SetText( 'Появление' )
    RefreshLastSeen:SetPos(10, 555)
    RefreshLastSeen:SetSize(100, 20)
    RefreshLastSeen:SetContentAlignment( 5 )
    RefreshLastSeen.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    RefreshLastSeen.DoClick = function(btn)
        local TimeString = ix.date.GetFormatted("%H:%M:%S - %d/%m/%Y", ix.date.Get())
        panel.lastSeen:SetText('Видели последний раз: '..TimeString)
        panel.lastSeen:SizeToContents()

        netstream.Start('PDA_MakeSomeNoise', identificator, 'last', TimeString)
    end;

    local SetClass = panel.CharPNL:Add( "DButton" )
	SetClass:SetText( 'Изменить класс' )
    SetClass:SetPos(115, 555)
    SetClass:SetSize(100, 20)
    SetClass:SetContentAlignment( 5 )
    SetClass.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    SetClass.DoClick = function(btn)
        if panel.citizenStatus:GetText() != 'Статус' then
            panel.status:SetText('Статус: '..panel.citizenStatus:GetText());
            panel.status:SizeToContents()

            netstream.Start('PDA_MakeSomeNoise', identificator, 'class', panel.citizenStatus:GetText())
        end;
    end;

    panel.NotesList = panel.CharPNL:Add('Panel')
    panel.NotesList:SetPos(10, 125)
    panel.NotesList:SetSize(520, 300)
    panel.NotesList.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    local scrollList = panel.NotesList:Add('DScrollPanel')
    scrollList:Dock(FILL)

    local NotificationEntry = panel.CharPNL:Add('DTextEntry')
    NotificationEntry:SetPos(10, 430)
    NotificationEntry:SetMultiline(true)
    NotificationEntry:SetSize(520, 60)
    NotificationEntry.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
    end;

    panel.citizenStatus = panel.CharPNL:Add( "DComboBox" )
    panel.citizenStatus:SetPos( 10, 500 )
    panel.citizenStatus:SetSize( 100, 25 )
    panel.citizenStatus:SetValue( "Статус" )

    panel.citizenStatus:AddChoice( 'Альфа' )
    panel.citizenStatus:AddChoice( 'Бета' )
    panel.citizenStatus:AddChoice( 'Гамма' )
    panel.citizenStatus:AddChoice( 'Дельта' )
    panel.citizenStatus:AddChoice( 'ЭПСИЛОН' )

    panel.citizenStatus:SetValue( "Статус" )
    panel.citizenStatus.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
    end;

    panel.noteType = panel.CharPNL:Add( "DComboBox" )
    panel.noteType:SetPos( 115, 500 )
    panel.noteType:SetSize( 100, 25 )
    panel.noteType:SetValue( "Статус" )

    panel.noteType:AddChoice( '[Медицинская заметка]' )
    panel.noteType:AddChoice( '[Гражданская заметка]' )
    panel.noteType:AddChoice( '[Заметка]' )

    panel.noteType:SetValue( "[Заметка]" )

    panel.noteType.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(30, 30, 30), Color(0, 0, 0) )
    end;

    --[[ ]]

    for k, v in pairs(information.logs or {}) do
        AddLogNotification(scrollList, v.time, v.type, v.text)
    end;

    --[[ ]]

    local backToCitizens = panel.CharPNL:Add( "DButton" )
	backToCitizens:SetText( 'Вернуться <' )
    backToCitizens:SetPos(115, 530)
    backToCitizens:SetSize(100, 20)
    backToCitizens:SetContentAlignment( 5 )

    backToCitizens.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;

    addNote.DoClick = function(btn)
        local TimeString = ix.date.GetFormatted("%H:%M:%S - %d/%m/%Y", ix.date.Get())
        -- AddLogNotification(scrollList, TimeString, panel.noteType:GetValue(), NotificationEntry:GetText())

        netstream.Start('LogCharacterADD', identificator, information.name, TimeString, panel.noteType:GetValue(), NotificationEntry:GetText())
    end;

    backToCitizens.DoClick = function(s)
        panel.nameLabel:Remove();
        panel.status:Remove();
        panel.authorized:Remove();
        panel.idcard:Remove();
        panel.warned:Remove();
        panel.lastSeen:Remove();
        NotificationEntry:Remove()
        panel.NotesList:Remove();
        panel.citizenStatus:Remove()
        panel.noteType:Remove()

        addNote:Remove()
        RegisterCard:Remove()
        WarnedRegister:Remove()
        RefreshLastSeen:Remove()
        RefreshLastSeen:Remove()
        SetClass:Remove()

        panel.playerslist:SetVisible(true);

        s:Remove();
    end;
end;

local function OpenCitizensList(panel, options, list)

    local pnlW, pnlH = panel:GetSize();
    local ListOfPlayers = {}

    panel.CharPNL = panel:Add('Panel')
    panel.CharPNL:Dock(FILL)
    panel.CharPNL.Paint = function(s, w, h)
    end;

    panel.playerslist = panel.CharPNL:Add('DScrollPanel')
    panel.playerslist:SetPos(10, 10)
    panel.playerslist:SetSize(pnlW - 20, pnlH - 100)
    panel.playerslist.Paint = function(s, w, h) end;

    for i, v in pairs( list ) do
        local ply = panel.playerslist:Add( "DButton" )
        ply:SetText( v.name )
        ply:Dock( TOP )
        ply:DockMargin( 0, 0, 0, 5 )

        ply.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;

        ply.DoClick = function(s)
            panel.playerslist:SetVisible(false);

            OpenCitizenInformation(panel, list[i], i)
        end;

        ListOfPlayers[#ListOfPlayers + 1] = v;
    end

    local backButton = panel.CharPNL:Add( "DButton" )
	backButton:SetText( 'Назад' )
    backButton:SetPos(10, 530)
    backButton:SetSize(100, 20)
    backButton:SetContentAlignment( 5 )

    backButton.Paint = function(btn, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
    end;
    backButton.DoClick = function(s)

        if IsValid(panel.nameLabel) then panel.nameLabel:Remove() end;
        if IsValid(panel.status) then panel.status:Remove() end;
        if IsValid(panel.authorized) then panel.authorized:Remove() end;
        if IsValid(panel.idcard) then panel.idcard:Remove() end;
        if IsValid(panel.warned) then panel.warned:Remove() end;
        if IsValid(panel.lastSeen) then panel.lastSeen:Remove() end;
        if IsValid(NotificationEntry) then NotificationEntry:Remove() end;

        panel.CharPNL:Remove();
        options:SetEnabled(true)
        options:SetAlpha(255)

    end;


end;

function PANEL:Populate(characterList, messagesChat)
    local pnlW, pnlH = self:GetSize();

    local increment = 0;
    local buttonsList = {};
    local choosenOption = "";

    self.filePanel = self:Add('Panel')
    self.filePanel:SetPos(3, 3)
    self.filePanel:SetSize(pnlW - 7, pnlH - 7)
    self.filePanel.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 255) )
        if self.optionsList:IsEnabled() then
            if input.IsKeyDown( KEY_PAGEUP ) && AllowedByCooldown() then
                increment = math.Clamp(increment - 1, 1, 3)
                choosenOption = buttonsList[increment]
            elseif input.IsKeyDown( KEY_PAGEDOWN ) && AllowedByCooldown() then
                increment = math.Clamp(increment + 1, 1, 3)
                choosenOption = buttonsList[increment]
            elseif input.IsKeyDown( KEY_ENTER ) && AllowedByCooldown() then
                choosenOption.DoClick(choosenOption)
            end;
        end;
    end;

    pnlW, pnlH = self.filePanel:GetSize();

    self.optionsList = self.filePanel:Add('DScrollPanel')
    self.optionsList:SetPos(10, 10)
    self.optionsList:SetSize(pnlW - 20, pnlH - 20)
    self.optionsList.Paint = function(s, w, h) end;

    local chatButton = self.optionsList:Add( "DButton" )
	chatButton:SetText( 'Открыть чат' )
    chatButton:DockMargin( 0, 0, 0, 5 )
	chatButton:Dock( TOP )
    chatButton:SetColor( Color(255, 255, 255) )
    chatButton.Paint = function(s, w, h)
        if choosenOption == s or s:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
    end;
    buttonsList[#buttonsList + 1] = chatButton

    local characterButton = self.optionsList:Add( "DButton" )
	characterButton:SetText( 'Информация о жителях' )
	characterButton:Dock( TOP )
    characterButton:DockMargin( 0, 0, 0, 5 )
    characterButton:SetColor( Color(255, 255, 255) )
    characterButton.Paint = function(s, w, h)
        if choosenOption == s or s:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
    end;
    buttonsList[#buttonsList + 1] = characterButton

    local closeButton = self.optionsList:Add( "DButton" )
	closeButton:SetText( 'ВЫХОД' )
	closeButton:Dock( TOP )
    closeButton:DockMargin( 0, 0, 0, 5 )
    closeButton:SetColor( Color(255, 255, 255) )
    closeButton.Paint = function(s, w, h)
        if choosenOption == s or s:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
    end;
    buttonsList[#buttonsList + 1] = closeButton

    choosenOption = buttonsList[increment];

    chatButton.DoClick = function(btn)
        self.optionsList:SetEnabled(false)
        self.optionsList:SetAlpha(0)
        CreateUnitChat(self.filePanel, self.optionsList, messagesChat)
    end;

    characterButton.DoClick = function(btn)
        self.optionsList:SetEnabled(false)
        self.optionsList:SetAlpha(0)

        OpenCitizensList(self.filePanel, self.optionsList, characterList)
    end;

    closeButton.DoClick = function(btn)
        self:Close()
    end;
end;

vgui.Register( "CombinePDA", PANEL, "DFrame" )
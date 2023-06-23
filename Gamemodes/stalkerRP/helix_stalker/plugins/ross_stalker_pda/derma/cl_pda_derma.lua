local PLUGIN = PLUGIN
local pda_body = Material( "materials/textures/pda.png" )
local sizePanel = Material( "materials/textures/menu_hud_back.png" )
local panelBackGround = Material( "materials/textures/menu_hud_attributes.png" )

local PANEL = {};

function PANEL:Init()

    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw = ScrW()
    local sh = ScrH()

	self:SetPos(sw * 0.25, sh * 0.2) 
    self:SetSize( sw * 0.5, sh * 0.6 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(id)
	local sw = ScrW()
	local sh = ScrH()
	local pnl = self;
	local storedPassword = ''
	self.screen = self:Add('Panel')
	self.screen:SetPos(sw * 0.0485, sh * 0.068)
	self.screen:SetSize(sw * 0.381, sh * 0.46)
	self.screen.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	self.passwordInsert = self.screen:Add('DTextEntry')
	self.passwordInsert:SetPos(260, 210)
	self.passwordInsert:SetSize(200, 40)
	self.passwordInsert:SetUpdateOnType(true)
	self.passwordInsert:SetFont('StalkerGraffitiFont')
	self.passwordInsert.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(38, 60, 28, 100))
		self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
	end;
	self.passwordInsert.OnValueChange = function(pnl, text)
		storedPassword = text;
	end;

	self.passwordInfoLabel = self.screen:Add('DLabel')
	self.passwordInfoLabel:SetPos(300, 180)
	self.passwordInfoLabel:SetSize(340, 40)
	self.passwordInfoLabel:SetFont('StalkerGraffitiFont')
	self.passwordInfoLabel:SetText('Введите пароль')

	self.passwordAccept = self.screen:Add('DButton')
	self.passwordAccept:SetPos(310, 260)
	self.passwordAccept:SetSize(100, 20)
	self.passwordAccept:SetText('Принять')
	self.passwordAccept:SetFont('StalkerGraffitiFont')
	self.passwordAccept.Paint = function(self, w, h) 
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
		if self:IsHovered() then
			self:SetTextColor(Color(100, 100, 255))
		else
			self:SetTextColor(Color(232, 187, 8))
		end;
	end;
	self.passwordAccept.DoClick = function()
		local pda = HasHisOwnPDA(LocalPlayer(), storedPassword, id)
		local look = IsLookingOnPDA(LocalPlayer(), password, id)
		if !pda && !look then
			self.passwordInfoLabel:SetPos(230, 180)
			self.passwordInfoLabel:SetText('Вы ввели неправильный пароль!')
			self.passwordInfoLabel:SetTextColor( Color(255, 100, 100) )
		else
			if pda then
				netstream.Start("PDACheck_password_step", storedPassword, pda:GetData("messageID"))
				return;
			end;
			if look then
				netstream.Start("PDACheck_password_step", storedPassword, look:GetNetVar("data").messageID)
			end;
		end;
	end;

	self.lowerPDA = self.screen:Add('DButton')
	self.lowerPDA:SetPos(285, 290)
	self.lowerPDA:SetSize(150, 20)
	self.lowerPDA:SetText('Опустить ПДА')
	self.lowerPDA:SetFont('StalkerGraffitiFont')
	self.lowerPDA.Paint = function(self, w, h) 
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
		if self:IsHovered() then
			self:SetTextColor(Color(100, 100, 255))
		else
			self:SetTextColor(Color(232, 187, 8))
		end;
	end;

	self.lowerPDA.DoClick = function()
		pnl:Close(true)
	end;
end;

function PANEL:Paint(w, h)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( pda_body )
	surface.DrawTexturedRect( 0, 0, w, h )
	
	self:CloseOnMinus()
end;

function PANEL:Close(withanim)
	local posX,  posY = self:GetPos()
	local sw, sh = ScrW(), ScrH();
	if !withanim then
			self:SetVisible(false); self:Remove();
			gui.EnableScreenClicker(false);
		return;
	end;
		
	if !self.closing then
		self.closing = true;
		self:MoveTo(posX, sh * 1.1, 0.5, 0, -1, function()
			self:SetVisible(false); self:Remove();
    		gui.EnableScreenClicker(false);
		end);
	end;
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

vgui.Register( "STALKER_OpenPDA", PANEL, "DFrame" )
------------------------------------------------------------------------!!!!!!!
local PANEL = {}

function PANEL:AddTaskInfo(InfoQuest)
    local sw, sh = ScrW(), ScrH()
    local q_id = InfoQuest["quid"];

    local quest = self.scrollAnwsers:Add("Panel")
    quest:Dock(TOP)
    quest:SetSize(0, 60)
    quest:DockMargin(5, 5, 5, 5)     
    quest.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
    end;
    quest.Material = quest:Add( "DImage" )
    quest.Material:SetSize(50, 50)
    quest.Material:SetPos( 5, 5 )
    quest.Material:DockMargin( 10, 10, 10, 10 )
    if InfoQuest.type == "Собирательство" then
        quest.Material:SetImage("materials/icons/notice_food.png")
    else
        quest.Material:SetImage("materials/icons/notice_mutant.png")
    end;

    quest.Label = quest:Add( "DLabel" )
    quest.Label:SetSize(350, 50)
    quest.Label:SetFont("StalkerFont")
    quest.Label:SetPos( 60, 5 )
    quest.Label:SetText("Задача: "..InfoQuest.type)

    local needtable, rewardTable, name = {}, {}, nil;

    for k, v in pairs(InfoQuest['needToDo']) do 
        if InfoQuest.type == "Собирательство" then
            name = ix.item.list[k].name
        else
            name = k;
        end;
        table.insert(needtable, "\n"..name..' ['..v..' шт.]') 
    end;
    for k, v in pairs(InfoQuest['rewardToGet']) do 
        if InfoQuest.type == "Собирательство" then
            name = ix.item.list[k].name 
        else
            name = k;
        end;
        table.insert(rewardTable, "\n"..name..' ['..v..' шт.]') 
    end;

    local NeedString = table.concat( needtable, ', ' );
    local RewardString = table.concat( rewardTable, ', ' )
    if NeedString == nil or NeedString == "" then
        NeedString = "Ничего не нужно."
    end;
    if RewardString == nil or RewardString == "" then
        RewardString = "Ничего нет."
    end;

    quest.Material:SetHelixTooltip(function(tooltip)
		local client = LocalPlayer()

		if (IsValid(self) and IsValid(client)) then
            local t1 = tooltip:AddRow("needString")
            t1:SetText("Нужно: "..NeedString) 
            t1:SetFont("StalkerGraffitiFontLittle")
            t1:SizeToContents()
            local t2 = tooltip:AddRow("rewardString")
            t2:SetText("Награда: "..RewardString) 
            t2:SetFont("StalkerGraffitiFontLittle")
            t2:SizeToContents()
            local t3 = tooltip:AddRow("rewardString")
            t3:SetText("Деньги: "..InfoQuest['rewardTokens'].." рублей.") 
            t3:SetFont("StalkerGraffitiFontLittle")
            t3:SizeToContents()
		end
	end)
end;

local function GetReputationInfo(number)
	if number > 256 then
		return "Отлично", Color(100, 255, 100)
	elseif number > 128 then
		return "Очень хорошо", Color(100, 150, 100)
	elseif number > 64 then
		return "Хорошо", Color(177, 170, 73)
	elseif number >= 0 then
		return "Нейтрал", Color(170, 170, 170)
	elseif number < 0 then
		return "Плохо", Color(99, 52, 55)
	elseif number < -64 then
		return "Очень плохо", Color(99, 52, 55)
	elseif number < -135 then
		return "Ужасно", Color(99, 52, 55)
	end;

	return "???"
end;

local function GetRankInfo(number)

	if number > 1024 then
		return "Легенда", Color(235, 230, 33)
	elseif number > 512 then
		return "Профессионал", Color(36, 129, 232)
	elseif number > 256 then
		return "Ветеран", Color(192, 95, 48)
	elseif number > 128 then
		return "Опытный", Color(0, 128, 128)
	elseif number > 64 then
		return "Начинающий", Color(121, 83, 98)
	elseif number >= 0 then
		return "Новичек", Color(170, 170, 170)
	end;

	return "???"
end;

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw = ScrW()
    local sh = ScrH()
	self:SetPos(sw * 0.25, sh * 0.2) 
    self:SetSize( sw * 0.5, sh * 0.6 )
    self:ShowCloseButton( false )
    self:SetTitle('')
	self:MakePopup()
	PLUGIN.pdaDerma:Close();
    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(messages, id, pins, web, nots)
	local sw, sh = ScrW(), ScrH()
	local pnl = self;
	self.pdaPages = {};

	local buttonInfo = {
		"Задачи",
		"Лидеры",
		"Уведомления",
		"Сеть",
		"Почта",
		"Заметки",
		"Настройки"
	}
	self.screen = self:Add('Panel')
	self.screen:SetPos(sw * 0.0485, sh * 0.068)
	self.screen:SetSize(sw * 0.381, sh * 0.46)
	self.screen.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	self.lowerscreen = self:Add('Panel')
	self.lowerscreen:SetPos(sw * 0.0485, sh * 0.5)
	self.lowerscreen:SetSize(sw * 0.381, sh * 0.03)
	self.lowerscreen.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
	end;
	self.lowerPDA = self.lowerscreen:Add('DButton')
	self.lowerPDA:SetPos(560, 5)
	self.lowerPDA:SetSize(150, 20)
	self.lowerPDA:SetText('Опустить ПДА')
	self.lowerPDA:SetFont('StalkerGraffitiFont')
	self.lowerPDA.Paint = function(self, w, h) 
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 100))
		if self:IsHovered() then
			self:SetTextColor(Color(100, 100, 255))
		else
			self:SetTextColor(Color(232, 187, 8))
		end;
	end;

	self.lowerPDA.DoClick = function()
		pnl:Close(true)
	end;

	self.infoscroller = self.screen:Add( "DHorizontalScroller" )
	self.infoscroller:SetPos(0, 0)
	self.infoscroller:SetSize(sw * 0.381, 35)
	self.infoscroller:SetOverlap( -4 )
	self.infoscroller.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 255))
	end;

	for k, v in pairs(buttonInfo) do
		local btnInfo = vgui.Create( "DButton", self.infoscroller )
		btnInfo:SetText(v)
		btnInfo:SetSize(110, 0)
		btnInfo:SetFont('StalkerGraffitiFont')
		btnInfo.Paint = function(self, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( sizePanel )
			surface.DrawTexturedRect( 0, 0, w, h )
			if self:IsHovered() then
				self:SetTextColor(Color(100, 100, 255))
			else
				self:SetTextColor(Color(232, 187, 8))
			end;
		end;
		btnInfo.DoClick = function()
			if self.pdaPages[v] then
				self.pdaPages[v]:SetVisible(true);
			else
				return;
			end;
			for info, pages in pairs(self.pdaPages) do
				if info != v then
					pages:SetVisible(false)
				end;
			end;
		end;
		self.infoscroller:AddPanel( btnInfo )
	end;

	--[[ Quests ]]--
	self.questsScreen = self.screen:Add("DScrollPanel")
	self.questsScreen:SetVisible(false);
	self.questsScreen.insertID = "Задачи"
	self.questsScreen:SetPos(5, 40)
	self.questsScreen:SetSize( 720, 425 )
	self.questsScreen.Paint = function(self, w, h) 
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	
	for index, quest in pairs(LocalPlayer():GetLocalVar('QuestList')) do
		self:AddTaskInfo(quest)
	end;
	--[[ Quests ]]--

	--[[ Leader list ]]--

	self.leaderscreen = self.screen:Add("Panel")
	self.leaderscreen:SetVisible(false);
	self.leaderscreen.insertID = "Лидеры"
	self.leaderscreen:SetPos(5, 40)
	self.leaderscreen:SetSize( 720, 425 )
	self.leaderscreen.Paint = function(self, w, h) end;

	self.leaderList = self.leaderscreen:Add("DScrollPanel")
	self.leaderList:SetSize( 720, 290 )
	self.leaderList.Paint = function(self, w, h) 
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;

	self.selfInfo = self.leaderscreen:Add("Panel")
	self.selfInfo:SetPos(0, 300)
	self.selfInfo:SetSize( 720, 140 )
	self.selfInfo.Paint = function(self, w, h) 
		local reptext, repclr = GetReputationInfo(LocalPlayer():GetLocalVar('reputation'));
		local izvtext, izvclr = GetRankInfo(LocalPlayer():GetLocalVar('rank'))
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		draw.SimpleText( "Имя: "..LocalPlayer():GetCharacter():GetName(), "StalkerGraffitiFontLittle", 145, 5, Color(232, 187, 8), TEXT_ALIGN_LEFT )
		draw.SimpleText( "Группировка: "..team.GetName(LocalPlayer():GetCharacter():GetFaction()), "StalkerGraffitiFontLittle", 145, 20, Color(255, 255, 255), TEXT_ALIGN_LEFT )
		draw.SimpleText( "Репутация: "..reptext, "StalkerGraffitiFontLittle", 145, 35, repclr, TEXT_ALIGN_LEFT )
		draw.SimpleText( "Известность: "..izvtext, "StalkerGraffitiFontLittle", 145, 50, izvclr, TEXT_ALIGN_LEFT )
	end;
	self.playerstalker = self.selfInfo:Add( "Panel" )
	self.playerstalker:Dock( TOP )
	self.playerstalker:SetSize(0, 140)
	self.playerstalker:DockMargin( 10, 10, 10, 10 )
	self.playerstalker.Paint = function(s, w, h)
	end;
	self.modelInfoStalker = self.playerstalker:Add( "DImage" )
	self.modelInfoStalker:SetSize(125, 110)
	self.modelInfoStalker:DockMargin( 10, 10, 10, 10 )
	self.modelInfoStalker:SetImage("materials/icons/n_unknown.png")

	local playerAll = player.GetAll()
	table.sort(playerAll, function(a, b)
		return a:GetLocalVar('reputation', 0) > b:GetLocalVar('reputation', 0)
	end)
	for k, v in pairs(playerAll) do
		
		if v:GetLocalVar('reputation', 0) >= 250 && v != LocalPlayer() then
			local stalker = self.leaderscreen:Add( "Panel" )
			stalker:Dock( TOP )
			stalker:SetSize(0, 65)
			stalker:DockMargin( 10, 10, 10, 10 )
			stalker.Paint = function(s, w, h)
			end;
			if !character:DoesRecognize(v) then
				local stalkerModel = stalker:Add( "DImage" )
				stalkerModel:SetSize(75, 65)
				stalkerModel:DockMargin( 10, 10, 10, 10 )
				stalkerModel:SetImage("materials/icons/n_unknown.png")
			end;
		end;
	end;

	--[[ Leader list ]]--

	--[[ Notifications ]]--

	self.notificationsScreen = self.screen:Add("DScrollPanel")
	self.notificationsScreen:SetVisible(false);
	self.notificationsScreen.insertID = "Уведомления"
	self.notificationsScreen:SetPos(5, 40)
	self.notificationsScreen:SetSize( 720, 425 )
	self.notificationsScreen.Paint = function(self, w, h) 
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	for k, v in pairs(nots) do
		local notification = self.notificationsScreen:Add( "Panel" )
		notification:Dock( TOP )
		notification:DockMargin( 5, 5, 5, 5 )
		notification:SetSize(0, 100)
		notification.Paint = function(self, w, h)
		  draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		end;
		local notificationImg = notification:Add("DImage")
		notificationImg:SetPos(10, 10)
		notificationImg:SetImage(v[1])
		notificationImg:SetSize(80, 80)
		local messageText = notification:Add("DLabel")
		messageText:SetPos(100, 10)
		messageText:SetFont("StalkerGraffitiFontLittle")
		messageText:SetSize( 605, 80 )
		messageText:SetText(v[2])
		messageText:SetContentAlignment( 7 )
		messageText:SetWrap(true)
	end;
	--[[ Notifications ]]--

	--[[ STALKER_WEB ]]--

	self.stalker_web = self.screen:Add("Panel")
	self.stalker_web:SetVisible(false);
	self.stalker_web.insertID = "Сеть"
	self.stalker_web:SetPos(5, 40)
	self.stalker_web:SetSize( 720, 425 )
	self.stalker_web.Paint = function(self, w, h) end;

	self.stalker_messages = self.stalker_web:Add("DScrollPanel")
	self.stalker_messages:SetSize( 720, 290 )
	self.stalker_messages.Paint = function(self, w, h) 
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;

	for k, v in pairs(web) do
		local attachmessageWEB = self.stalker_messages:Add( "Panel" )
		attachmessageWEB:Dock( TOP )
		attachmessageWEB:DockMargin( 5, 5, 5, 5 )
		attachmessageWEB:SetSize(0, 100)
		attachmessageWEB.Paint = function(self, w, h)
		  draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		  draw.SimpleText( v.whois, "StalkerGraffitiFontLittle", 10, 10, Color(232, 187, 8), TEXT_ALIGN_LEFT )
		  draw.SimpleText( v.faction, "StalkerGraffitiFontLittle", 15, 25, Color(232, 187, 8), TEXT_ALIGN_LEFT )
		end;
		local messageText = attachmessageWEB:Add("DLabel")
		messageText:SetPos(100, 5)
		messageText:SetFont("StalkerGraffitiFont")
		messageText:SetContentAlignment( 7 )
		messageText:SetSize( 605, 90 )
		messageText:SetText(v.message)
		messageText:SetWrap(true)
  
		self.stalker_messages:Rebuild()
	end;

	self.sendMessagePNL = self.stalker_web:Add("Panel")
	self.sendMessagePNL:SetPos(0, 300)
	self.sendMessagePNL:SetSize( 720, 120 )
	self.sendMessagePNL.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		draw.SimpleText( LocalPlayer():GetName(), "StalkerGraffitiFontLittle", 45, 10, Color(232, 187, 8), TEXT_ALIGN_LEFT )
        draw.SimpleText( team.GetName(LocalPlayer():GetCharacter():GetFaction()), "StalkerGraffitiFontLittle", 55, 25, Color(232, 187, 8), TEXT_ALIGN_LEFT )
	end;
	self.messagePlaceholder = self.sendMessagePNL:Add("DTextEntry")
	self.messagePlaceholder:SetPos(200, 5)
	self.messagePlaceholder:SetMultiline(true)
	self.messagePlaceholder:SetSize( 515, 80 )
	self.messagePlaceholder:SetPlaceholderText( "Введите сообщение" )
	self.messagePlaceholder.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )

		if self:GetPlaceholderText() != "" && self:GetText() == "" then
			draw.SimpleText( self:GetPlaceholderText(), "StalkerGraffitiFontLittle", 5, 5, Color(232, 187, 8, 100), TEXT_ALIGN_LEFT )
		end;
	end;
	self.sendMessageBTN = self.sendMessagePNL:Add( "DButton" )
	self.sendMessageBTN:SetText( "Отправить сообщение" )
	self.sendMessageBTN:SetPos(200, 90)
	self.sendMessageBTN:SetSize(515, 25)
	self.sendMessageBTN.DoClick = function()
		if string.len(self.messagePlaceholder:GetValue()) > 5 then
			netstream.Start("PDA_message", self.messagePlaceholder:GetText(), LocalPlayer():GetName(), team.GetName(LocalPlayer():GetCharacter():GetFaction()), id)
		end;
	end;	

	--[[ STALKER_WEB ]]--

	--[[ Messages ]]--
	self.messagesScreen = self.screen:Add("Panel")
	self.messagesScreen:SetVisible(false);
	self.messagesScreen.insertID = "Почта"
	self.messagesScreen:SetPos(5, 40)
	self.messagesScreen:SetSize( 720, 425 )
	self.messagesScreen.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	self.messages = self.messagesScreen:Add("DScrollPanel")
	self.messages:SetPos(0, 0)
	self.messages:SetSize( 200, 385 )
	self.messages.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;

	self.messageInfo = self.messagesScreen:Add("Panel")
	self.messageInfo:SetPos(205, 0)
	self.messageInfo:SetSize( 515, 425 )
	self.messageInfo.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	local messageInfoX, messageInfoY = self.messageInfo:GetSize();

	self.messageTitle = self.messageInfo:Add("DLabel")
	self.messageTitle:SetPos(10, 10)
	self.messageTitle:SetFont("StalkerGraffitiFont")
	self.messageTitle:SetSize( messageInfoX - 20, 25 )
	self.messageTitle:SetVisible(false);
	self.messageTitle.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	self.messageSender = self.messageInfo:Add("DLabel")
	self.messageSender:SetPos(10, 40)
	self.messageSender:SetFont("StalkerGraffitiFont")
	self.messageSender:SetSize( messageInfoX - 20, 25 )
	self.messageSender:SetVisible(false);
	self.messageSender.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;

	self.messageText = self.messageInfo:Add("DLabel")
	self.messageText:SetPos(10, 70)
	self.messageText:SetFont("StalkerGraffitiFont")
	self.messageText:SetContentAlignment( 7 )
	self.messageText:SetSize( messageInfoX - 20, messageInfoY - 100 )
	self.messageText:SetVisible(false);
	self.messageText:SetWrap(true)
	self.messageText.Paint = function(self, w, h) end;

	for k, v in pairs(messages) do
		local messageInbox = self.messages:Add( "DButton" )
		messageInbox:SetText( v.title )
		messageInbox:Dock( TOP )
		messageInbox:DockMargin( 5, 5, 5, 5 )
		messageInbox.DoClick = function()
			self.messageTitle:SetVisible(true);
			self.messageText:SetVisible(true);
			self.messageSender:SetVisible(true);
			self.messageTitle:SetText("Тема: "..v.title)
			self.messageSender:SetText("От: "..v.who)
			self.messageText:SetText(v.text)
		end;
	end;

	--[[ Send message ]]--
	self.messageSendPNL = self.messagesScreen:Add("Panel")
	self.messageSendPNL:SetPos(0, 430)
	self.messageSendPNL:SetSize( 720, 425 )
	self.messageSendPNL.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	self.messageSendTitle = self.messageSendPNL:Add("DTextEntry")
	self.messageSendTitle:SetPos(10, 10)
	self.messageSendTitle:SetSize( 700, 30 )
	self.messageSendTitle:SetPlaceholderText('Заголовок темы письма')
	self.messageSendTitle.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		if self:GetPlaceholderText() != "" && self:GetText() == "" then
			draw.SimpleText( self:GetPlaceholderText(), "StalkerGraffitiFontLittle", 5, 5, Color(232, 187, 8, 100), TEXT_ALIGN_LEFT )
		end;
	end;
	self.messageSendWho = self.messageSendPNL:Add("DTextEntry")
	self.messageSendWho:SetPos(10, 50)
	self.messageSendWho:SetSize( 700, 30 )
	self.messageSendWho:SetPlaceholderText('ID ПДА куда отправить.')
	self.messageSendWho.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		if self:GetPlaceholderText() != "" && self:GetText() == "" then
			draw.SimpleText( self:GetPlaceholderText(), "StalkerGraffitiFontLittle", 5, 5, Color(232, 187, 8, 100), TEXT_ALIGN_LEFT )
		end;
	end;
	self.messageSendText = self.messageSendPNL:Add("DTextEntry")
	self.messageSendText:SetPos(10, 90)
	self.messageSendText:SetMultiline(true)
	self.messageSendText:SetPlaceholderText('Текст')
	self.messageSendText:SetSize( 700, 200 )
	self.messageSendText.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
		if self:GetPlaceholderText() != "" && self:GetText() == "" then
			draw.SimpleText( self:GetPlaceholderText(), "StalkerGraffitiFontLittle", 5, 5, Color(232, 187, 8, 100), TEXT_ALIGN_LEFT )
		end;
	end;

	self.SendDoneMessage = self.messageSendPNL:Add("DButton")
	self.SendDoneMessage:SetPos(510, 295)
	self.SendDoneMessage:SetText("Отправить сообщение")
	self.SendDoneMessage:SetSize( 200, 40 )
	self.SendDoneMessage.DoClick = function()
		if self.messageSendTitle:GetValue() != "" && self.messageSendWho:GetValue() != "" && self.messageSendText:GetValue() != "" then
			netstream.Start("PDA_sendmessage", self.messageSendTitle:GetValue(), self.messageSendWho:GetValue(), self.messageSendText:GetValue())
		end;
	end;
	self.SendDoneMessage.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	--[[ Send message ]]--

	self.SendMessage = self.messagesScreen:Add("DButton")
	self.SendMessage:SetPos(0, 390)
	self.SendMessage:SetText("Отправить сообщение")
	self.SendMessage:SetSize( 200, 40 )
	self.SendMessage.DoClick = function()
		if self.slidedTime && CurTime() < self.slidedTime then
			return;
		end;

		if !self.messageSendPNL.slided then
			self.SendMessage:SetText('Закрыть')
			self.slidedTime = CurTime() + 1
			self.messageSendPNL.slided = true;
			self.messageSendPNL:MoveTo(0, 0, 0.5, 0, -1)
		else
			self.SendMessage:SetText('Отправить сообщение')
			self.slidedTime = CurTime() + 1
			self.messageSendPNL.slided = nil;
			self.messageSendPNL:MoveTo(0, 430, 0.5, 0, -1)
		end;
	end;
	self.SendMessage.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;
	--[[ Messages ]]--

	--[[ Settings ]]--
	self.settingsPanel = self.screen:Add("Panel")
	self.settingsPanel:SetVisible(false);
	self.settingsPanel.insertID = "Настройки"
	self.settingsPanel:SetPos(5, 40)
	self.settingsPanel:SetSize( 720, 425 )
	self.settingsPanel.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	self.pdaInfoNumber = self.settingsPanel:Add("DLabel")
	self.pdaInfoNumber:SetPos(5, 5)
	self.pdaInfoNumber:SetText("Ваш идентификатор: "..id.." - нужен для отправки вам сообщений.")
	self.pdaInfoNumber:SetFont("StalkerGraffitiFont")
	self.pdaInfoNumber:SizeToContents()
	self.pdaInfoNumber.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;
	self.copy = self.settingsPanel:Add( "DButton" )
	self.copy:SetText( "COPY" )
	self.copy:SetPos(5, 30)
	self.copy:SetSize(45, 25)
	self.copy.DoClick = function()
		surface.PlaySound('helix/ui/press.wav')
		SetClipboardText(id)
	end;

	self.passwordUnderPanel = self.settingsPanel:Add("DPanel")
	self.passwordUnderPanel:SetPos(5, 55)
	self.passwordUnderPanel:SetSize(210, 55)
	self.passwordUnderPanel.Paint = function(self, w, h)
		draw.SimpleText( "ВВЕДИТЕ ПАРОЛЬ ДЛЯ СМЕНЫ", "StalkerGraffitiFontLittle", 0, 0, color_white, TEXT_ALIGN_LEFT )
	end;

	self.passwordChange = self.passwordUnderPanel:Add("DTextEntry")
	self.passwordChange:SetPos(0, 20)
	self.passwordChange:SetSize( 210, 25 )
	self.passwordChange:SetUpdateOnType( true )
	self.passwordChange.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	self.passwordChange.AllowInput = function( self, v )
		if self:GetText():len() >= 10 then
			return true;
		end;
	end;
	self.passwordChange.OnEnter = function()
		local pda = HasHisOwnPDA(LocalPlayer(), false, id)
		local look = IsLookingOnPDA(LocalPlayer(), false, id)
		if pda or look then
			netstream.Start("PDA_changepassword", self.passwordChange:GetValue(), id)
			self.passwordChange:SetText('')
		end;
	end;

	--[[ Pins ]]--

	self.pinsPNL = self.screen:Add("Panel")
	self.pinsPNL:SetVisible(false);
	self.pinsPNL.insertID = "Заметки"
	self.pinsPNL:SetPos(5, 40)
	self.pinsPNL:SetSize( 720, 425 )
	self.pinsPNL.Paint = function(self, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 100))
	end;

	self.pinshere = self.pinsPNL:Add("DScrollPanel")
	self.pinshere:SetPos(0, 0)
	self.pinshere:SetSize( 200, 385 )
	self.pinshere.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;

	for k, v in pairs(pins) do
		local pin = self.pinshere:Add( "DButton" )
		pin:SetText( "Заметка" )
		pin:Dock( TOP )
		pin.BufferedText = v;
		pin.tableindex = k;
		pin:DockMargin( 5, 5, 5, 5 )
		pin.DoClick = function(pnl)
			if self.pinshere.SetActivePin then
				self.pinshere.SetActivePin:SetTextColor(color_white)
			end;
			pnl:SetTextColor(Color(100, 255, 100))
			self.pinshere.SetActivePin = pnl;
			self.pinText:SetText(pnl.BufferedText)
		end;
	end;

	self.pinsInfo = self.pinsPNL:Add("Panel")
	self.pinsInfo:SetPos(205, 0)
	self.pinsInfo:SetSize( 515, 425 )
	self.pinsInfo.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	self.pinText = self.pinsInfo:Add("DTextEntry")
	self.pinText:SetPos(10, 10)
	self.pinText:SetSize( 500, 350 )
	self.pinText:SetMultiline(true)
	self.pinText.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255) )
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
	end;
	self.pinText.AllowInput = function( self, v )
		if self:GetText():len() >= 1000 then
			return true;
		end;
	end;

	self.editpin = self.pinsInfo:Add( "DButton" )
	self.editpin:SetText( "РЕДАКТИРОВАТЬ" )
	self.editpin:SetPos(10, 370)
	self.editpin:SetSize(100, 35)
	self.editpin.DoClick = function()
		if self.pinshere.SetActivePin then
			self.pinshere.SetActivePin.BufferedText = self.pinText:GetText()
			netstream.Start("PDA_EditPin", self.pinshere.SetActivePin.BufferedText, self.pinshere.SetActivePin.tableindex, id)
		end;
	end;
	self.delpin = self.pinsInfo:Add( "DButton" )
	self.delpin:SetText( "УДАЛИТЬ" )
	self.delpin:SetPos(130, 370)
	self.delpin:SetSize(75, 35)
	self.delpin.DoClick = function()
		if self.pinshere.SetActivePin then
			netstream.Start("PDA_DeletePin", self.pinshere.SetActivePin.tableindex, id)
			pins[self.pinshere.SetActivePin.tableindex] = nil;
			self.pinshere.SetActivePin:Remove();
			self.pinshere.SetActivePin = nil;
		end;
	end;	
	
	self.sendPin = self.pinsPNL:Add( "DButton" )
	self.sendPin:SetText( "Добавить заметку" )
	self.sendPin:SetPos(0, 390)
	self.sendPin:SetSize(200, 35)
	self.sendPin.DoClick = function()
		if table.Count(pins) > 15 then
			return false;
		end;
		
		table.insert(pins, self.pinText:GetText());
		netstream.Start("PDA_AddPin", self.pinText:GetText(), id)
		local pin = self.pinshere:Add( "DButton" )
		pin:SetText( "Заметка" )
		pin:Dock( TOP )
		pin.tableindex = #pins + 1;
		pin.BufferedText = self.pinText:GetText();
		pin:DockMargin( 5, 5, 5, 5 )
		pin.DoClick = function(pnl)
			if self.pinshere.SetActivePin then
				self.pinshere.SetActivePin:SetTextColor(color_white)
			end;
			pnl:SetTextColor(Color(100, 255, 100))
			self.pinText:SetText(pin.BufferedText)
			self.pinshere.SetActivePin = pnl;
		end;
	end;

	--[[ Settings ]]--
	for k, v in pairs(self.screen:GetChildren()) do
		if v.insertID then
			self.pdaPages[v.insertID] = v;
		end;
	end;
end

function PANEL:Paint(w, h)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( pda_body )
	surface.DrawTexturedRect( 0, 0, w, h )
end;

function PANEL:Close(withanim)
	local posX,  posY = self:GetPos()
	local sw, sh = ScrW(), ScrH();
	if !withanim then
			self:SetVisible(false); self:Remove();
			gui.EnableScreenClicker(false);
		return;
	end;
		
	if !self.closing then
		self.closing = true;
		self:MoveTo(posX, sh * 1.1, 0.5, 0, -1, function()
			self:SetVisible(false); self:Remove();
    		gui.EnableScreenClicker(false);
		end);
	end;
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

vgui.Register( "STALKER_OpenPDAInfo", PANEL, "DFrame" )
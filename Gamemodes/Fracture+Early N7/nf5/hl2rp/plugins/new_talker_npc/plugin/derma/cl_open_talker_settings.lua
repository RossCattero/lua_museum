local PLUGIN = PLUGIN;

local PANEL = {};

function PANEL:Init()

    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local pnl = self;

	self:SetPos((scrW/2) - 600, (scrH/2) - 350) 
    self:SetSize( 910, 500 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    self.settingsEntry = vgui.Create( "DTextEntry", self )
	self.settingsEntry:SetPos( 10, 10 )
	self.settingsEntry:SetSize( 500, 40 )
	self.settingsEntry:SetText( "" )
	self.settingsEntry:SetMultiline(true)
    self.settingsEntry:SetPlaceholderText("Текст сообщения.")
    self.settingsEntry.disallowDisable = true;
	self.settingsEntry.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;
    self.settingsType = vgui.Create( "DComboBox", self )
	self.settingsType:SetPos( 515, 10 )
	self.settingsType:SetSize( 70, 15 )
	self.settingsType:SetValue( "" )
	self.settingsType:AddChoice( "Вопрос" )
    self.settingsType:AddChoice( "Ответ" )
    self.settingsType.disallowDisable = true;
    self.settingsType:SetColor(Color(255, 180, 80))
	self.settingsType.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
    end;

    self.settingsType.OnSelect = function( self, index, value )
        if value == 'Вопрос' then
            pnl.CallAnwser:SetDisabled(false);
            pnl.callAnwserIndex:SetDisabled(false);
            pnl.callAnwserButton:SetDisabled(false);      

            pnl.RemoveOnAppear:SetDisabled(false);
            pnl.removeOnAppearIndex:SetDisabled(false);
            pnl.removeOnAppearButton:SetDisabled(false);

            pnl.CallQuestions:SetDisabled(false);
            pnl.callQuestionsIndex:SetDisabled(false);
            pnl.callQuestionsButton:SetDisabled(false);

            pnl.callOnAppear:SetDisabled(true);
            pnl.callOnAppearIndex:SetDisabled(true);
            pnl.callOnAppearButton:SetDisabled(true);

            pnl.checkboxIsDefault:SetDisabled(false)

            pnl.soundToUse:SetDisabled(true);
            pnl.DisallowSellItems:SetDisabled(true);

            pnl.questType:SetDisabled(true);
            pnl.listOfNeeded:SetDisabled(true);
            pnl.listOfNeededIndex:SetDisabled(true);
            pnl.listOfNeededButton:SetDisabled(true);
            pnl.listOfNeededNumber:SetDisabled(true);
            pnl.randomTasks:SetDisabled(true);
            pnl.rewardTask:SetDisabled(true);
            pnl.rewardTaskIndex:SetDisabled(true);
            pnl.rewardTaskButton:SetDisabled(true);
            pnl.rewardTaskNumber:SetDisabled(true);
            pnl.rewardTokens:SetDisabled(true);   
        else
            
            pnl.CallAnwser:SetDisabled(true);
            pnl.callAnwserIndex:SetDisabled(true);
            pnl.callAnwserButton:SetDisabled(true);      

            pnl.RemoveOnAppear:SetDisabled(true);
            pnl.removeOnAppearIndex:SetDisabled(true);
            pnl.removeOnAppearButton:SetDisabled(true);

            pnl.CallQuestions:SetDisabled(true);
            pnl.callQuestionsIndex:SetDisabled(true);
            pnl.callQuestionsButton:SetDisabled(true);

            pnl.callOnAppear:SetDisabled(true);
            pnl.callOnAppearIndex:SetDisabled(true);
            pnl.callOnAppearButton:SetDisabled(true);

            pnl.checkboxIsDefault:SetDisabled(false)
            pnl.soundToUse:SetDisabled(false);
            pnl.DisallowSellItems:SetDisabled(false);

            pnl.questType:SetDisabled(false);
            pnl.listOfNeeded:SetDisabled(false);
            pnl.listOfNeededIndex:SetDisabled(false);
            pnl.listOfNeededButton:SetDisabled(false);
            pnl.randomTasks:SetDisabled(false);
            pnl.rewardTask:SetDisabled(false);
            pnl.listOfNeededNumber:SetDisabled(false);
            pnl.rewardTaskIndex:SetDisabled(false);
            pnl.rewardTaskButton:SetDisabled(false);
            pnl.rewardTaskNumber:SetDisabled(false);
            pnl.rewardTokens:SetDisabled(false);   
        end;
    end
    self.settingsIndex = vgui.Create( "DTextEntry", self )
	self.settingsIndex:SetPos( 515, 30 )
	self.settingsIndex:SetSize( 70, 20 )
	self.settingsIndex:SetText( "" )
	self.settingsIndex:SetMultiline(true)
    self.settingsIndex:SetPlaceholderText("Индекс.")  
    self.settingsIndex.disallowDisable = true;
	self.settingsIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;

    self.checkboxIsDefault = vgui.Create( "DCheckBoxLabel", self )
	self.checkboxIsDefault:SetPos(735, 75)
	self.checkboxIsDefault:SetText( 'Стандартный?' )
    self.checkboxIsDefault:SetValue(false)
    self.checkboxIsDefault.getdef = false;
    function self.checkboxIsDefault:OnChange( val )
        if val then
            self.getdef = true;
            if pnl.settingsType:GetValue() == 'Ответ' then
                pnl.callOnAppear:SetDisabled(false);
                pnl.callOnAppearIndex:SetDisabled(false);
                pnl.callOnAppearButton:SetDisabled(false);       
            end;
        else
            self.getdef = false;
            if pnl.settingsType:GetValue() == 'Ответ' then
                pnl.callOnAppear:SetDisabled(true);
                pnl.callOnAppearIndex:SetDisabled(true);
                pnl.callOnAppearButton:SetDisabled(true);
                pnl.callOnAppearIndex:SetText('');
                pnl.callOnAppear.coap = {};
                pnl.callOnAppear:Clear();
            end;
        end
    end

    self.callOnAppear = vgui.Create( "DListView", self )
	self.callOnAppear:SetPos(15, 75)
    self.callOnAppear:SetSize(150, 200)
	self.callOnAppear:SetMultiSelect( false )
    self.callOnAppear:AddColumn( "Индекс" )
    self.callOnAppear.coap = {};
	self.callOnAppear.OnClickLine = function( p, l, s )				
		self.callOnAppear:ClearSelection()
        self.callOnAppear:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.callOnAppear:GetSelectedLine();
            local lineinfo = self.callOnAppear:GetLine(line);
            table.RemoveByValue(self.callOnAppear.coap, lineinfo.index)
			self.callOnAppear:RemoveLine(line)
            self.callOnAppear:ClearSelection()
        end):SetImage("icon16/cancel.png")
    end;

    self.callOnAppearIndex = vgui.Create( "DTextEntry", self )
	self.callOnAppearIndex:SetPos( 15, 280 )
	self.callOnAppearIndex:SetSize( 80, 20 )
	self.callOnAppearIndex:SetText( "" )
	self.callOnAppearIndex:SetMultiline(true)
	self.callOnAppearIndex:SetPlaceholderText("Индекс")  
	self.callOnAppearIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.callOnAppearButton = vgui.Create("DButton", self)
    self.callOnAppearButton:SetText( '+' )
    self.callOnAppearButton:SetColor(Color(255, 100, 100))
    self.callOnAppearButton:SetPos(100, 280)
    self.callOnAppearButton:SetSize(65, 20)
    function self.callOnAppearButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !table.HasValue(pnl.callOnAppear.coap, pnl.callOnAppearIndex:GetValue()) then
            table.insert(pnl.callOnAppear.coap, pnl.callOnAppearIndex:GetValue());
            local q = pnl.callOnAppear:AddLine(pnl.callOnAppearIndex:GetValue());
            q.index = pnl.callOnAppearIndex:GetValue()
        end;
    end;
    function self.callOnAppearButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;   

    self.CallAnwser = vgui.Create( "DListView", self )
	self.CallAnwser:SetPos(185, 75)
	self.CallAnwser:SetSize(160, 200)
	self.CallAnwser:SetMultiSelect( false )
    self.CallAnwser:AddColumn( "Индекс" )
    self.CallAnwser.cans = {};
	self.CallAnwser.OnClickLine = function( p, l, s )				
		self.CallAnwser:ClearSelection()
        self.CallAnwser:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.CallAnwser:GetSelectedLine();
            local lineinfo = self.CallAnwser:GetLine(line);
            table.RemoveByValue(self.CallAnwser.cans, lineinfo.index)
			self.CallAnwser:RemoveLine(line)
            self.CallAnwser:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;

    self.callAnwserIndex = vgui.Create( "DTextEntry", self )
	self.callAnwserIndex:SetPos( 185, 280 )
	self.callAnwserIndex:SetSize( 80, 20 )
	self.callAnwserIndex:SetText( "" )
	self.callAnwserIndex:SetMultiline(true)
	self.callAnwserIndex:SetPlaceholderText("Индекс")  
	self.callAnwserIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.callAnwserButton = vgui.Create("DButton", self)
    self.callAnwserButton:SetText( '+' )
    self.callAnwserButton:SetColor(Color(255, 100, 100))
    self.callAnwserButton:SetPos(270, 280)
    self.callAnwserButton:SetSize(75, 20)
    function self.callAnwserButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !table.HasValue(pnl.CallAnwser.cans, pnl.callAnwserIndex:GetValue()) then
            table.insert(pnl.CallAnwser.cans, pnl.callAnwserIndex:GetValue());
            local q = pnl.CallAnwser:AddLine(pnl.callAnwserIndex:GetValue());
            q.index = pnl.callAnwserIndex:GetValue()
        end;
    end;
    function self.callAnwserButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;   

    self.RemoveOnAppear = vgui.Create( "DListView", self )
	self.RemoveOnAppear:SetPos(375, 75)
	self.RemoveOnAppear:SetSize(160, 200)
	self.RemoveOnAppear:SetMultiSelect( false )
    self.RemoveOnAppear:AddColumn( "Индекс" )
    self.RemoveOnAppear.remonap = {};
	self.RemoveOnAppear.OnClickLine = function( p, l, s )				
		self.RemoveOnAppear:ClearSelection()
        self.RemoveOnAppear:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.RemoveOnAppear:GetSelectedLine();
            local lineinfo = self.RemoveOnAppear:GetLine(line);
            table.RemoveByValue(self.RemoveOnAppear.remonap, lineinfo.index)
			self.RemoveOnAppear:RemoveLine(line)
            self.RemoveOnAppear:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;
    self.removeOnAppearIndex = vgui.Create( "DTextEntry", self )
	self.removeOnAppearIndex:SetPos( 375, 280 )
	self.removeOnAppearIndex:SetSize( 80, 20 )
	self.removeOnAppearIndex:SetText( "" )
	self.removeOnAppearIndex:SetMultiline(true)
	self.removeOnAppearIndex:SetPlaceholderText("Индекс")  
	self.removeOnAppearIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.removeOnAppearButton = vgui.Create("DButton", self)
    self.removeOnAppearButton:SetText( '+' )
    self.removeOnAppearButton:SetColor(Color(255, 100, 100))
    self.removeOnAppearButton:SetPos(460, 280)
    self.removeOnAppearButton:SetSize(75, 20)
    function self.removeOnAppearButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !table.HasValue(pnl.RemoveOnAppear.remonap, pnl.removeOnAppearIndex:GetValue()) then
            table.insert(pnl.RemoveOnAppear.remonap, pnl.removeOnAppearIndex:GetValue());
            local q = pnl.RemoveOnAppear:AddLine(pnl.removeOnAppearIndex:GetValue());
            q.index = pnl.removeOnAppearIndex:GetValue()
        end;
    end;
    function self.removeOnAppearButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;   

    self.CallQuestions = vgui.Create( "DListView", self )
	self.CallQuestions:SetPos(560, 75)
	self.CallQuestions:SetSize(170, 200)
	self.CallQuestions:SetMultiSelect( false )
    self.CallQuestions:AddColumn( "Индекс" )
    self.CallQuestions.callquu = {};
	self.CallQuestions.OnClickLine = function( p, l, s )				
		self.CallQuestions:ClearSelection()
        self.CallQuestions:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.CallQuestions:GetSelectedLine();
            local lineinfo = self.CallQuestions:GetLine(line);
            table.RemoveByValue(self.CallQuestions.callquu, lineinfo.index)
			self.CallQuestions:RemoveLine(line)
            self.CallQuestions:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;

    self.callQuestionsIndex = vgui.Create( "DTextEntry", self )
	self.callQuestionsIndex:SetPos( 560, 280 )
	self.callQuestionsIndex:SetSize( 80, 20 )
	self.callQuestionsIndex:SetText( "" )
	self.callQuestionsIndex:SetMultiline(true)
	self.callQuestionsIndex:SetPlaceholderText("Индекс")  
	self.callQuestionsIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.callQuestionsButton = vgui.Create("DButton", self)
    self.callQuestionsButton:SetText( '+' )
    self.callQuestionsButton:SetColor(Color(255, 100, 100))
    self.callQuestionsButton:SetPos(645, 280)
    self.callQuestionsButton:SetSize(85, 20)
    function self.callQuestionsButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !table.HasValue(pnl.CallQuestions.callquu, pnl.callQuestionsIndex:GetValue()) then
            table.insert(pnl.CallQuestions.callquu, pnl.callQuestionsIndex:GetValue());
            local q = pnl.CallQuestions:AddLine(pnl.callQuestionsIndex:GetValue());
            q.index = pnl.callQuestionsIndex:GetValue()
        end;
    end;
    function self.callQuestionsButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;

    self.questType = vgui.Create( "DComboBox", self )
	self.questType:SetPos( 220, 310 )
	self.questType:SetSize( 110, 20 )
	self.questType:SetValue( "" )
	self.questType:AddChoice( "Собирательство" )
    self.questType:AddChoice( "Убийство НПС" )
    self.questType:SetColor(Color(255, 180, 80))
	self.questType.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
    end;
    self.listOfNeeded = vgui.Create( "DListView", self )
	self.listOfNeeded:SetPos(340, 310)
	self.listOfNeeded:SetSize(170, 150)
	self.listOfNeeded:SetMultiSelect( false )
    self.listOfNeeded:AddColumn( "Индекс" )
    self.listOfNeeded:AddColumn( "Количество" )
    self.listOfNeeded.needlist = {};
	self.listOfNeeded.OnClickLine = function( p, l, s )				
		self.listOfNeeded:ClearSelection()
        self.listOfNeeded:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.listOfNeeded:GetSelectedLine();
            local lineinfo = self.listOfNeeded:GetLine(line);
            self.listOfNeeded.needlist[ lineinfo.index ] = nil;
			self.listOfNeeded:RemoveLine(line)
            self.listOfNeeded:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;

    self.listOfNeededIndex = vgui.Create( "DTextEntry", self )
	self.listOfNeededIndex:SetPos( 340, 465 )
	self.listOfNeededIndex:SetSize( 50, 20 )
	self.listOfNeededIndex:SetText( "" )
	self.listOfNeededIndex:SetPlaceholderText("Индекс")  
	self.listOfNeededIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.listOfNeededNumber = vgui.Create( "DNumberWang", self )
	self.listOfNeededNumber:SetPos( 393, 465 )
	self.listOfNeededNumber:SetSize( 30, 20 )
    self.listOfNeededNumber:SetValue( 1 )
    self.listOfNeededNumber:SetMinMax( 1, 10 )
	self.listOfNeededNumber.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.listOfNeededButton = vgui.Create("DButton", self)
    self.listOfNeededButton:SetText( '+' )
    self.listOfNeededButton:SetColor(Color(255, 100, 100))
    self.listOfNeededButton:SetPos(425, 465)
    self.listOfNeededButton:SetSize(85, 20)
    function self.listOfNeededButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !pnl.listOfNeeded.needlist[pnl.listOfNeededIndex:GetValue()] then

            if pnl.questType:GetValue() == 'Собирательство' && !Clockwork.item:FindByID(pnl.rewardTaskIndex:GetValue()) then
                return;
            end;

            pnl.listOfNeeded.needlist[pnl.listOfNeededIndex:GetValue()] = pnl.listOfNeededNumber:GetValue()
            local q = pnl.listOfNeeded:AddLine(pnl.listOfNeededIndex:GetValue(), pnl.listOfNeededNumber:GetValue());
            q.index = pnl.listOfNeededIndex:GetValue()
        end;
    end;
    function self.listOfNeededButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;  

    self.randomTasks = vgui.Create( "DCheckBoxLabel", self )
	self.randomTasks:SetPos(515, 310)
	self.randomTasks:SetText( 'Рандомно?' )
    self.randomTasks:SetValue(false)
    function self.randomTasks:OnChange( val )
    end
    self.rewardTask = vgui.Create( "DListView", self )
	self.rewardTask:SetPos(600, 310)
	self.rewardTask:SetSize(170, 150)
	self.rewardTask:SetMultiSelect( false )
    self.rewardTask:AddColumn( "Награда" )
    self.rewardTask:AddColumn( "Количество" )
    self.rewardTask.rewardList = {};
	self.rewardTask.OnClickLine = function( p, l, s )				
		self.rewardTask:ClearSelection()
        self.rewardTask:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.rewardTask:GetSelectedLine();
            local lineinfo = self.rewardTask:GetLine(line);
            self.rewardTask.rewardList[ lineinfo.index ] = nil;
			self.rewardTask:RemoveLine(line)
            self.rewardTask:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;

    self.rewardTaskIndex = vgui.Create( "DTextEntry", self )
	self.rewardTaskIndex:SetPos( 600, 465 )
	self.rewardTaskIndex:SetSize( 50, 20 )
	self.rewardTaskIndex:SetText( "" )
	self.rewardTaskIndex:SetMultiline(true)
	self.rewardTaskIndex:SetPlaceholderText("Индекс")  
	self.rewardTaskIndex.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.rewardTaskNumber = vgui.Create( "DNumberWang", self )
	self.rewardTaskNumber:SetPos( 653, 465 )
	self.rewardTaskNumber:SetSize( 30, 20 )
    self.rewardTaskNumber:SetValue( 1 )
    self.rewardTaskNumber:SetMinMax( 1, 10 )
	self.rewardTaskNumber.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.rewardTaskButton = vgui.Create("DButton", self)
    self.rewardTaskButton:SetText( '+' )
    self.rewardTaskButton:SetColor(Color(255, 100, 100))
    self.rewardTaskButton:SetPos(685, 465)
    self.rewardTaskButton:SetSize(85, 20)
    function self.rewardTaskButton:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !pnl.rewardTask.rewardList[pnl.rewardTaskIndex:GetValue()] then
            if pnl.questType:GetValue() == 'Собирательство' && !Clockwork.item:FindByID(pnl.rewardTaskIndex:GetValue()) then
                return;
            end;
            pnl.rewardTask.rewardList[pnl.rewardTaskIndex:GetValue()] = pnl.rewardTaskNumber:GetValue()
            local q = pnl.rewardTask:AddLine(pnl.rewardTaskIndex:GetValue(), pnl.rewardTaskNumber:GetValue());
            q.index = pnl.rewardTaskIndex:GetValue()
        end;
    end;
    function self.rewardTaskButton:Paint(w, h)
        if self:IsHovered() && !self:GetDisabled() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;  

    self.rewardTokens = vgui.Create( "DNumberWang", self )
	self.rewardTokens:SetPos( 515, 345 )
	self.rewardTokens:SetSize( 80, 20 )
	self.rewardTokens:SetValue( '' )
	self.rewardTokens:SetMultiline(true)
	self.rewardTokens.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;

    function CloseAllStuff()
        local tbb = {
            pnl.checkboxIsDefault,
            pnl.settingsEntry,
            pnl.settingsType,
            pnl.settingsIndex,
            pnl.callOnAppear,
            pnl.callOnAppearIndex,
            pnl.callOnAppearButton,
            pnl.CallAnwser,
            pnl.callAnwserIndex,
            pnl.callAnwserButton,
            pnl.RemoveOnAppear,
            pnl.removeOnAppearIndex,
            pnl.removeOnAppearButton,
            pnl.CallQuestions,
            pnl.callQuestionsIndex,
            pnl.callQuestionsButton,
            pnl.nameEntry,
            pnl.modelEntry,
            pnl.sequenceEntry,
            pnl.preinsert,
            pnl.dissalowText,
            pnl.soundToUse,
            pnl.DisallowSellItems,
            pnl.questType,
            pnl.listOfNeeded,
            pnl.listOfNeededIndex,
            pnl.listOfNeededNumber,
            pnl.listOfNeededButton,
            pnl.randomTasks,
            pnl.rewardTask,
            pnl.rewardTaskIndex,
            pnl.rewardTaskNumber,
            pnl.rewardTaskButton,
            pnl.rewardTokens
        }
        for a, panel in pairs(tbb) do
            panel:Hide();
            if !panel.disallowDisable && (pnl.settingsType:GetValue() == '') then
                panel:SetDisabled(true);
            end;
        end;
    end;

    function ShowAllStuff()
        local tbb = {
            pnl.checkboxIsDefault,
            pnl.settingsEntry,
            pnl.settingsType,
            pnl.settingsIndex,
            pnl.callOnAppear,
            pnl.callOnAppearIndex,
            pnl.callOnAppearButton,
            pnl.CallAnwser,
            pnl.callAnwserIndex,
            pnl.callAnwserButton,
            pnl.RemoveOnAppear,
            pnl.removeOnAppearIndex,
            pnl.removeOnAppearButton,
            pnl.CallQuestions,
            pnl.callQuestionsIndex,
            pnl.callQuestionsButton,
            pnl.nameEntry,
            pnl.modelEntry,
            pnl.sequenceEntry,
            pnl.preinsert,
            pnl.dissalowText,
            pnl.soundToUse,
            pnl.DisallowSellItems,
            pnl.questType,
            pnl.listOfNeeded,
            pnl.listOfNeededIndex,
            pnl.listOfNeededNumber,
            pnl.listOfNeededButton,
            pnl.randomTasks,
            pnl.rewardTask,
            pnl.rewardTaskIndex,
            pnl.rewardTaskNumber,
            pnl.rewardTaskButton,
            pnl.rewardTokens
        }
        for _, panel in pairs(tbb) do
            panel:Show();
        end;
    end;

    CloseAllStuff()
    self.GetFinfo = vgui.Create("DPanel", self)
    self.GetFinfo:SetPos(590, 280);
    self.GetFinfo:SetSize(310, 210);

    self.GetFinfo.tinfo = {
        index = '',
        def = '',
        CallOnAppear = '',
        CallAnwser = '',
        RemoveOnAppear = '',
        CallQuestions = ''
    };

    function self.GetFinfo:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))

        if self.tinfo['index'] != '' then
            draw.DrawText( self.tinfo['index'], "DermaDefault", 10, 10, color_white, TEXT_ALIGN_LEFT )
            draw.DrawText( self.tinfo['def'], "DermaDefault", 10, 25, color_white, TEXT_ALIGN_LEFT )
            if string.StartWith(self.tinfo['index'], 'Ответ: ') then
                draw.DrawText( self.tinfo['CallOnAppear'], "DermaDefault", 10, 40, color_white, TEXT_ALIGN_LEFT )
            else
                draw.DrawText( self.tinfo['CallAnwser'], "DermaDefault", 10, 40, color_white, TEXT_ALIGN_LEFT )
                draw.DrawText( self.tinfo['RemoveOnAppear'], "DermaDefault", 10, 70, color_white, TEXT_ALIGN_LEFT )
                draw.DrawText( self.tinfo['CallQuestions'], "DermaDefault", 10, 100, color_white, TEXT_ALIGN_LEFT )
            end;
        else
            draw.DrawText( 'Выберите любую ячейку слева, чтобы \nполучить информацию о ней.', "DermaDefault", 10, 10, color_white, TEXT_ALIGN_LEFT )
        end;
    end;

    self.questions = vgui.Create( "DListView", self )
	self.questions:SetPos(10, 10)
	self.questions:SetSize(280, 480)
	self.questions:SetMultiSelect( false )
	self.questions:AddColumn( "Вопрос" )
    self.questions:AddColumn( "Индекс" )
	self.questions.OnClickLine = function( p, l, s )				
        self.questions:ClearSelection()
        pnl.anwsers:ClearSelection()
        self.questions:SelectItem(l)
        local line = self.questions:GetSelectedLine();
        local lineinfo = self.questions:GetLine(line);
        pnl.GetFinfo.tinfo = {
            index = 'Вопрос: '..lineinfo.index,
            def = 'Стандартный: '..tostring(pnl.talkTable[lineinfo.index].default),
            CallAnwser = 'Вызывать ответ:\n '..table.concat( pnl.talkTable[lineinfo.index].CallAnwser, ", " ),
            RemoveOnAppear = 'Удалить вопросы по нажатию:\n '..table.concat( pnl.talkTable[lineinfo.index].RemoveOnAppear, ", " ),
            CallQuestions = 'Вопросы по нажатию:\n '..table.concat( pnl.talkTable[lineinfo.index].CallQuestions, ", " )
        };
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.questions:GetSelectedLine();
            local lineinfo = self.questions:GetLine(line);
            pnl.talkTable[lineinfo.index] = nil;
            pnl:SaveAnwsers()
			self.questions:RemoveLine(line)
            self.questions:ClearSelection()
        end):SetImage("icon16/cancel.png")
        menu:AddOption( "Заполнить поля", function()
            local line = self.questions:GetSelectedLine();
            local lineinfo = self.questions:GetLine(line);
            local lineTBL = pnl.talkTable[lineinfo.index];

            pnl.checkboxIsDefault:SetValue(lineTBL.default);
            pnl.checkboxIsDefault.getdef = lineTBL.default;

            pnl.settingsEntry:SetValue(lineTBL['text'])
            pnl.settingsType:ChooseOption( 'Вопрос', 1 )
            pnl.settingsIndex:SetValue(lineinfo.index)

            pnl.callOnAppear.coap = {};
            pnl.callOnAppear:Clear();
            pnl.callOnAppearIndex:SetValue('')

            pnl.CallAnwser.cans = {};
            pnl.CallAnwser:Clear();
            for k, v in pairs(lineTBL.CallAnwser) do
                local q = pnl.CallAnwser:AddLine(v);
                q.index = v
                pnl.CallAnwser.cans[k] = v;
            end;
            pnl.callAnwserIndex:SetValue('')
            
            pnl.RemoveOnAppear.remonap = {}
            pnl.RemoveOnAppear:Clear();
            for k, v in pairs(lineTBL.RemoveOnAppear) do
                local q = pnl.RemoveOnAppear:AddLine(v);
                q.index = v
                pnl.RemoveOnAppear.remonap[k] = v;
            end;
            pnl.removeOnAppearIndex:SetValue('')

            pnl.CallQuestions.callquu = {};
            pnl.CallQuestions:Clear();
            for k, v in pairs(lineTBL.CallQuestions) do
                local q = pnl.CallQuestions:AddLine(v);
                q.index = v
                pnl.CallQuestions.callquu[k] = v;
            end;
            pnl.callQuestionsIndex:SetValue('')
            pnl:AddAlert('Заполнение выполнено успешно.', Color(100, 255, 100))
		end):SetImage("icon16/pencil_add.png")
        menu:Open()
    end;

    self.anwsers = vgui.Create( "DListView", self )
	self.anwsers:SetPos(295, 10)
	self.anwsers:SetSize(280, 480)
	self.anwsers:SetMultiSelect( false )
	self.anwsers:AddColumn( "Ответ" )
	self.anwsers:AddColumn( "Индекс" )
	self.anwsers.OnClickLine = function( p, l, s )				
		self.anwsers:ClearSelection()
        self.anwsers:SelectItem(l)
        pnl.questions:ClearSelection()

        local line = self.anwsers:GetSelectedLine();
        local lineinfo = self.anwsers:GetLine(line);
        pnl.GetFinfo.tinfo = {
            index = 'Ответ: '..lineinfo.index,
            def = 'Стандартный: '..tostring(pnl.talkTable[lineinfo.index].default),
            CallOnAppear = 'Вызывает вопросы:\n '..table.concat( pnl.talkTable[lineinfo.index].CallOnAppear, ", " )
        };

        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.anwsers:GetSelectedLine();
            local lineinfo = self.anwsers:GetLine(line);
            pnl.talkTable[lineinfo.index] = nil;
            pnl:SaveAnwsers()
			self.anwsers:RemoveLine(line)
            self.anwsers:ClearSelection()
        end):SetImage("icon16/cancel.png")
        menu:AddOption( "Заполнить поля", function()
            local line = self.anwsers:GetSelectedLine();
            local lineinfo = self.anwsers:GetLine(line);
            local lineTBL = pnl.talkTable[lineinfo.index];

            pnl.checkboxIsDefault:SetValue(lineTBL.default);
            pnl.checkboxIsDefault.getdef = lineTBL.default;

            pnl.settingsEntry:SetValue(lineTBL['text'])
            pnl.settingsType:ChooseOption( 'Ответ', 2 )
            pnl.settingsIndex:SetValue(lineinfo.index)

            pnl.soundToUse:SetText(lineTBL['sound'])

            pnl.callOnAppear.coap = {};
            pnl.callOnAppear:Clear();
            for k, v in pairs(lineTBL.CallOnAppear) do
                local q = pnl.callOnAppear:AddLine(v);
                q.index = v
                pnl.callOnAppear.coap[k] = v;
            end;
            pnl.callOnAppearIndex:SetValue('')
            pnl.callOnAppear:SetDisabled(false);
            pnl.callOnAppearIndex:SetDisabled(false);
            pnl.callOnAppearButton:SetDisabled(false);

            pnl.CallAnwser.cans = {};
            pnl.CallAnwser:Clear();
            pnl.callAnwserIndex:SetValue('')

            pnl.RemoveOnAppear.remonap = {}
            pnl.RemoveOnAppear:Clear();
            pnl.removeOnAppearIndex:SetValue('')

            pnl.CallQuestions.callquu = {};
            pnl.CallQuestions:Clear();
            pnl.callQuestionsIndex:SetValue('')

            if lineTBL.quest then
                pnl.questType:SetValue(lineTBL.quest.type)
                local opt = 0; if lineTBL.quest.type == 'Собирательство' then opt = 1 else opt = 2 end;
                pnl.questType:ChooseOption( lineTBL.quest.type, opt )
                pnl.listOfNeeded.needlist = lineTBL.quest.needToDo; pnl.rewardTask.rewardList = lineTBL.quest.rewardToGet;

                for k, v in pairs(pnl.listOfNeeded.needlist) do
                    local a = pnl.listOfNeeded:AddLine(k, v);
                    a.index = k
                end;

                for k, v in pairs(pnl.rewardTask.rewardList) do
                    local a = pnl.rewardTask:AddLine(k, v);
                    a.index = k
                end;

                pnl.randomTasks:SetValue(lineTBL.quest.randomize)
                pnl.rewardTokens:SetValue(lineTBL.quest.rewardTokens)
            end;

            pnl:AddAlert('Заполнение выполнено успешно.', Color(100, 255, 100))
		end):SetImage("icon16/pencil_add.png")
		menu:Open()
    end;

    self.setting = vgui.Create("DButton", self)
    self.setting:SetText( '' )
    self.setting:SetPos(590, 10)
    self.setting:SetSize(150, 40)
    self.setting.info = 'НАСТРОЙКИ'
    function self.setting:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if pnl.setting.info == 'НАСТРОЙКИ' then
            ShowAllStuff()
            pnl.setting.info = 'ДОБАВИТЬ'
            pnl.close.mode = 'НАЗАД'
            pnl.factionLists:Hide();
            pnl.GetFinfo:Hide();
            pnl.questions:Hide();
            pnl.anwsers:Hide();
        else

            if pnl.settingsEntry:GetValue() != '' && pnl.settingsType:GetValue() != '' && pnl.settingsIndex:GetValue() != '' then
                
                if pnl.settingsType:GetValue() == 'Ответ' then
                        if !pnl.talkTable[pnl.settingsIndex:GetValue()] then
                            local line = pnl.anwsers:AddLine(pnl.settingsEntry:GetValue(), pnl.settingsIndex:GetValue());
                            line.index = pnl.settingsIndex:GetValue();
                        end;
                        local q = nil;
                        if pnl.questType:GetValue() != '' then
                            q = {
                                vendorName = pnl.setting.vendorName,
                                type = pnl.questType:GetValue(),
                                needToDo = pnl.listOfNeeded.needlist,
                                rewardToGet = pnl.rewardTask.rewardList,
                                randomize = pnl.randomTasks:GetValue(),
                                rewardTokens = pnl.rewardTokens:GetValue()
                            }
                        end;
                        pnl.talkTable[pnl.settingsIndex:GetValue()] = {
                            text = pnl.settingsEntry:GetValue(),
                            CallOnAppear = pnl.callOnAppear.coap,
                            default = pnl.checkboxIsDefault.getdef,
                            sound = pnl.soundToUse:GetValue(),
                            isAnwser = true,
                            quest = q
                        }
                elseif pnl.settingsType:GetValue() == 'Вопрос' then
                    if !pnl.talkTable[pnl.settingsIndex:GetValue()] then
                        local line = pnl.questions:AddLine(pnl.settingsEntry:GetValue(), pnl.settingsIndex:GetValue());
                        line.index = pnl.settingsIndex:GetValue();
                    end;
                    pnl.talkTable[pnl.settingsIndex:GetValue()] = {
                        text = pnl.settingsEntry:GetValue(),
                        CallAnwser = pnl.CallAnwser.cans,
                        RemoveOnAppear = pnl.RemoveOnAppear.remonap,
                        CallQuestions = pnl.CallQuestions.callquu,
                        default = pnl.checkboxIsDefault.getdef,
                        isQuestion = true
                    }
                end;

                pnl:SaveAnwsers()

                pnl.callOnAppear.coap = {};
                pnl.CallAnwser.cans = {};
                pnl.RemoveOnAppear.remonap = {};
                pnl.CallQuestions.callquu = {};
                pnl.questType:SetValue('') 
                pnl.listOfNeeded.needlist = {}; pnl.rewardTask.rewardList = {}
                pnl.listOfNeeded:Clear()
                pnl.rewardTask:Clear()
                pnl.randomTasks:SetValue(false)
                pnl.rewardTokens:SetValue(0)
                pnl.callOnAppear:Clear(); pnl.CallAnwser:Clear(); pnl.RemoveOnAppear:Clear(); pnl.CallQuestions:Clear()
                pnl:AddAlert('Вы добавили информацию!', Color(100, 255, 100))
            elseif pnl.settingsEntry:GetValue() == '' then
                pnl:AddAlert('Вы не ввели текст для информации!', Color(255, 100, 100))
            elseif pnl.settingsIndex:GetValue() == '' then
                pnl:AddAlert('Вы не ввели индекс!', Color(255, 100, 100))
            elseif pnl.settingsType:GetValue() == '' then
                pnl:AddAlert('Вы не выбрали тип!', Color(255, 100, 100))
            end;

        end;
    end;
    function self.setting:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        draw.DrawText( pnl.setting.info, "DermaDefault", 45, 14, Color(255, 100, 100), TEXT_ALIGN_LEFT )
    end;     
    self.close = vgui.Create("DButton", self)
    self.close:SetText( '' )
    self.close:SetPos(750, 10)
    self.close:SetSize(150, 40)
    self.close.mode = 'ЗАКРЫТЬ'
    function self.close:DoClick(self)
        if pnl.close.mode == 'ЗАКРЫТЬ' then
            pnl:Close() pnl:SaveTalkers()
        else
            pnl.setting.info = 'НАСТРОЙКИ'
            pnl.close.mode = 'ЗАКРЫТЬ'
            CloseAllStuff()
            pnl.factionLists:Show();
            pnl.GetFinfo:Show();
            pnl.questions:Show();
            pnl.anwsers:Show();
        end;
        surface.PlaySound("ui/buttonclick.wav");
    end;
    function self.close:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), Color(255, 100, 100) )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
        end;
        draw.DrawText( pnl.close.mode, "DermaDefault", 50, 14, Color(255, 100, 100), TEXT_ALIGN_LEFT )
    end; 
    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(data, id, sinfo, ent)
    local pnl = self;

    self.ids = id
    self.talkTable = data;
    self.sellerInfo = sinfo;
    self.getent = ent;

    for index, inside in pairs(pnl.talkTable) do
        if inside.isQuestion then
            local q = pnl.questions:AddLine(inside.text, index);
            q.index = index
        elseif inside.isAnwser then
            local a = pnl.anwsers:AddLine(inside.text, index);
            a.index = index
        end;
    end;
    self.preinsert = vgui.Create( "DModelPanel", self )
    self.preinsert:SetSize( 200, 200 )
    self.preinsert:SetPos(750, 95)
    function self.preinsert:LayoutEntity( Entity ) return end -- disables default rotation
    function self.preinsert:Think(self)
        if pnl.modelEntry:GetValue() != '' then
            pnl.preinsert:SetModel( pnl.modelEntry:GetValue() );  
            pnl.preinsert.Entity:SetSequence( pnl.sequenceEntry:GetValue() )
        end;
    end;
    self.preinsert:Hide();
    self.nameEntry = vgui.Create( "DTextEntry", self )
	self.nameEntry:SetPos( 735, 95 )
	self.nameEntry:SetSize( 80, 20 )
	self.nameEntry:SetText( self.sellerInfo['name'] )
    self.nameEntry:SetPlaceholderText("Имя")  
    self.nameEntry.disallowDisable = true;
	self.nameEntry.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;
    self.nameEntry:Hide();

    self.modelEntry = vgui.Create( "DTextEntry", self )
	self.modelEntry:SetPos( 735, 120 )
	self.modelEntry:SetSize( 80, 20 )
	self.modelEntry:SetText( self.sellerInfo['model'] )
    self.modelEntry:SetPlaceholderText("Внешний вид")  
    self.modelEntry.disallowDisable = true;
	self.modelEntry.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;
    self.modelEntry:Hide();

    self.sequenceEntry = vgui.Create( "DNumberWang", self )
	self.sequenceEntry:SetPos( 735, 150 )
    self.sequenceEntry:SetSize( 60, 20 )
    self.sequenceEntry:SetMax( 1400 )
    self.sequenceEntry:SetMin( 1 )
	self.sequenceEntry:SetText( self.sellerInfo['sequence'] )
    self.sequenceEntry:SetPlaceholderText("Номер анимации")  
    self.sequenceEntry.disallowDisable = true;
	self.sequenceEntry.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;
    self.sequenceEntry:Hide();

    self.factionLists = vgui.Create("DPanel", self)
    self.factionLists:SetPos(590, 60);
    self.factionLists:SetSize(310, 215)
    function self.factionLists:Paint(w, h) end;

    self.scrollFactions = vgui.Create( "DScrollPanel", self.factionLists )
    self.scrollFactions:Dock( FILL );
    self.scrollFactions.factions = sinfo['factionsAllowed'];
    local factions = self.scrollFactions.factions;

    if table.Count(factions) == 0 then
        for k, v in pairs(Clockwork.faction.stored) do
            factions[k] = true;
        end;
    end;
    for k, v in pairs(factions) do
		local FactionBox = self.scrollFactions:Add( "DCheckBoxLabel" )
		FactionBox:Dock(TOP)
		FactionBox:SetText( k )
		FactionBox:SetValue( v )
        function FactionBox:OnChange( val )
            pnl.scrollFactions.factions[k] = val;
		end;
    end;
    
    self.dissalowText = vgui.Create( "DTextEntry", self )
	self.dissalowText:SetPos( 15, 310 )
	self.dissalowText:SetSize( 200, 20 )
	self.dissalowText:SetText( self.sellerInfo['disallow'] )
    self.dissalowText:SetPlaceholderText("Вывод текста при запрете общаться: ")  
    self.dissalowText.disallowDisable = true;
	self.dissalowText.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
    end;
    self.dissalowText:Hide();

    self.soundToUse = vgui.Create( "DTextEntry", self )
	self.soundToUse:SetPos( 15, 340 )
	self.soundToUse:SetSize( 200, 20 )
	self.soundToUse:SetText( '' )
    self.soundToUse:SetPlaceholderText("Воспроизводить звук у ответа: ")
    self.soundToUse.disallowDisable = false;
	self.soundToUse.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
        end;
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.soundToUse:Hide();

    self.DisallowSellItems = vgui.Create( "DCheckBoxLabel", self )
	self.DisallowSellItems:SetPos( 15, 370 ) self.soundToUse:SetSize( 200, 20 )
	self.DisallowSellItems:SetValue(self.sellerInfo['allowtosell'])
    self.DisallowSellItems:SetText( 'Разрешить продавать?' )
    function self.DisallowSellItems:OnChange( val )
        pnl.sellerInfo['allowtosell'] = val
    end;
    self.DisallowSellItems:Hide();

    pnl.setting.vendorName = self.sellerInfo['name'];
end;

function PANEL:AddAlert(text, color)
    if !self.alertInterval || CurTime() >= self.alertInterval then
        
        self.errorPlace = vgui.Create("DPanel", self)
        self.errorPlace:SetPos(50, 550);
        self.errorPlace:SetSize(300, 25)
        function self.errorPlace:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
            draw.DrawText( text, "DermaDefault", 5, 5, color, TEXT_ALIGN_LEFT )
        end;
        self.errorPlace:MoveTo( 50, 470, 1, 0, -1, function() 

            timer.Create(tostring(math.random(1, 10000000000)), 2, 1, function()
                if IsValid(self.errorPlace) then
                    self.errorPlace:MoveTo( 50, 550, 1, 0, -1, function() self.errorPlace:Remove() end)
                end;
            end);

        end)
        self.alertInterval = CurTime() + 4
    end;
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 100, 100) )
    if self.setting.info == 'ДОБАВИТЬ' then
        draw.DrawText( 'Вызвать вопросы при появлении', "DermaDefault", 15, 55, Color(255, 100, 100), TEXT_ALIGN_LEFT )
        draw.DrawText( 'Вызвать вопросы при нажатии', "DermaDefault", 560, 55, Color(255, 100, 100), TEXT_ALIGN_LEFT )
        draw.DrawText( 'Удалить вопросы при нажатии', "DermaDefault", 375, 55, Color(255, 100, 100), TEXT_ALIGN_LEFT )
        draw.DrawText( 'Вызвать ответы при нажатии', "DermaDefault", 185, 55, Color(255, 100, 100), TEXT_ALIGN_LEFT )
    end;
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function PANEL:SaveAnwsers()
    local pnl = self;

    cable.send('EditAnwsers', {self.ids, self.talkTable} );
end;

function PANEL:SaveTalkers()
    local pnl = self;
    local tbl = {
        name = pnl.nameEntry:GetValue(),
        model = pnl.modelEntry:GetValue(),
        sequence = pnl.sequenceEntry:GetValue(),
        factionsAllowed = pnl.scrollFactions.factions,
        disallow = pnl.dissalowText:GetValue(),
        allowtosell = pnl.sellerInfo['allowtosell']
    }
    cable.send('EditEntityTalker', self.getent, tbl );
end;

vgui.Register( "RossSalesmanEdit", PANEL, "DFrame" )
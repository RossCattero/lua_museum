
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

	if (ec == "ross_talking_npc") then
        options["Поговорить"] = "ross_talking_openwindow";
		options["Открыть настройки"] = "ross_talking_opensettings";
		
		options["Продать предметы за лояльность"] = "ross_talking_openSell";
		options["Купить предметы"] = "ross_talking_openBuy"
		options["Настроить покупку предметов"] = "ross_talking_openBuySett"
	end;

end;

cable.receive('TalkToMeNPC', function(table, entity)
    OpenTalkingMenu(table, entity)
end);

cable.receive('SettingsNPCTalker', function(table, entity, entI)
    
	SettingsMenu(table, entity, entI)
end);

cable.receive('SellItemsTalkerNPC', function(inventory, ent, reput)
    
	OpenItemBoard(inventory, ent, reput)
end);

cable.receive('BuyItemsLoyality', function(ent, stock, infoLoy)
    
	BuySomeShit(ent, stock, infoLoy)
end);

cable.receive('BuyItemsLoyalitySett', function(ent, stock)
    
	BuySomeShitEdit(ent, stock)
end);

function ReSizeString(str, max)
	if str == "" && isnumber(max) then
		return;
	end;

	local max = tonumber(max)

	local len = string.len(str);
	if len > max then
		return string.sub(str, 1, max).."..."
	else
		return str;
	end;
end;

function AddSomeQuestions(QuestionsOfTalker, text, owner, k)

	local Question = QuestionsOfTalker:Add( "DPanel" )
	Question:SetText( "" )
	Question:SetSize(0, 35)
	Question:Dock( TOP )
	Question:DockMargin( 5, 5, 5, 5 )
	Question.Paint = function(self, w, h)
		if owner == "sales" then
			draw.DrawText( "Joe Dowberman", "DermaDefault", 5, 0, Color(200, 255, 150, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( ReSizeString(text["info"], 350), "DermaDefault", 5, 15, Color(200, 255, 150, 255), TEXT_ALIGN_LEFT )
		else
			draw.DrawText( "You:", "DermaDefault", 5, 0, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( ReSizeString(text["info"], 350), "DermaDefault", 5, 15, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
		end;
	end;
	Question:SetAlpha(0)
	if owner == "sales" then
		Question:AlphaTo( 255, 1, 0, function() end);
	else
		Question:SetAlpha(255)
	end;
	if text["sound"] != "" then
		surface.PlaySound(text["sound"]);
	end;

end;

function AddSomeAnwsers(Anwsers, k, v, frame, tbl, QuestionsOfTalker)

	local anwser = Anwsers:Add( "DButton" )
		anwser:SetText( "" )
		anwser:Dock( TOP )
		anwser:DockMargin( 5, 5, 5, 5 )
		anwser.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.DrawText( ReSizeString(v["info"], 350), "DermaDefault", 10, 10, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
			elseif !self:IsHovered() then
				draw.DrawText( ReSizeString(v["info"], 350), "DermaDefault", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
			end;
		end;
		anwser.DoClick = function(self)
			surface.PlaySound("ui/buttonclick.wav");
			if k == "quit" then
				frame:Close(); frame:Remove();
			end;
			for index, contain in pairs(tbl["questions"]) do			
				if k == index then
				AddSomeQuestions(QuestionsOfTalker, v, "player", k)
					AddSomeQuestions(QuestionsOfTalker, contain, "sales", k)
					if next(contain["quest"]) != nil then
						if table.Count(contain["quest"]["item"]) > 0 then

							local function displayItem(itemTable)
								local item = "Неизвестно"
								if table.Count(itemTable["item"]) == 1 then 
									return itemTable["item"][1]
								else
									return itemTable["item"][1].." и более..."
								end;

								return item
							end;

							Derma_Query( displayItem(contain["quest"]), contain["quest"]["type"],
							"Берусь!", function()
								cable.send('QuestAddPlayer', contain["quest"]);
							end, 
							"Нет.", function()
							end).Paint = function(self, w, h)
								draw.RoundedBox( 0, 0, 0, w, h, Color(0, 0, 0, 100) )
							end;
						end;
					end;
				end;
			end;
		end;

end;

function OpenTalkingMenu(tbl, entity)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(900, 600)
    frame:SetTitle("")
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local OutLinedPanel = vgui.Create( "DPanel", frame )
	OutLinedPanel:SetPos( 5, 5 )
	OutLinedPanel:SetSize( 890, 590 )
	OutLinedPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
	end;

	local TalkPanel = vgui.Create( "DPanel", OutLinedPanel )
	TalkPanel:SetPos( 5, 5 )
	TalkPanel:SetSize( 880, 400 )
	TalkPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
	end;

	local AnwserPanel = vgui.Create( "DPanel", OutLinedPanel )
	AnwserPanel:SetPos( 5, 408 )
	AnwserPanel:SetSize( 880, 178 )
	AnwserPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
	end;

	local Anwsers = vgui.Create( "DScrollPanel", AnwserPanel )
	Anwsers:Dock( FILL )

	local QuestionsOfTalker = vgui.Create( "DScrollPanel", TalkPanel )
	QuestionsOfTalker:Dock( FILL )

	for k, v in pairs(tbl["questions"]) do
		if k == "startIndex" then
			AddSomeQuestions(QuestionsOfTalker, v, "sales", k)
		end;
	end;

	for k, v in pairs(tbl["anwsers"]) do
		AddSomeAnwsers(Anwsers, k, v, frame, tbl, QuestionsOfTalker)
	end;

end;

function SettingsMenu(tbl, entity, entI)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(900, 600)
    frame:SetTitle("")
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local QuestionPanel = vgui.Create( "DListView", frame )
	QuestionPanel:SetPos(10, 25)
	QuestionPanel:SetSize(450, 150)
	QuestionPanel:SetMultiSelect( false )
	QuestionPanel:AddColumn( "НПС" )
	QuestionPanel:AddColumn( "Индекс" )
	QuestionPanel.OnClickLine = function( p, l, s )				
		QuestionPanel:ClearSelection()
		QuestionPanel:SelectItem(l)
		local menu = DermaMenu()
		menu:AddOption( "Удалить линию", function()
			if l.uniqueID == "startIndex" then
				QuestionPanel:ClearSelection()
				return 
			end
			QuestionPanel:RemoveLine(QuestionPanel:GetSelectedLine())
			QuestionPanel:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:AddOption( "Изменить линию", function()
			Derma_StringRequest( "Изменить линию", "Изменить линию", l.textDialogue, 
			function(text)
				local bufferID = l.uniqueID;
				local bufferSound = l.soundToSay;
				if table.Count(l.quest["item"]) > 0 then
					local bufferQuests = l.quest
				end;
				QuestionPanel:RemoveLine(QuestionPanel:GetSelectedLine())
				QuestionPanel:ClearSelection()

				local aline = QuestionPanel:AddLine(text, bufferID);

				if bufferQuests then
					aline.quest = bufferQuests;
				end;
				aline.uniqueID = bufferID;
				aline.textDialogue = text;		
				aline.soundToSay = bufferSound;			
			end, 
			function()
				return;
			end)
		end):SetImage("icon16/application_edit.png")
		menu:AddOption( "Изменить звук", function()
			Derma_StringRequest( "Изменить звук", "Изменить звук", l.soundToSay, 
			function(text)
				l.soundToSay = text;		
			end, 
			function()
				return;
			end)
		end):SetImage("icon16/cog.png")
		menu:Open()
	end;

	local AnwsersPanel = vgui.Create( "DListView", frame )
	AnwsersPanel:SetPos(460, 25)
	AnwsersPanel:SetSize(430, 150)
	AnwsersPanel:SetMultiSelect( false )
	AnwsersPanel:AddColumn( "Игрок" )
	AnwsersPanel:AddColumn( "Индекс" )
	AnwsersPanel.OnClickLine = function( p, l, s )
		AnwsersPanel:ClearSelection()
		AnwsersPanel:SelectItem(l)
		local menu = DermaMenu()
		menu:AddOption( "Удалить линию", function()
			if l.uniqueID == "quit" then
				AnwsersPanel:ClearSelection()
				return 
			end
			AnwsersPanel:RemoveLine(AnwsersPanel:GetSelectedLine())
			AnwsersPanel:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:AddOption( "Изменить линию", function()
			Derma_StringRequest( "Изменить линию", "Изменить линию", l.textDialogue, 
			function(text)
				local bufferID = l.uniqueID;
				local bufferSound = l.soundToSay;
				AnwsersPanel:RemoveLine(AnwsersPanel:GetSelectedLine())
				AnwsersPanel:ClearSelection()

				local aline = AnwsersPanel:AddLine(text, bufferID);
				aline.uniqueID = bufferID;
				aline.textDialogue = text;
				aline.soundToSay = bufferSound;	
			end, 
			function()
				return;
			end)
		end):SetImage("icon16/application_edit.png")
		menu:Open()
	end

	for k, v in pairs(tbl["questions"]) do
		local qline = QuestionPanel:AddLine(v["info"], k);

		qline.uniqueID = k;
		qline.textDialogue = v["info"];
		qline.soundToSay = v["sound"]
		qline.quest = v["quest"]
	end;
	for k, v in pairs(tbl["anwsers"]) do
		local aline = AnwsersPanel:AddLine(v["info"], k);

		aline.uniqueID = k;
		aline.textDialogue = v["info"];
		aline.soundToSay = v["sound"];
	end;

	local TextInfoHere = vgui.Create( "DTextEntry", frame )
	TextInfoHere:SetPos( 10, 180 )
	TextInfoHere:SetSize( 300, 75 )
	TextInfoHere:SetText( "" )
	TextInfoHere:SetMultiline(true)

	local TypeOfInfo = vgui.Create( "DComboBox", frame )
	TypeOfInfo:SetPos( 320, 180 )
	TypeOfInfo:SetSize( 100, 20 )
	TypeOfInfo:SetValue( "Выбрать" )
	TypeOfInfo:AddChoice( "НПС" )
	TypeOfInfo:AddChoice( "Игрок" )

	local IndexInfo = vgui.Create( "DTextEntry", frame )
	IndexInfo:SetPos( 320, 200 )
	IndexInfo:SetSize( 100, 20 )
	IndexInfo:SetText( "" )

	local ItemListForQuest = vgui.Create( "DPanel", frame )
	ItemListForQuest:SetPos( 550, 180 )
	ItemListForQuest:SetSize( 340, 70 )
	ItemListForQuest.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0));
	end;
	ItemListForQuest.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local ItemListForQuestI = vgui.Create( "DScrollPanel", ItemListForQuest )
	ItemListForQuestI:Dock( FILL )
	ItemListForQuestI.QuestTasks = {
		item = {},
		amount = {},
		reward = {},
		type = ""
	}
	ItemListForQuestI.ItemsChoosen = {}

	local itemUniqueID = vgui.Create( "DTextEntry", frame )
	itemUniqueID:SetPos( 440, 205 )
	itemUniqueID:SetSize( 68, 20 )
	itemUniqueID:SetText( "" )
	itemUniqueID.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local itemUniqueIDAmount = vgui.Create( "DNumberWang", frame )
	itemUniqueIDAmount:SetPos( 510, 205 )
	itemUniqueIDAmount:SetSize( 30, 20 )
	itemUniqueIDAmount:SetValue( 1 )
	itemUniqueIDAmount:SetMinMax( 1, 16 )
	itemUniqueIDAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;

	local TypeofQuest = vgui.Create( "DComboBox", frame )
	TypeofQuest:SetPos( 440, 180 )
	TypeofQuest:SetSize( 100, 20 )
	TypeofQuest:SetValue( "Выбрать" )
	TypeofQuest:AddChoice( "Сбор предметов" )
	TypeofQuest:AddChoice( "Убийство НПС" )
	TypeofQuest.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForQuestI.ItemsChoosen) == 0 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	----
	local ItemListForReward = vgui.Create( "DPanel", frame )
	ItemListForReward:SetPos( 550, 260 )
	ItemListForReward:SetSize( 340, 70 )
	ItemListForReward.rewardQuest = {
		Rewitems = {}
	}
	ItemListForReward.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0));
	end;
	ItemListForReward.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local ItemListForRewardI = vgui.Create( "DScrollPanel", ItemListForReward )
	ItemListForRewardI:Dock( FILL )

	local SalesLoyalityAmount = vgui.Create( "DNumberWang", frame )
	SalesLoyalityAmount:SetPos( 550, 340 )
	SalesLoyalityAmount:SetSize( 50, 20 )
	SalesLoyalityAmount:SetValue( 0 )
	SalesLoyalityAmount:SetMinMax( 0, 25 )
	SalesLoyalityAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local LoyalityAmount = vgui.Create( "DNumberWang", frame )
	LoyalityAmount:SetPos( 700, 340 )
	LoyalityAmount:SetSize( 50, 20 )
	LoyalityAmount:SetValue( 0 )
	LoyalityAmount:SetMinMax( 0, 10 )
	LoyalityAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local MoneyAmount = vgui.Create( "DNumberWang", frame )
	MoneyAmount:SetPos( 840, 340 )
	MoneyAmount:SetSize( 50, 20 )
	MoneyAmount:SetValue( 0 )
	MoneyAmount:SetMinMax( 0, 10 )
	MoneyAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;

	local itemUniqueIDReward = vgui.Create( "DTextEntry", frame )
	itemUniqueIDReward:SetPos( 440, 260 )
	itemUniqueIDReward:SetSize( 68, 20 )
	itemUniqueIDReward:SetText( "" )
	itemUniqueIDReward.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local MoneyAmount = vgui.Create( "DNumberWang", frame )
	MoneyAmount:SetPos( 840, 340 )
	MoneyAmount:SetSize( 50, 20 )
	MoneyAmount:SetValue( 0 )
	MoneyAmount:SetMinMax( 0, 10 )
	MoneyAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForReward.rewardQuest["Rewitems"]) < 2 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local itemUniqueIDAmountReward = vgui.Create( "DNumberWang", frame )
	itemUniqueIDAmountReward:SetPos( 510, 260 )
	itemUniqueIDAmountReward:SetSize( 30, 20 )
	itemUniqueIDAmountReward:SetValue( 1 )
	itemUniqueIDAmountReward:SetMinMax( 1, 3 )
	itemUniqueIDAmountReward.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForReward.rewardQuest["Rewitems"]) < 2 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;

	local addItemReward = vgui.Create( "DButton", frame )
	addItemReward:SetText( "Добавить предмет" )
	addItemReward:SetPos( 440, 285 )
	addItemReward:SetSize( 100, 20 )
	addItemReward.DoClick = function()
		if table.Count(ItemListForReward.rewardQuest["Rewitems"]) < 2 && !ItemListForReward.rewardQuest["Rewitems"][itemUniqueIDReward:GetValue()] && TypeofQuest:GetValue() != "Выбрать" && itemUniqueIDAmountReward:GetValue() > 0 && itemUniqueIDReward:GetValue() != "" then
			local itemRewardPanel = ItemListForRewardI:Add( "DButton" )
			itemRewardPanel:Dock( TOP )
			itemRewardPanel.uniqueIDItem = itemUniqueIDReward:GetValue();
			itemRewardPanel.uniqueIDItemCount = itemUniqueIDAmountReward:GetValue()
			itemRewardPanel:SetText("")
			itemRewardPanel:DockMargin( 5, 5, 5, 5 )
			itemRewardPanel.Paint = function(self, w, h)
				draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255), Color(255, 255, 255) )
				draw.DrawText( self.uniqueIDItem.."  ["..self.uniqueIDItemCount.." шт.]", "DermaDefault", 5, 5, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT )
			end;
			itemRewardPanel.DoClick = function(self)
				local menu = DermaMenu()
				menu:AddOption( "Удалить линию", function()					
					ItemListForReward.rewardQuest["Rewitems"][itemRewardPanel.uniqueIDItem] = nil
					self:Remove();
				end):SetImage("icon16/cancel.png")
				menu:Open()			
			end;
	
			ItemListForReward.rewardQuest["Rewitems"][itemRewardPanel.uniqueIDItem] = itemRewardPanel.uniqueIDItemCount

		end;		
	end;
	addItemReward.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForReward.rewardQuest["Rewitems"]) < 2 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;

	----

	local TellMeShit1 = vgui.Create( "DTextEntry", frame )
	TellMeShit1:SetPos( 550, 365 )
	TellMeShit1:SetSize( 340, 20 )
	TellMeShit1:SetText( "" )
	TellMeShit1:SetMultiline(false)

	local TellMeShit2 = vgui.Create( "DTextEntry", frame )
	TellMeShit2:SetPos( 550, 395 )
	TellMeShit2:SetSize( 340, 20 )
	TellMeShit2:SetText( "" )
	TellMeShit2:SetMultiline(false)

	local TellMeShit3 = vgui.Create( "DTextEntry", frame )
	TellMeShit3:SetPos( 550, 425 )
	TellMeShit3:SetSize( 340, 20 )
	TellMeShit3:SetText( "" )
	TellMeShit3:SetMultiline(false)
	----

	local FactionPanel = vgui.Create( "DPanel", frame )
	FactionPanel:SetPos( 10, 260 )
	FactionPanel:SetSize( 300, 300 )
	FactionPanel.Paint = function(self, w, h)
	end;
	local FactionPanelI = vgui.Create( "DScrollPanel", FactionPanel )
	FactionPanelI:Dock( FILL )
	FactionPanelI.factions = {}
	local tableToCheck;

	if table.Count(entI["factionsAllowed"]) == 0 then
		tableToCheck = Clockwork.faction.stored;
	else
		tableToCheck = entI["factionsAllowed"];
	end;

	for k, v in pairs(tableToCheck) do
		local FactionBox = FactionPanelI:Add( "DCheckBoxLabel" )
		FactionBox:Dock(TOP)
		FactionBox:SetText( k )
		if table.Count(entI["factionsAllowed"]) == 0 then
			FactionPanelI.factions[k] = true;
		else
			FactionPanelI.factions[k] = v;
		end;
		FactionBox:SetValue(FactionPanelI.factions[k])
		function FactionBox:OnChange( val )
			FactionPanelI.factions[k] = val;
		end

	end;

	----
	local addQuest = vgui.Create( "DButton", frame )
	addQuest:SetText( "Добавить задачу" )
	addQuest:SetPos( 440, 230 )
	addQuest:SetSize( 100, 20 )	
	addQuest.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForQuestI.ItemsChoosen) < 5 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	addQuest.DoClick = function()
		if table.Count(ItemListForQuestI.ItemsChoosen) < 5 && !ItemListForQuestI.ItemsChoosen[itemUniqueID:GetValue()] && TypeofQuest:GetValue() != "Выбрать" && itemUniqueIDAmount:GetValue() > 0 && itemUniqueID:GetValue() != "" then
		local questPanel = ItemListForQuestI:Add( "DButton" )
		questPanel:Dock( TOP )
		questPanel.uniqueIDItem = itemUniqueID:GetValue();
		questPanel.uniqueIDItemCount = itemUniqueIDAmount:GetValue()
		questPanel:SetText("")
		questPanel:DockMargin( 5, 5, 5, 5 )
		questPanel.Paint = function(self, w, h)
			draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255), Color(255, 255, 255) )
			draw.DrawText( self.uniqueIDItem.."  ["..self.uniqueIDItemCount.." шт.]", "DermaDefault", 5, 5, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT )
		end;
		questPanel.DoClick = function(self)
			local menu = DermaMenu()
			menu:AddOption( "Удалить линию", function()
				table.RemoveByValue( ItemListForQuestI.QuestTasks["item"], self.uniqueIDItem )
				ItemListForQuestI.QuestTasks["amount"][self.uniqueIDItem] = nil
				ItemListForQuestI.ItemsChoosen[self.uniqueIDItem] = nil;
				self:Remove();
			end):SetImage("icon16/cancel.png")
			menu:Open()			
		end;

		ItemListForQuestI.ItemsChoosen[questPanel.uniqueIDItem] = questPanel.uniqueIDItemCount
			for k, v in pairs(ItemListForQuestI.ItemsChoosen) do
				if !table.HasValue(ItemListForQuestI.QuestTasks["item"], k) then
					table.insert(ItemListForQuestI.QuestTasks["item"], k)
					ItemListForQuestI.QuestTasks["amount"][k] = v
				end;
			end;
		ItemListForQuestI.QuestTasks["type"] = TypeofQuest:GetValue()
		end;
	end;

	local addInfo = vgui.Create( "DButton", frame )
	addInfo:SetText( "+" )
	addInfo:SetPos( 320, 220 )
	addInfo:SetSize( 100, 20 )
	addInfo.DoClick = function()
		if TextInfoHere:GetValue() == "" || (IndexInfo:GetValue() == "" || string.find(IndexInfo:GetValue(), "start") || string.find(IndexInfo:GetValue(), "quit")) || TypeOfInfo:GetValue() == "Выбрать" then
			return;
		end;
		if TypeOfInfo:GetValue() == "НПС" then
			local qline = QuestionPanel:AddLine(TextInfoHere:GetValue(), IndexInfo:GetValue());

			qline.uniqueID = IndexInfo:GetValue();
			qline.textDialogue = TextInfoHere:GetValue();
			qline.soundToSay = "";
			if table.Count(ItemListForQuestI.QuestTasks["item"]) > 0 then
				ItemListForQuestI.QuestTasks["reward"]["Rewitems"] = ItemListForReward.rewardQuest["Rewitems"];
				ItemListForQuestI.QuestTasks["reward"]["reputation"] = SalesLoyalityAmount:GetValue();
				ItemListForQuestI.QuestTasks["reward"]["loyality"] = LoyalityAmount:GetValue();
				ItemListForQuestI.QuestTasks["reward"]["cash"] = MoneyAmount:GetValue();

				qline.quest = ItemListForQuestI.QuestTasks;
			end;
		elseif TypeOfInfo:GetValue() == "Игрок" then
			local aline = AnwsersPanel:AddLine(TextInfoHere:GetValue(), IndexInfo:GetValue());

			aline.uniqueID = IndexInfo:GetValue();
			aline.textDialogue = TextInfoHere:GetValue();
			aline.soundToSay = "";		
		end;
	end;
	local saveAll = vgui.Create( "DButton", frame )
	saveAll:SetText( "SAVE" )
	saveAll:SetPos( 10, 570 )
	saveAll:SetSize( 100, 20 )
	saveAll.DoClick = function()
		local dialogueTable = {
			questions = {},
			anwsers = {}
		};
		local entInfo = {
			factionsAllowed = {},
			TalkOnNear = {};
		};

		for k, v in pairs(FactionPanelI.factions) do
			entInfo["factionsAllowed"][k] = v
		end;
		table.insert(entInfo["TalkOnNear"], TellMeShit1:GetText())
		table.insert(entInfo["TalkOnNear"], TellMeShit2:GetText())
		table.insert(entInfo["TalkOnNear"], TellMeShit3:GetText())

		for k, v in pairs(QuestionPanel:GetLines()) do
			dialogueTable.questions[v.uniqueID] = {
				info = v.textDialogue,
				sound = v.soundToSay,
				quest = v.quest or {}
			};
		end;
		for k, v in pairs(AnwsersPanel:GetLines()) do
			dialogueTable.anwsers[v.uniqueID] = {
				info = v.textDialogue,
				sound = v.soundToSay
			};
		end;

		cable.send('SaveDialogueInformation', dialogueTable, entity, entInfo);

		frame:Close(); frame:Remove();
	end	
end;

function BuySomeShit(ent, stock, infoLoy)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(75, 600)
    frame:SetTitle("")
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local UniqueItems = vgui.Create( "DScrollPanel", frame )
	UniqueItems:Dock( FILL )

	for k, v in pairs(stock) do
		local itemTable = UniqueItems:Add( "DPanel" )
		itemTable:Dock(TOP)
		itemTable:SetSize(0, 45)
		itemTable:DockMargin( 5, 5, 5, 5 )
		itemTable.Paint = function(self, w, h)
			if k >= 7 then
				draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(244, 83, 236) )
			else
				draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,150) )
			end;
			draw.DrawText( "X", "DermaDefault", 23, 15, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
		end;
		local ItemSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", itemTable ));
		ItemSpawnIcon:Dock(FILL);
		ItemSpawnIcon:SetModel( v.model, v.skin );
		ItemSpawnIcon.DoClick = function(self)
			frame:Close(); frame:Remove();
			BuySomeShit(ent, stock, infoLoy)
		end;
	end;
end;

function BuySomeShitEdit(ent, stock)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();
	local categories = {};
	
	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(900, 600)
    frame:SetTitle("")
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local UniqueItems = vgui.Create( "DScrollPanel", frame )
	UniqueItems:Dock( FILL )

	for k, v in SortedPairsByMemberValue(Clockwork.item.stored, "category") do
		if !v.isBaseItem then
			if (!categories[v.category]) then
				categories[v.category] = true;
			end;
		end;
	end;
	
	for k, v in pairs(categories) do
		local ColCat = vgui.Create( "DCollapsibleCategory", UniqueItems )
		ColCat:Dock(TOP)
		ColCat:SetExpanded( 0 )
		ColCat:SetLabel( k )
	end;
end;

function OpenItemBoard(inv, entity, entCount)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(900, 600)
    frame:SetTitle("")
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local itemList = vgui.Create( "DGrid", frame )
	itemList:SetPos(10, 10)
	itemList:SetCols( 35 )
	itemList:SetColWide( 55 )
	itemList:SetRowHeight(55)

	for k, v in pairs(inv) do
		local itemPanel = vgui.Create( "DPanel" )
		itemPanel:SetSize(45, 45)
		itemPanel.Paint = function(self, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(0,0,0,150) )
		end;

		local ItemSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", itemPanel ));
		ItemSpawnIcon:Dock(FILL);
		ItemSpawnIcon.SetMarkupToolTip(ItemSpawnIcon, [[Название: <color=255, 180, 80>]]..v.name..[[</color>
Цена: <color=255, 100, 100>]]..v.priceSales..[[</color>]])
		ItemSpawnIcon:SetModel( v.model, v.skin );
		ItemSpawnIcon.DoClick = function(self)
			entCount = entCount + v.priceSales
			cable.send('SellItemToNPC', v.uniqueID, v.itemID, entity, entCount);
			inv[k] = nil
			frame:Close(); frame:Remove();
			OpenItemBoard(inv, entity, entCount)
		end;

		itemList:AddItem( itemPanel )
	end;

end;

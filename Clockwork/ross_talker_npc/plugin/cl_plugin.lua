
local PLUGIN = PLUGIN;

function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if entity:GetClass() == "ross_talking_npc" then
		info.y = Clockwork.kernel:DrawInfo(entity:GetInfoName(), info.x, info.y, colorTargetID, info.alpha);
	end;
end;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();

	if (ec == "ross_talking_npc") then
		options["Поговорить"] = "ross_talking_openwindow";

		if (entity:GetIsCwu() && Clockwork.Client:GetFaction() == FACTION_CWU) || (entity:GetIsCwu() && Clockwork.player:IsAdmin(Clockwork.Client)) then
			options["Взять один блокнот"] = "ross_talker_cwu_give"
		end;

		if !entity:GetIsDisabled() then
			options["Продать предметы"] = "ross_talking_openSell";
		end;
		if !entity:GetIsDDD() then
			options["Купить предметы"] = "ross_talking_openBuy";
		end;

		if Clockwork.player:IsAdmin(Clockwork.Client) then
			options["Открыть настройки"] = "ross_talking_opensettings";
			options["Переключить режим продажи"] = "ross_t_barter_1";
			options["Переключить режим барахолки"] = "ross_t_barter_2";
		end;
	end;

end;

--[[
	Вопросы, ответы, разговор с НПС. 
--]]

function AddSomeQuestions(QuestionsOfTalker, text, owner, k, name)

	local Question = QuestionsOfTalker:Add( "DPanel" )
	Question:SetText( "" )
	Question:SetSize(0, 55)
	Question:Dock( TOP )
	Question:DockMargin( 5, 5, 5, 5 )
	Question:SetAlpha(0)
	Question.Paint = function(self, w, h)
		if owner == "sales" then
			draw.DrawText( name, "DermaDefault", 5, 0, Color(200, 255, 150, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( cutUpText(text["info"], 150), "DermaDefault", 5, 15, Color(200, 255, 150, 255), TEXT_ALIGN_LEFT )
		elseif owner == "alert" then
			draw.DrawText( "[Уведомление]", "DermaDefault", 5, 0, Color(200, 100, 100, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( cutUpText(text["info"], 150), "DermaDefault", 5, 15, Color(200, 100, 100, 255), TEXT_ALIGN_LEFT )
		else
			draw.DrawText( "Вы: ", "DermaDefault", 5, 0, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( cutUpText(text["info"], 150), "DermaDefault", 5, 15, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
		end;
	end;
	if owner == "sales" then
		Question:AlphaTo( 255, 1, 0, function() end);
	else
		Question:SetAlpha(255)
	end;
	if text["sound"] != "" then
		surface.PlaySound(text["sound"]);
	end;

end;

function AddSomeAnwsers(Anwsers, k, v, frame, tbl, QuestionsOfTalker, pq, id, r, entity, inv, n)
	local anwser = Anwsers:Add( "DButton" )
		anwser:SetText( "" )
		anwser:Dock( TOP )
		anwser:DockMargin( 5, 5, 5, 5 )
		anwser.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.DrawText( cutUpText(v["info"], 150), "DermaDefault", 10, 10, Color(100, 100, 255, 255), TEXT_ALIGN_LEFT )
			elseif !self:IsHovered() && !v.isUsed then
				draw.DrawText( cutUpText(v["info"], 150), "DermaDefault", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
			elseif !self:IsHovered() && v.isUsed then
				draw.DrawText( cutUpText(v["info"], 150), "DermaDefault", 10, 10, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT )
			end;
		end;
		anwser.DoClick = function(self)
			local hasQuest = PlayerhasQuest(pq, id.id);
			local questID = GetQuestID(pq, id.id);

			surface.PlaySound("ui/buttonclick.wav");
			if k == "quit" then
				frame:Close(); frame:Remove();
			end;
			if k == "taskIndex" then
				if hasQuest then
					Derma_Query( "Что вы хотите сделать с заданием, которое вам дал этот человек?", "Действия", 
					"Завершить", function()
						local quest = pq[ questID ];
						local isDoneContract = contractIsDone(quest, inv, n);
						local type =  quest.type;
						local a = quest.amount;

						if isDoneContract then
							cable.send('GiveReward', entity, questID );
							if type != "Убийство НПС" then 
								for k, v in pairs(inv) do
									if table.HasValue(quest.item, v.unqiueID) then
										inv[k] = nil;
									end;
								end;
							else
								for k, v in pairs(a) do
									n[k] = nil
								end;
							end;
						
							pq[ questID ] = nil;
							self:Remove();
						end;						
					end, 
					"Отменить", function() 
						local quest = pq[ questID ];
						local type =  quest.type;
						local a = quest.amount;
						
						cable.send('RemoveQuest', entity, questID);
						if type == "Убийство НПС" then
							for k, v in pairs(a) do
								n[k] = nil
							end;
						end;
						pq[ questID ] = nil;
						self:Remove();
					end, 
					"Получить подробности", function()
						local quest = pq[ questID ];
						local rewards = {};
						local needs = {};

						for k, v in pairs(quest.amount) do
							table.insert(needs, k.."["..v.."]")
						end;
						for k, v in pairs(quest.reward["Rewitems"]) do
						    table.insert(rewards, k.."["..v.."]")
						end;					
						Derma_Message( "Название: "..quest.type.."\nНеобходимые предметы:"..string.Implode(", ", needs).."\nНаграда:"..string.Implode(", ", rewards).."\nТокены:"..quest.reward["cash"].."\nЛояльность:"..quest.reward["loyality"].."\nРепутация:"..quest.reward["reputation"].."\n", "Информация", "Понял." )

					end, 
					"Не важно.", function() 
						return;
					end);					
				end;
			end;
			for index, contain in pairs(tbl["questions"]) do			
				if k == index then
				v.isUsed = true
					AddSomeQuestions(QuestionsOfTalker, v, "player", k, id.name)
					if table.Count(contain["quest"]) != 0 && (!playerCanTakeQuest(pq, id.id) || r < contain["quest"]["neededLoyality"]) then
						AddSomeQuestions(QuestionsOfTalker, {info = "Вы не можете взять это задание!", sound = ""}, "alert", "alertPlayerQuest"..math.random(1, 100000), id.name)
					else
						AddSomeQuestions(QuestionsOfTalker, contain, "sales", k, id.name)
					end;
					if next(contain["quest"]) != nil && playerCanTakeQuest(pq, id.id) && r >= contain["quest"]["neededLoyality"] then
						if table.Count(contain["quest"]["item"]) > 0 then

							local function displayItem(itemTable)
								local item = "Неизвестно"
								if table.Count(itemTable["item"]) == 1 then 
									return itemTable["item"][1].."["..itemTable["amount"][itemTable["item"][1]].."]"
								else
									return itemTable["item"][1].."["..itemTable["amount"][itemTable["item"][1]].."]".." и более..."
								end;

								return item
							end;

							Derma_Query( displayItem(contain["quest"]), contain["quest"]["type"],
							"Берусь!", function()
								table.insert(pq, contain["quest"])
								cable.send('QuestAddPlayer', contain["quest"]);
								AddSomeQuestions(QuestionsOfTalker, {info = "Вы взяли задание.", sound = ""}, "alert", "alertPlayerQuest"..math.random(1, 100000), id.name)
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

function OpenTalkingMenu(tbl, entity, id, quests, renown, inv, n)
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
			AddSomeQuestions(QuestionsOfTalker, v, "sales", k, id.name)
		end;
	end;

	for k, v in pairs(tbl["anwsers"]) do
		AddSomeAnwsers(Anwsers, k, v, frame, tbl, QuestionsOfTalker, quests, id, renown, entity, inv, n)
	end;
	if PlayerhasQuest(quests, id.id) then
		AddSomeAnwsers(Anwsers, "taskIndex", {
			info = "По поводу задания...",
			sound = "",
			isUsed = false
		}, frame, tbl, QuestionsOfTalker, quests, id, renown, entity, inv, n)
	end;

end;

--[[
	Настройки НПС.
--]]

function SettingsMenu(tbl, entity, entI, id)
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

		draw.DrawText( "Лояльность: ", "DermaDefault", 550, 340, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
		draw.DrawText( "Репутация: ", "DermaDefault", 650, 340, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
		draw.DrawText( "Деньги: ", "DermaDefault", 745, 340, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
		draw.DrawText( "Нужно лояльности: ", "DermaDefault", 410, 310, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
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
				local bufferQuests = l.quest
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
			if l.uniqueID == "quit" || l.uniqueID == "taskIndex" then
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
				local bufferIsUsed = l.isUsed;
				AnwsersPanel:RemoveLine(AnwsersPanel:GetSelectedLine())
				AnwsersPanel:ClearSelection()

				local aline = AnwsersPanel:AddLine(text, bufferID);
				aline.uniqueID = bufferID;
				aline.textDialogue = text;
				aline.soundToSay = bufferSound;	
				aline.isUsed = bufferIsUsed;	
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
		aline.isUsed = v["isUsed"];
	end;

	local TextInfoHere = vgui.Create( "DTextEntry", frame )
	TextInfoHere:SetPos( 10, 180 )
	TextInfoHere:SetSize( 300, 75 )
	TextInfoHere:SetText( "" )
	TextInfoHere:SetMultiline(true)
	TextInfoHere:SetPlaceholderText("Текст сообщения.")  
	TextInfoHere.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;

	local TypeOfInfo = vgui.Create( "DComboBox", frame )
	TypeOfInfo:SetPos( 320, 180 )
	TypeOfInfo:SetSize( 100, 20 )
	TypeOfInfo:SetValue( "" )
	TypeOfInfo:AddChoice( "НПС" )
	TypeOfInfo:AddChoice( "Игрок" )
	TypeOfInfo.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;

	local IndexInfo = vgui.Create( "DTextEntry", frame )
	IndexInfo:SetPos( 320, 200 )
	IndexInfo:SetSize( 100, 20 )
	IndexInfo:SetText( "" )
	IndexInfo:SetPlaceholderText("Индекс.")  
	IndexInfo.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;

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
		type = "",
		sellerInfo = {
			name = "",
			id = 0
		},
		neededLoyality = 0
	}
	ItemListForQuestI.ItemsChoosen = {}

	local itemUniqueID = vgui.Create( "DTextEntry", frame )
	itemUniqueID:SetPos( 440, 205 )
	itemUniqueID:SetSize( 68, 20 )
	itemUniqueID:SetText( "" )
	itemUniqueID:SetPlaceholderText("ID предмета.")  
	itemUniqueID.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;
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
	itemUniqueIDAmount.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
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
	TypeofQuest:SetValue( "" )
	TypeofQuest:AddChoice( "Сбор предметов" )
	TypeofQuest:AddChoice( "Убийство НПС" )
	TypeofQuest.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	TypeofQuest.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" && table.Count(ItemListForQuestI.ItemsChoosen) == 0 then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	----

	local QuestNeedLoyality = vgui.Create( "DNumberWang", frame )
	QuestNeedLoyality:SetPos( 510, 310 )
	QuestNeedLoyality:SetSize( 30, 20 )
	QuestNeedLoyality:SetMinMax( 0, 50 )
	QuestNeedLoyality.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	QuestNeedLoyality.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;

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
	SalesLoyalityAmount:SetPos( 615, 340 )
	SalesLoyalityAmount:SetSize( 30, 20 )
	SalesLoyalityAmount:SetValue( "" )
	SalesLoyalityAmount:SetMinMax( 0, 25 )
	SalesLoyalityAmount.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	SalesLoyalityAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local LoyalityAmount = vgui.Create( "DNumberWang", frame )
	LoyalityAmount:SetPos( 710, 340 )
	LoyalityAmount:SetSize( 30, 20 )
	LoyalityAmount:SetValue( 0 )
	LoyalityAmount:SetMinMax( 0, 10 )
	LoyalityAmount.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	LoyalityAmount.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
			self:SetEnabled(true)
		else
			self:SetEnabled(false)
		end;
	end;
	local MoneyAmount = vgui.Create( "DNumberWang", frame )
	MoneyAmount:SetPos( 790, 340 )
	MoneyAmount:SetSize( 30, 20 )
	MoneyAmount:SetValue( 0 )
	MoneyAmount:SetMinMax( 0, 10 )
	MoneyAmount.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
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
	itemUniqueIDReward.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	itemUniqueIDReward.Think = function(self)
		if TypeOfInfo:GetValue() == "НПС" then
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
	itemUniqueIDAmountReward.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
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
	
			ItemListForQuestI.QuestTasks["neededLoyality"] = QuestNeedLoyality:GetValue()
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
	local SettingsList = vgui.Create( "DPanel", frame )
	SettingsList:SetPos( 550, 365 )
	SettingsList:SetSize( 340, 200 )
	SettingsList.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 150));
	end;
	local SettingsListChild = vgui.Create( "DScrollPanel", SettingsList )
	SettingsListChild:Dock( FILL )

	local TellMeShit1 = vgui.Create( "DTextEntry", SettingsListChild )
	TellMeShit1:SetPos( 0, 5 )
	TellMeShit1:SetSize( 340, 20 )
	TellMeShit1:SetText( entI.TalkOnNear[1] )
	TellMeShit1:SetMultiline(false)
	TellMeShit1:SetPlaceholderText("Фраза при отказе в доступе.")  
  	TellMeShit1.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;

	local TellMeShit2 = vgui.Create( "DTextEntry", SettingsListChild )
	TellMeShit2:SetPos( 0, 35 ) -- + 50
	TellMeShit2:SetSize( 340, 20 )
	TellMeShit2:SetText( entI.TalkOnNear[2] )
  	TellMeShit2:SetMultiline(false)
	TellMeShit2:SetPlaceholderText( "Фраза при отключенном режиме." )
	TellMeShit2.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;

	local TellMeShit3 = vgui.Create( "DTextEntry", SettingsListChild )
	TellMeShit3:SetPos( 0, 65 )
	TellMeShit3:SetSize( 340, 20 )
	TellMeShit3:SetText( entI.TalkOnNear[3] )
  	TellMeShit3:SetMultiline(false)
	TellMeShit3:SetPlaceholderText( "Фраза 3 для проходящего мимо" )
	TellMeShit3.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;
	TellMeShit3:Hide();

	local SellerName = vgui.Create( "DTextEntry", SettingsListChild )
	SellerName:SetPos( 0, 90 )
	SellerName:SetSize( 100, 20 )
	SellerName:SetText( id.name )
  	SellerName:SetMultiline(false)
	SellerName:SetPlaceholderText( "Имя продавца" )
	SellerName.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;    
  
  	local Model = vgui.Create( "DTextEntry", SettingsListChild )
	Model:SetPos( 110, 90 )
	Model:SetSize( 130, 20 )
	Model:SetText( entI.sellerMdl )
  	Model:SetMultiline(false)
	Model:SetPlaceholderText( "Внешний вид" )
	Model.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));

		if self:GetText() == "" && self:GetPlaceholderText() then
			draw.DrawText( self:GetPlaceholderText(), "DermaDefault", 5, 3.5, Color(232, 187, 8, 150), TEXT_ALIGN_LEFT )
		end;
	end;    

  	local AnimationNumber = vgui.Create( "DNumberWang", SettingsListChild )
	AnimationNumber:SetPos( 250, 90 )
	AnimationNumber:SetSize( 30, 20 )
	AnimationNumber:SetValue( entI.sequence )
	AnimationNumber:SetMinMax( 1, 1000 )
	AnimationNumber:SetMax(1000)
	AnimationNumber.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;

	local IsCWU = vgui.Create( "DCheckBoxLabel", SettingsListChild )
	IsCWU:SetPos(5, 130)
	IsCWU:SetText( "Является ли сотрудником ГСР?" )
	IsCWU:SetValue(tobool(id.isCwu))
	function IsCWU:OnChange( val )
		id["isCwu"] = tobool(val);
	end

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
		ItemListForQuestI.QuestTasks["sellerInfo"]["name"] = id["name"]
		ItemListForQuestI.QuestTasks["sellerInfo"]["id"] = id["id"]
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
			aline.isUsed = false;	
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
		entI["factionsAllowed"] = FactionPanelI.factions;
		entI["TalkOnNear"] = {
			TellMeShit1:GetValue(),
			TellMeShit2:GetValue(),
			TellMeShit3:GetValue()
		};
		entI["sequence"] = AnimationNumber:GetValue();
		entI["sellerMdl"] = Model:GetValue();
		id["name"] = SellerName:GetValue();

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
				sound = v.soundToSay,
				isUsed = v.isUsed
			};
		end;

		cable.send('SaveDialogueInformation', entity, {dialogueTable, entI, id});

		frame:Close(); frame:Remove();
	end	
end;

--[[
	Покупка предметов. 
--]]

function BuySomeShit(ent, stock, tokens)
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
		if ( self.m_bBackgroundBlur ) then
            Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
        end
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
			elseif v.count == 0 || ((tokens - v.price) < 0 || tokens == 0) && k < 7 then
				draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 100, 100) )
			elseif v.count > 0 || ((tokens - v.price) >= 0 || tokens > 0) && k < 7 then
				draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(0, 255, 0) )
			end;
			if v.model == "" then
				draw.DrawText( "X", "DermaDefault", 23, 15, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT )
			end;
		end;
		if v.model != "" then
			local ItemSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", itemTable ));
			ItemSpawnIcon:Dock(FILL);
			ItemSpawnIcon:SetModel( v.model, v.skin );
			ItemSpawnIcon.SetMarkupToolTip(ItemSpawnIcon, [[Название: <color=255, 180, 80>]]..Clockwork.item:FindByID(v.uniqueID).name..[[</color>
Цена: <color=255, 100, 100>]]..v.price..[[</color>]])
			ItemSpawnIcon.DoClick = function(self)
				if ((tokens - v.price) >= 0 && tokens > 0) && v.count > 0 && Clockwork.player:CanHoldWeight(Clockwork.item:FindByID(v.uniqueID).weight) then
					tokens = tokens - v.price
					
					stock[k]["count"] = stock[k]["count"] - 1;
					cable.send('GiveSalesItem', ent, {k, v, v.price});
					frame:Close(); frame:Remove();
					BuySomeShit(ent, stock, tokens)
					surface.PlaySound("ui/buttonclick.wav");
				else
					surface.PlaySound("common/wpn_denyselect.wav");
				end;
			end;
			ItemSpawnIcon.DoRightClick = function( self )
				if !Clockwork.player:IsAdmin(Clockwork.Client) then
					return;
				end;

				local menu = DermaMenu()
				menu:AddOption( "Изменить предмет в ячейке", function()
					Derma_StringRequest( "Изменить предмет в ячейке", "Изменить предмет в ячейке", Clockwork.item:FindByID(v.uniqueID).name, 
					function(text)
						if Clockwork.item:FindByID(text) then
							stock[k]["uniqueID"] = text;
							cable.send('ManipulateItems', ent, {k, v});
							frame:Close(); frame:Remove();
							BuySomeShit(ent, stock, tokens)
						end;
					end)
				end):SetImage("icon16/application_edit.png")
				if stock[k]["uniqueID"] != "" then
					menu:AddOption( "Изменить цену ячейки", function()
						Derma_StringRequest( "Изменить цену предмета", "Изменить цену предмета", Clockwork.item:FindByID(v.uniqueID).priceSales, 
						function(text)
							if Clockwork.item:FindByID(v.uniqueID) then
								stock[k]["price"] = text;
								cable.send('ManipulateItems', ent, {k, v});
								frame:Close(); frame:Remove();
								BuySomeShit(ent, stock, tokens)
							end;
						end)
					end):SetImage("icon16/application_edit.png")
					menu:AddOption( "Изменить количество предмета", function()
						Derma_StringRequest( "Изменить количество предмета", "Изменить количество предмета", v.count, 
						function(text)
							if Clockwork.item:FindByID(v.uniqueID) then
								stock[k]["count"] = tonumber(text);
								cable.send('ManipulateItems', ent, {k, v});
								frame:Close(); frame:Remove();
								BuySomeShit(ent, stock, tokens)
							end;
						end)
					end):SetImage("icon16/application_edit.png")
					menu:AddOption( "Удалить предмет", function()
						if Clockwork.item:FindByID(v.uniqueID) then
							stock[k] = {
								uniqueID = "",
								price = 0,
								model = "",
								skin = 0,
								count = 0
							};
							cable.send('ManipulateItems', ent, {k, {
								uniqueID = "",
								price = 0,
								model = "",
								skin = 0,
								count = 0
							}});
							frame:Close(); frame:Remove();
							BuySomeShit(ent, stock, tokens)
						end;
					end):SetImage("icon16/application_edit.png")
				end;
				menu:Open()
			end;
		elseif v.model == "" then
			local addItemReward = vgui.Create( "DButton", itemTable )
			addItemReward:SetText( "" )
			addItemReward:Dock(FILL);
			addItemReward.DoClick = function()
				if !Clockwork.player:IsAdmin(Clockwork.Client) then
					return;
				end;

				local menu = DermaMenu()
				menu:AddOption( "Изменить предмет в ячейке", function()
					Derma_StringRequest( "Изменить предмет в ячейке", "Изменить предмет в ячейке", Clockwork.item:FindByID(v.uniqueID).name, 
					function(text)
						if Clockwork.item:FindByID(text) then
							stock[k]["uniqueID"] = text;
							stock[k]["model"] = Clockwork.item:FindByID(text).model
							stock[k]["skin"] = Clockwork.item:FindByID(text).skin
							stock[k]["price"] = 1
							stock[k]["count"] = 1
							cable.send('ManipulateItems', ent, {k, v});
							frame:Close(); frame:Remove();
							BuySomeShit(ent, stock, tokens)							
						end;
					end)
				end):SetImage("icon16/application_edit.png")
				menu:Open()
			end;	
			addItemReward.Paint = function(self, w, h)
				draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,0) )
			end;		
		end;
	end;

	local closebtn = vgui.Create( "DButton", UniqueItems )
	closebtn:SetText("[X]")
	closebtn:SetPos( 5, 500 )
	closebtn:SetSize(60, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 0));
		end;
	end;
	
    closebtn.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
        frame:Close(); frame:Remove();
	end;

end;

--[[
	Продажа предметов
--]]

function OpenItemBoard(entity, inv, entInv)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();
	local ply = Clockwork.Client;
	local tokens = ply:GetSharedVar("Cash")
	
	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(170, 600)
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

		if ( self.m_bBackgroundBlur ) then
            Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		end;
		
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[Назад]")
	closebtn:SetPos( 10, 550 )
	closebtn:SetSize(150, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBoxOutlined( 0, 0, 0, x, y, Color(0, 0, 0, 150), Color(255, 180, 80) )
		end;
	end;
	
    closebtn.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
        frame:Close(); frame:Remove();
    end;
    
    local itemPanel = vgui.Create( "DPanel", frame )
    itemPanel:SetPos(10, 10)
	itemPanel:SetSize(60, 530)
	itemPanel.Paint = function(self, w, h)
		draw.RoundedBox( 2, 0, 0, w, h, Color(0,0,0,150) )
    end;

    local itemPanelScroll = vgui.Create( "DScrollPanel", itemPanel )
	itemPanelScroll:Dock( FILL );
	itemPanelScroll:DockMargin( 7, 8, 5, 5 )
    
	for k, v in pairs(entInv) do
		
        local sItem = itemPanelScroll:Add( "DPanel" )
		sItem:SetSize(45, 45)
		sItem:Dock( TOP )
		
		sItem.Paint = function(self, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(0,0,0,150) )
		end;

		local sItemIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", sItem ));
		sItemIcon:Dock(FILL);
		sItemIcon.SetMarkupToolTip(sItemIcon, "Название: <color=255, 180, 80>"..v.name.."</color>\nЦена: <color=255, 100, 100>"..v.priceSales.."</color>")
		sItemIcon:SetModel( v.model, v.skin );
		sItemIcon.DoClick = function(self)
			local validitem = Clockwork.player:CanHoldWeight(Clockwork.item:FindByID(v.uniqueID).weight);
			if ((ply:GetSharedVar("Cash") - v.priceSales) >= 0 && ply:GetSharedVar("Cash") > 0) && validitem && entInv[k] then
				cable.send('BuyItemNPCSeller', entity, {v.uniqueID, v.itemID, v.priceSales, k} );
				table.insert(inv, v)
				v['priceSales'] = v['priceSales'] - 10
				entInv[k] = nil;
				frame:Close(); frame:Remove();
				OpenItemBoard(entity, inv, entInv)
			end;
			
		end;

    end;
    
    local inventory = vgui.Create( "DPanel", frame )
    inventory:SetPos(100, 10)
	inventory:SetSize(60, 530)
	inventory.Paint = function(self, w, h)
		draw.RoundedBox( 2, 0, 0, w, h, Color(0,0,0,150) )
    end;
    
	local inventoryScroll = vgui.Create( "DScrollPanel", inventory )
	inventoryScroll:Dock( FILL );
	inventoryScroll:DockMargin( 7, 8, 5, 5 )
    
	for k, v in pairs(inv) do
		
		local pItem = inventoryScroll:Add( "DPanel" )
		pItem:SetSize(45, 45)
		pItem:Dock( TOP )
		
		pItem.Paint = function(self, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(0,0,0,150) )
		end;

		local pItemIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", pItem ));
		pItemIcon:Dock(FILL);
		pItemIcon.SetMarkupToolTip(pItemIcon, "Название: <color=255, 180, 80>"..v.name.."</color>\nЦена: <color=255, 100, 100>"..v.priceSales.."</color>")
		pItemIcon:SetModel( v.model, v.skin );
		pItemIcon.DoClick = function(self)
			
			cable.send('SellItemToSeller', entity, {v.uniqueID, v.itemID, v.priceSales, k} );
			table.insert(entInv, v)
			v['priceSales'] = v['priceSales'] + 10
			inv[k] = nil;
			frame:Close(); frame:Remove();
			OpenItemBoard(entity, inv, entInv)
			
		end;

    end;

end; -- Остановился на том, что нужно доработать размеры иконок.

cable.receive('TalkToMeNPC', function(table, entity, index, quests, r, inv, npcs)
    OpenTalkingMenu(table, entity, index, quests, r, inv, npcs)
end);

cable.receive('SettingsNPCTalker', function(table, entity, entI, id)
    
	SettingsMenu(table, entity, entI, id)
end);

cable.receive('SellItemsTalkerNPC', function(entity, inventory, entinventory)
	
	OpenItemBoard(entity, inventory, entinventory)
end);

cable.receive('BuyItemsLoyality', function(ent, stock, tokens)
    
	BuySomeShit(ent, stock, tokens)
end);
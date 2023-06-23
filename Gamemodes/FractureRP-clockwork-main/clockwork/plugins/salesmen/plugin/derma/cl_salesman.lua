--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local salesmanName = Clockwork.salesman:GetName();
	
	self:SetTitle(salesmanName);
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
		self:Close(); self:Remove();
		
		Clockwork.datastream:Start("SalesmanAdd", {
			showChatBubble = Clockwork.salesman.showChatBubble,
			buyInShipments = Clockwork.salesman.buyInShipments,
			priceScale = Clockwork.salesman.priceScale,
			factions = Clockwork.salesman.factions,
			physDesc = Clockwork.salesman.physDesc,
			buyRate = Clockwork.salesman.buyRate,
			classes = Clockwork.salesman.classes,
			stock = Clockwork.salesman.stock,
			model = Clockwork.salesman.model,
			sells = Clockwork.salesman.sells,
			cash = Clockwork.salesman.cash,
			text = Clockwork.salesman.text,
			buys = Clockwork.salesman.buys,
			name = Clockwork.salesman.name
		});
		
		Clockwork.salesman.priceScale = nil;
		Clockwork.salesman.factions = nil;
		Clockwork.salesman.classes = nil;
		Clockwork.salesman.physDesc = nil;
		Clockwork.salesman.buyRate = nil;
		Clockwork.salesman.stock = nil;
		Clockwork.salesman.model = nil;
		Clockwork.salesman.sells = nil;
		Clockwork.salesman.buys = nil;
		Clockwork.salesman.items = nil;
		Clockwork.salesman.text = nil;
		Clockwork.salesman.cash = nil;
		Clockwork.salesman.name = nil;
		
		gui.EnableScreenClicker(false);
	end;
	
	self.sellsPanel = vgui.Create("cwPanelList");
 	self.sellsPanel:SetPadding(4);
 	self.sellsPanel:SetSpacing(4);
 	self.sellsPanel:SizeToContents();
	self.sellsPanel:EnableVerticalScrollbar();
    self.sellsPanel.Paint = function(self, w, h)
    draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) );
    end

	self.buysPanel = vgui.Create("cwPanelList");
 	self.buysPanel:SetPadding(4);
 	self.buysPanel:SetSpacing(4);
 	self.buysPanel:SizeToContents();
	self.buysPanel:EnableVerticalScrollbar();
	self.buysPanel.Paint = function(self, x, y)
    draw.RoundedBox( 0, 0, 0, x, y, Color( 0, 0, 0, 150 ) );
    end
	
	self.itemsPanel = vgui.Create("cwPanelList");
 	self.itemsPanel:SetPadding(4);
 	self.itemsPanel:SetSpacing(4);
 	self.itemsPanel:SizeToContents();
	self.itemsPanel:EnableVerticalScrollbar();
    self.itemsPanel.Paint = function(self, x, y)
    draw.RoundedBox( 0, 0, 0, x, y, Color( 0, 0, 0, 150 ) );
    end
	
	self.settingsPanel = vgui.Create("cwPanelList");
 	self.settingsPanel:SetPadding(4);
 	self.settingsPanel:SetSpacing(4);
 	self.settingsPanel:SizeToContents();
	self.settingsPanel:EnableVerticalScrollbar();
    self.settingsPanel.Paint = function(self, x, y)
    draw.RoundedBox( 0, 0, 0, x, y, Color( 0, 0, 0, 150 ) );
    end	
	
	self.settingsForm = vgui.Create("cwForm");
	self.settingsForm:SetPadding(4);
	self.settingsForm:SetName("Настройки");
	self.settingsForm.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 150 ) );
	end;
	
	self.settingsPanel:AddItem(self.settingsForm);

	self.showChatBubble = self.settingsForm:CheckBox("Показывать значок чата над головой.");
	self.showChatBubble:SetDark(true);
	
	self.buyInShipments = self.settingsForm:CheckBox("Покупать вещи в x5-количестве (Отключайте).");
	self.buyInShipments:SetDark(true);

	self.priceScale = self.settingsForm:TextEntry("Сумма в масштабе цен.");
	-- self.priceScale:SetDark(true);

	self.physDesc = self.settingsForm:TextEntry("Физическое описание продавца.");

	self.buyRate = self.settingsForm:NumSlider("Курс покупок.", nil, 1, 100, 0);

	self.stock = self.settingsForm:NumSlider("Количество товара по умолчанию.", nil, -1, 100, 0);

	self.model = self.settingsForm:TextEntry("Модель продавца.");

	self.cash = self.settingsForm:NumSlider("Стартовый капитал.", nil, -1, 1000000, 0);
	
	self.buyRate:SetToolTip("Процент цены при продаже.");
	self.stock:SetToolTip("Количество по умолчанию для каждого продукта (-1 для бесконечного кол-ва).");
	self.cash:SetToolTip("Старовый капитал торговца (-1 для бесконечного капитала).");

	self.showChatBubble:SetValue(Clockwork.salesman.showChatBubble == true);
	self.buyInShipments:SetValue(Clockwork.salesman.buyInShipments == true);
	self.priceScale:SetValue(Clockwork.salesman.priceScale);
	self.physDesc:SetValue(Clockwork.salesman.physDesc);
	self.buyRate:SetValue(Clockwork.salesman.buyRate);
	self.stock:SetValue(Clockwork.salesman.stock);
	self.model:SetValue(Clockwork.salesman.model);
	self.cash:SetValue(Clockwork.salesman.cash);
	
	self.responsesForm = vgui.Create("cwForm");
	self.responsesForm:DockPadding(0, 4, 0, 4);
	self.responsesForm:SetName("Фразы");
	self.settingsForm:AddItem(self.responsesForm);
	self.responsesForm.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) );
	end;

	self.startText = self.responsesForm:TextEntry("Когда игрок начинает торговаться.");
	self.startSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.startHideName = self.responsesForm:CheckBox("Скрывать имя продавца.");
    self.startHideName:SetDark( true )
	
	self.noSaleText = self.responsesForm:TextEntry("В случае, если игрок не может торговаться.");
	self.noSaleSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.noSaleHideName = self.responsesForm:CheckBox("Скрывать имя продавца.");
    self.noSaleHideName:SetDark( true )

	self.noStockText = self.responsesForm:TextEntry("Когда продавец не имеет предмета в наличии.");
	self.noStockSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.noStockHideName = self.responsesForm:CheckBox("Скрывать имя продавца.");
    self.noStockHideName:SetDark( true )

	self.needMoreText = self.responsesForm:TextEntry("Когда игрок не может позволить себе предмет.");
	self.needMoreSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.needMoreHideName = self.responsesForm:CheckBox("Скрывать имя продавца.");
    self.needMoreHideName:SetDark( true )

	self.cannotAffordText = self.responsesForm:TextEntry("Когда продавец не может себе позволить покупку товара у игрока.");
	self.cannotAffordSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.cannotAffordHideName = self.responsesForm:CheckBox("Скрывать имя продавца.")
	self.cannotAffordHideName:SetDark( true )

	self.doneBusinessText = self.responsesForm:TextEntry("Когда игрок заканчивает торговаться.");
	self.doneBusinessSound = self.responsesForm:TextEntry("Звук, который будет проигрываться при произношении фразы.");
	self.doneBusinessHideName = self.responsesForm:CheckBox("Скрывать имя продавца.")
	self.doneBusinessHideName:SetDark( true )

	Clockwork.salesman.text.start = Clockwork.salesman.text.start or {};
	
	self.startText:SetValue(Clockwork.salesman.text.start.text or "Как могу помочь?");
	self.startSound:SetValue(Clockwork.salesman.text.start.sound or "");

	self.startHideName:SetValue(Clockwork.salesman.text.start.bHideName == true);

	self.noSaleText:SetValue(Clockwork.salesman.text.noSale.text or "Я не могу продавать мои предметы тебе!");
	self.noSaleSound:SetValue(Clockwork.salesman.text.noSale.sound or "");

	self.noSaleHideName:SetValue(Clockwork.salesman.text.noSale.bHideName == true);

	self.noStockText:SetValue(Clockwork.salesman.text.noStock.text or "У меня нет данной вещи в наличии!");
	self.noStockSound:SetValue(Clockwork.salesman.text.noStock.sound or "");

	self.noStockHideName:SetValue(Clockwork.salesman.text.noStock.bHideName == true);
	
	self.needMoreText:SetValue(Clockwork.salesman.text.needMore.text or "Вы не можете позволить себе данный предмет себе!");
	self.needMoreSound:SetValue(Clockwork.salesman.text.needMore.sound or "");

	self.needMoreHideName:SetValue(Clockwork.salesman.text.needMore.bHideName == true);

	self.cannotAffordText:SetValue(Clockwork.salesman.text.cannotAfford.text or "Я не могу позволить себе купить у Вас это!");
	self.cannotAffordSound:SetValue(Clockwork.salesman.text.cannotAfford.sound or "");

	self.cannotAffordHideName:SetValue(Clockwork.salesman.text.cannotAfford.bHideName == true);

	self.doneBusinessText:SetValue(Clockwork.salesman.text.doneBusiness.text or "Увидимся.");
	self.doneBusinessSound:SetValue(Clockwork.salesman.text.doneBusiness.sound or "");

	self.doneBusinessHideName:SetValue(Clockwork.salesman.text.doneBusiness.bHideName == true);
	
	self.factionsForm = vgui.Create("DForm");
	self.factionsForm:DockPadding(0, 4, 0, 4);
	self.factionsForm:SetName("Фракции");
	self.settingsForm:AddItem(self.factionsForm);
	self.factionsForm:Help("Оставьте все без галочки, чтобы разрешить всем фракциям разговаривать с данным NPC.");
	--self.factionsForm:SetBright( true )
	self.factionsForm.Paint = function(self, x, y)
       	draw.RoundedBox( 8, 0, 0, x, y, Color( 255, 255, 255, 50 ) );
      -- 	surface.SetTextColor(255, 255, 255)
       --	self:SetTextColor(Color(0, 0, 0))
    end;
	
	self.classesForm = vgui.Create("DForm");
	self.classesForm:DockPadding(0, 4, 0, 4);
	self.classesForm:SetName("Классы");
	self.settingsForm:AddItem(self.classesForm); -- SetTextColor(Color(255, 255, 255, 255));
	self.classesForm:Help("Оставьте все без галочки, чтобы разрешить всем классам разговаривать с данным NPC.");
	self.classesForm.Paint = function(self, x, y)
       	draw.RoundedBox( 8, 0, 0, x, y, Color( 255, 255, 255, 50 ) );
    end;

	self.classBoxes = {};
	self.factionBoxes = {};
	
	for k, v in pairs(Clockwork.faction.stored) do
		self.factionBoxes[k] = self.factionsForm:CheckBox(v.name);
		self.factionBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				Clockwork.salesman.factions[k] = true;
			else
				Clockwork.salesman.factions[k] = nil;
			end;
		end;
		
		if (Clockwork.salesman.factions[k]) then
			self.factionBoxes[k]:SetValue(true);
			self.factionBoxes[k]:SetTextColor(Color(255, 255, 255))
		end;
	end;
	
	for k, v in pairs(Clockwork.class.stored) do
		self.classBoxes[k] = self.classesForm:CheckBox(v.name);
		self.classBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				Clockwork.salesman.classes[k] = true;
			else
				Clockwork.salesman.classes[k] = nil;
			end;
		end;
		
		if (Clockwork.salesman.classes[k]) then
			self.classBoxes[k]:SetValue(true);
		end;
	end;
	
	self.propertySheet = vgui.Create("DPropertySheet", self);
		self.propertySheet:SetPadding(4);
		self.propertySheet:AddSheet("Продает", self.sellsPanel, "icon16/box.png", nil, nil, "Посмотреть вещи, которые "..salesmanName.." продает.");
		self.propertySheet:AddSheet("Покупает", self.buysPanel, "icon16/add.png", nil, nil, "Посмотреть вещи, которые "..salesmanName.." покупает.");
		self.propertySheet:AddSheet("Предметы", self.itemsPanel, "icon16/application_view_tile.png", nil, nil, "Посмотреть возможные предметы для торговли.");
		self.propertySheet:AddSheet("Настройки", self.settingsPanel, "icon16/tick.png", nil, nil, "Посмотреть возможные настройки данного NPC.");
	Clockwork.kernel:SetNoticePanel(self);
	self.propertySheet.Paint = function(self, x, y)
       	draw.RoundedBox( 0, 0, 0, x, y, Color( 0, 0, 0, 150 ) );
    end;
end;

-- A function to rebuild a panel.
function PANEL:RebuildPanel(panelList, typeName, inventory)
	panelList:Clear(true);
	panelList.typeName = typeName;
	panelList.inventory = inventory;
	
	local categories = {};
	local items = {};
	
	for k, v in pairs(panelList.inventory) do
		local itemTable = Clockwork.item:FindByID(k);
		
		if (itemTable) then
			local category = itemTable("category");
			
			if (category) then
				items[category] = items[category] or {};
				items[category][#items[category] + 1] = {k, v};
			end;
		end;
	end;
	
	for k, v in pairs(items) do
		categories[#categories + 1] = {
			category = k,
			items = v
		};
	end;
	
	if (table.Count(categories) > 0) then
		for k, v in pairs(categories) do
			local collapsibleCategory = Clockwork.kernel:CreateCustomCategoryPanel(v.category, panelList);
				collapsibleCategory:SetCookieName("Salesman"..typeName..v.category);
			panelList:AddItem(collapsibleCategory);
			 
			local categoryList = vgui.Create("DPanelList", collapsibleCategory);
				categoryList:EnableHorizontal(true);
				categoryList:SetAutoSize(true);
				categoryList:SetPadding(4);
				--categoryList:SetTextColor(Color(255, 255, 255));
				categoryList:SetSpacing(4);
			collapsibleCategory:SetContents(categoryList);
			
			table.sort(v.items, function(a, b)
				local itemTableA = Clockwork.item:FindByID(a[1]);
				local itemTableB = Clockwork.item:FindByID(b[1]);
				
				return itemTableA("cost") < itemTableB("cost");
			end);
			
			for k2, v2 in pairs(v.items) do
				CURRENT_ITEM_DATA = {
					itemTable = Clockwork.item:FindByID(v2[1]),
					typeName = typeName
				};
				
				categoryList:AddItem(
					vgui.Create("cwSalesmanItem", categoryList)
				);
			end;
		end;
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self:RebuildPanel(self.sellsPanel, "Sells",
		Clockwork.salesman:GetSells()
	);
	
	self:RebuildPanel(self.buysPanel, "Buys",
		Clockwork.salesman:GetBuys()
	);
	
	self:RebuildPanel(self.itemsPanel, "Items",
		Clockwork.salesman:GetItems()
	);
end;

-- Called each frame.
function PANEL:Think()
	self:SetSize(ScrW() * 0.5, ScrH() * 0.75);
--	self:SetTextColor( Color( 255, 255, 255 ) );
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
	
	Clockwork.salesman.text.doneBusiness = {
		text = self.doneBusinessText:GetValue(),
		bHideName = (self.doneBusinessHideName:GetChecked() == true),
		sound = self.doneBusinessSound:GetValue()
	};
	Clockwork.salesman.text.cannotAfford = {
		text = self.cannotAffordText:GetValue(),
		bHideName = (self.cannotAffordHideName:GetChecked() == true),
		sound = self.cannotAffordSound:GetValue()
	};
	Clockwork.salesman.text.needMore = {
		text = self.needMoreText:GetValue(),
		bHideName = (self.needMoreHideName:GetChecked() == true),
		sound = self.needMoreSound:GetValue()
	};
	Clockwork.salesman.text.noStock = {
		text = self.noStockText:GetValue(),
		bHideName = (self.noStockHideName:GetChecked() == true),
		sound = self.noStockSound:GetValue()
	};
	Clockwork.salesman.text.noSale = {
		text = self.noSaleText:GetValue(),
		bHideName = (self.noSaleHideName:GetChecked() == true),
		sound = self.noSaleSound:GetValue()
	};
	Clockwork.salesman.text.start = {
		text = self.startText:GetValue(),
		bHideName = (self.startHideName:GetChecked() == true),
		sound = self.startSound:GetValue()
	};
	Clockwork.salesman.showChatBubble = (self.showChatBubble:GetChecked() == true);
	Clockwork.salesman.buyInShipments = (self.buyInShipments:GetChecked() == true);
	Clockwork.salesman.physDesc = self.physDesc:GetValue();
	Clockwork.salesman.buyRate = self.buyRate:GetValue();
	Clockwork.salesman.stock = self.stock:GetValue();
	Clockwork.salesman.model = self.model:GetValue();
	Clockwork.salesman.cash = self.cash:GetValue();
	
	local priceScale = self.priceScale:GetValue();
	Clockwork.salesman.priceScale = tonumber(priceScale) or 1;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self);
--	DFrame.SetTextColor(Color(255, 255, 255))
	
	if (self.propertySheet) then
		self.propertySheet:StretchToParent(4, 28, 4, 4);
	end;
end;

function PANEL:Paint(w, h)
	return draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) );
end;

vgui.Register("cwSalesman", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData or CURRENT_ITEM_DATA;
	self:SetSize(40, 40);
	self.itemTable = itemData.itemTable;
	self.typeName = itemData.typeName;
	self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	self.spawnIcon:SetColor(self.itemTable("color"));
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (self.typeName == "Items") then
			if (self.itemTable("cost") == 0 and Clockwork.config:Get("cash_enabled"):Get()) then
				local cashName = Clockwork.option:GetKey("name_cash");

				Clockwork.kernel:AddMenuFromData(nil, {
					["Buys"] = function()
						Derma_StringRequest(cashName, "Сколько будет брать продавец за этот предмет?", "", function(text)
							Clockwork.salesman.buys[self.itemTable("uniqueID")] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Sells"] = function()
						Derma_StringRequest(cashName, "Сколько будет стоить предмет?", "", function(text)
							Clockwork.salesman.sells[self.itemTable("uniqueID")] = tonumber(text) or true;
							Clockwork.salesman:GetPanel():Rebuild();
						end);
					end,
					["Both"] = function()
						Derma_StringRequest(cashName, "Сколько будет брать продавец за этот предмет?", "", function(sellPrice)
							Derma_StringRequest(cashName, "Сколько будет стоить предмет?", "", function(buyPrice)
								Clockwork.salesman.sells[self.itemTable("uniqueID")] = tonumber(sellPrice) or true;
								Clockwork.salesman.buys[self.itemTable("uniqueID")] = tonumber(buyPrice) or true;
								Clockwork.salesman:GetPanel():Rebuild();
							end);
						end);
					end
				});
			else
				Clockwork.kernel:AddMenuFromData(nil, {
					["Buys"] = function()
						Clockwork.salesman.buys[self.itemTable("uniqueID")] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Sells"] = function()
						Clockwork.salesman.sells[self.itemTable("uniqueID")] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end,
					["Both"] = function()
						Clockwork.salesman.sells[self.itemTable("uniqueID")] = true;
						Clockwork.salesman.buys[self.itemTable("uniqueID")] = true;
						Clockwork.salesman:GetPanel():Rebuild();
					end
				});
			end;
		elseif (self.typeName == "Sells") then
			Clockwork.salesman.sells[self.itemTable("uniqueID")] = nil;
			Clockwork.salesman:GetPanel():Rebuild();
		elseif (self.typeName == "Buys") then
			Clockwork.salesman.buys[self.itemTable("uniqueID")] = nil;
			Clockwork.salesman:GetPanel():Rebuild();
		end;
	end;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	self.spawnIcon:SetModel(model, skin);
	self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetSize(40, 40);
end;

-- Called each frame.
function PANEL:Think()
	local function DisplayCallback(displayInfo)
		local priceScale = 1;
		local amount = 0;
		
		if (self.typeName == "Sells") then
			if (Clockwork.salesman:BuyInShipments()) then
				amount = self.itemTable("batch");
			else
				amount = 1;
			end;
			
			priceScale = Clockwork.salesman:GetPriceScale();
		elseif (self.typeName == "Buys") then
			priceScale = Clockwork.salesman:GetBuyRate() / 100;
		end;
		
		if (Clockwork.config:Get("cash_enabled"):Get()) then
			if (self.itemTable("cost") != 0) then
				displayInfo.weight = Clockwork.kernel:FormatCash(
					(self.itemTable("cost") * priceScale) * math.max(amount, 1)
				);
			else
				displayInfo.weight = L("Priceless");
			end;
			
			local overrideCash = Clockwork.salesman.sells[self.itemTable("uniqueID")];
			
			if (self.typeName == "Buys") then
				overrideCash = Clockwork.salesman.buys[self.itemTable("uniqueID")];
			end;
			
			if (type(overrideCash) == "number") then
				displayInfo.weight = Clockwork.kernel:FormatCash(overrideCash * math.max(amount, 1));
			end;
		end;
		
		if (self.typeName == "Sells") then
			if (amount > 1) then
				displayInfo.name = L("AmountOfThing", amount, L(self.itemTable("name")));
			else
				displayInfo.name = L(self.itemTable("name"));
			end;
		end;
		
		if (self.typeName == "Sells" and Clockwork.salesman.stock != -1) then
			displayInfo.itemTitle = "["..Clockwork.salesman.stock.."] ["..displayInfo.name..", "..displayInfo.weight.."]";
		end;
	end;
	
	self.spawnIcon:SetMarkupToolTip(
		Clockwork.item:GetMarkupToolTip(self.itemTable, true, DisplayCallback)
	);
	self.spawnIcon:SetColor(self.itemTable("color"));
end;

function PANEL:Paint(w, h)
	return draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) );
end;

vgui.Register("cwSalesmanItem", PANEL, "DPanel");
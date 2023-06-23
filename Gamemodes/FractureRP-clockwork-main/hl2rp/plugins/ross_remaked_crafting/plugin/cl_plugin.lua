local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)

	if entity:GetClass() == "ross_fur_base" && entity:GetNWBool("IsFurniture") then
		options["Собрать чертеж"] = "furn_recipe_collect";
		options["Создать мебель"] = "furn_recipe_create"
	end;

	if entity:GetClass() == "ross_furnace" then
		if !entity:GetFired() then
			options["Открыть"] = "furn_open_pls"
			options["Поджечь"] = "furn_fire_start";
		end;
	end;

	if entity:GetClass() == "ross_gas_furnace" then
		if entity:GetGasCan() then
			options["Забрать газовый баллон"] = "take_gas_ballone"
		end;
		options["Готовить"] = "cook_food_gas"
	end;
	
	if entity:GetClass() == "ross_ration_pack" then
		if !entity:GetIsBroken() then
			options["Порвать рацион"] = "crack_ration_packet";
		end;
	end;

	if entity:GetClass() == "ross_ration_crate" then
		options["Открыть"] = "open_crate_rations"
	end;
end;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "clean") then
			return {text = "Мою одежду..", percentage = percentage, flash = percentage < 10};
		end;
		if (action == "WrappingOutBP") then
			return {text = "Разворачивается чертеж...", percentage = percentage, flash = percentage < 10};
		end;
		if (action == "CreateItem") then
			return {text = "Создается предмет...", percentage = percentage, flash = percentage < 10};
		end;
		if (action == "cleanWeapon") then
			return {text = "Производится чистка оружия.", percentage = percentage, flash = percentage < 10};
		end;
		if (action == "cooking") then
			return {text = "Происходит готовка...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

local function AddExactItems(konforks, inv, inside, entity, type, value, panel, panellist, frame, konfork)
	value = tostring(value)
	for k, v in pairs(inside[type]) do
		local itemPanel = vgui.Create( "DPanel" )
		itemPanel:SetSize(45, 45)
		itemPanel.isChoosen = false;
		itemPanel.Paint = function(self, w, h)
			if !self.isChoosen then
				draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,150) )
			else
				draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(100, 255, 100, 255));
			end;
		end;

		local itemSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", itemPanel ));
		itemSpawnIcon:Dock(FILL);
		itemSpawnIcon.SetMarkupToolTip(itemSpawnIcon, [[Название: <color=255, 180, 80>]]..v.name..[[</color>]])
		itemSpawnIcon:SetModel( v.model, v.skin );
		itemSpawnIcon.DoClick = function(self)

			inv[k] = v;
			cable.send('ReturnItemToInventory', entity, {type, v.uniqueID, v.itemID, value});
			inside[type][k] = nil;
			frame:Close(); frame:Remove();
			OpenGasStation(konforks, inv, inside, entity, {value})

		end;

		itemSpawnIcon.DoRightClick = function(self)
			self:GetParent().isChoosen = !self:GetParent().isChoosen;

			if self:GetParent().isChoosen then
				frame.ChoosenToUnite['hunger'] = frame.ChoosenToUnite['hunger'] + inside[type][k]['needsList'].dhunger
				frame.ChoosenToUnite['thirst'] = frame.ChoosenToUnite['thirst'] + inside[type][k]['needsList'].dthirst
				frame.ChoosenToUnite['sleep'] = frame.ChoosenToUnite['sleep'] + inside[type][k]['needsList'].dsleep
				-- frame.ChoosenIDs[ inside[type][k].itemID ] = 1
				table.insert(frame.ChoosenIDs, inside[type][k].itemID)
			else
				frame.ChoosenToUnite['hunger'] = frame.ChoosenToUnite['hunger'] - inside[type][k]['needsList'].dhunger
				frame.ChoosenToUnite['thirst'] = frame.ChoosenToUnite['thirst'] - inside[type][k]['needsList'].dthirst
				frame.ChoosenToUnite['sleep'] = frame.ChoosenToUnite['sleep'] - inside[type][k]['needsList'].dsleep
				table.RemoveByValue(frame.ChoosenIDs, inside[type][k].itemID)
			end;
		end;

		panellist:AddItem( itemPanel )
	end;

	local removeS = vgui.Create( "DButton", panel )
	removeS:SetText("-")
	removeS:SetPos( 250, 5 )
	removeS:SetSize(35, 20)
	removeS:SetTextColor(Color(232, 187, 8, 255))
	removeS.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
	end;

	removeS.DoClick = function(self)
		if !konfork && next(inside[type]) == nil then
			cable.send('ManipulateConnectedStuff', entity, type);
			konfork = true;
			frame:Close(); frame:Remove();
		end;
	end;

	local startPrep = vgui.Create( "DButton", panel )
	startPrep:SetText("!!!")
	startPrep:SetPos( 210, 5 )
	startPrep:SetSize(35, 20)
	startPrep:SetTextColor(Color(232, 187, 8, 255))
	startPrep.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
	end;

	startPrep.DoClick = function(self)
		if !konfork && konforks[5] > 0 && next(inside[type]) != nil then
			cable.send('StartCooking', entity, {type, value});
			frame:Close(); frame:Remove();
		end;
	end;
end;

function OpenGasStation(konforks, inv, inside, entity, exData)
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local sW = (scrW/2) - 250;
	local sH = (scrH/2) - 350;
	local timePreparation = 0;
	if exData != nil && exData[2] != nil then
		timePreparation = exData[2]
	end;

	local function GetActiveType(text)
		local type = false;
		text = tostring(text);

		if text == "Варка" then
			type = "pot"
		elseif text == "Жарка" then
			type = "pan"
		elseif text == "Кипячение" then
			type = "teapot"
		elseif text == "Обваривание" then
			type = "littlepot"
		end;

		return type;
	end;

	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(710, 610)
    frame:SetTitle("")
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame.ChoosenToUnite = {
		hunger = 0,
		thirst = 0,
		sleep = 0
	};
	frame.ChoosenIDs = {

	};
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
		if konforks[6] then
			draw.DrawText( "Время готовки: "..timePreparation, "DermaDefault", 450, 565, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( "Количество топлива: "..konforks[5], "DermaDefault", 450, 580, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
		elseif !konforks[6] then
			draw.DrawText( "Газовый баллон не установлен.", "DermaDefault", 450, 580, Color(200, 100, 100, 255), TEXT_ALIGN_LEFT )
		end;
        if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;

	end;

    local AvaibleSettings = vgui.Create( "DComboBox", frame )
	AvaibleSettings:SetPos( 10, 550 )
	AvaibleSettings:SetSize( 200, 20 )
	AvaibleSettings:SetTextColor(Color(255, 255, 255))
	if !konforks[1] then
		AvaibleSettings:AddChoice( "Варка" )
	end;
	if !konforks[2] then
		AvaibleSettings:AddChoice( "Жарка" )
	end;
	if !konforks[3] then
		AvaibleSettings:AddChoice( "Кипячение" )
	end;
	if !konforks[4] then
		AvaibleSettings:AddChoice( "Обваривание" )
	end;
	AvaibleSettings:AddChoice( "Объединить" )
	AvaibleSettings.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
	end;
	if type(exData) == "table" && next(exData) != nil then
		AvaibleSettings:SetValue(exData[1])
	end;

	local uniteFood = vgui.Create( "DButton", frame )
	uniteFood:SetText("[Объединить]")
	uniteFood:SetPos( 250, 550 )
	uniteFood:SetSize(100, 30)
	-- uniteFood:SetTextColor(Color(232, 187, 8, 255))
	uniteFood.Paint = function(self, x, y)
		if self:IsHovered() && table.Count(frame.ChoosenToUnite) > 0 then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 0));
		end;
		
		if table.Count(frame.ChoosenToUnite) == 0 || AvaibleSettings:GetValue() != "Объединить" then
			self:SetAlpha(100);
			self:SetTextColor(Color(100, 100, 100, 255))
		else
			self:SetAlpha(255);
			self:SetTextColor(Color(232, 187, 8, 255))
		end;

	end;
	
	uniteFood.DoClick = function()
		if table.Count(frame.ChoosenToUnite) > 0 && AvaibleSettings:GetValue() == "Объединить" && next(frame.ChoosenIDs) != nil then
			cable.send('UniteFoodUP', {entity, frame.ChoosenToUnite, frame.ChoosenIDs});
			frame:Close(); frame:Remove();
		end;
	end;

	local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[X]")
	closebtn:SetPos( 10, 570 )
	closebtn:SetSize(50, 30)
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
    
    local inventoryPanel = vgui.Create( "DPanel", frame )
	inventoryPanel:SetPos(10, 15)
	inventoryPanel:SetSize(390, 500)
	inventoryPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
		draw.RoundedBox( 0, 0, 0, w, 35, Color(0,0,0,150) )
		draw.DrawText( "Инвентарь", "DermaDefault", 180, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
	end;
	local itemList = vgui.Create( "DGrid", inventoryPanel )
	itemList:SetPos(10, 40)
	itemList:SetCols( 10 )
	itemList:SetColWide( 55 )
	itemList:SetRowHeight(55)

	for k, v in pairs(inv) do
		local itemPanel = vgui.Create( "DPanel" )
		itemPanel:SetSize(45, 45)
		itemPanel.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,150) )
		end;

		local ItemSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", itemPanel ));
		ItemSpawnIcon:Dock(FILL);
		ItemSpawnIcon.SetMarkupToolTip(ItemSpawnIcon, [[Название: <color=255, 180, 80>]]..v.name..[[</color>]])
		ItemSpawnIcon:SetModel( v.model, v.skin );
		ItemSpawnIcon.DoClick = function(self)
			local type = "";
			local buffer = {};
			local aType = GetActiveType(AvaibleSettings:GetValue());

			if aType then
				type = aType;
			elseif !aType then
				return;
			end;

			for k, v in pairs(v.cookingBlueprint) do
				table.insert(buffer, k);
			end;

			if !table.HasValue(buffer, AvaibleSettings:GetValue()) then
				return;
			end;

			if konforks[6] && table.Count(inside[type]) < 3 && !v.IsCrafted then
				if !inside[type][v.itemID] then
					inside[type][v.itemID] = {
						uniqueID = v.uniqueID,
						name = v.name,
						skin = v.skin,
						model = v.model,
						itemID = v.itemID,
						cookingBlueprint = v.cookingBlueprint,
						needsList = v.needsList,
						IsCrafted = v.IsCrafted
					}
				elseif inside[type][v.itemID] then
					inside[type][v.itemID] = nil;
				end;
				for id, table in pairs(inv) do
					if v.itemID == table.itemID then
						inv[id] = nil;
					end;
				end;
				timePreparation = timePreparation + v.cookingBlueprint[AvaibleSettings:GetValue()]["time"]
				cable.send('AddItemToRoaster', inside[type], {entity, type});
				frame:Close(); frame:Remove();
				OpenGasStation(konforks, inv, inside, entity, {AvaibleSettings:GetValue(), timePreparation})
			end;

		end;

		itemList:AddItem( itemPanel )
	end;

	local panPanelInv = vgui.Create( "DPanel", frame )
	panPanelInv:SetPos(405, 15)
	panPanelInv:SetSize(290, 100)
	panPanelInv.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
		draw.RoundedBox( 0, 0, 0, w, 35, Color(0,0,0,150) )
		draw.DrawText( "Сковорода", "DermaDefault", 130, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
	end;
	local PanInsideListItems = vgui.Create( "DGrid", panPanelInv )
	PanInsideListItems:SetPos(10, 40)
	PanInsideListItems:SetCols( 3 )
	PanInsideListItems:SetColWide( 55 )
	PanInsideListItems:SetRowHeight(55)

	AddExactItems(konforks, inv, inside, entity, "pan", "Жарка", panPanelInv, PanInsideListItems, frame, konforks[2])

	if konforks[2] then
		panPanelInv:SetEnabled(false);
	end;

	local BpotPanel = vgui.Create( "DPanel", frame )
	BpotPanel:SetPos(405, 120)
	BpotPanel:SetSize(290, 100)
	BpotPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
		draw.RoundedBox( 0, 0, 0, w, 35, Color(0,0,0,150) )
		draw.DrawText( "Кострюля", "DermaDefault", 130, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
	end;
	local BpotPanelListItems = vgui.Create( "DGrid", BpotPanel )
	BpotPanelListItems:SetPos(10, 40)
	BpotPanelListItems:SetCols( 4 )
	BpotPanelListItems:SetColWide( 55 )
	BpotPanelListItems:SetRowHeight(55)

	AddExactItems(konforks, inv, inside, entity, "pot", "Варка", BpotPanel, BpotPanelListItems, frame, konforks[1])

	if konforks[1] then
		BpotPanel:SetEnabled(false);
	end;

	local TeaPot = vgui.Create( "DPanel", frame )
	TeaPot:SetPos(405, 225)
	TeaPot:SetSize(290, 100)
	TeaPot.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
		draw.RoundedBox( 0, 0, 0, w, 35, Color(0,0,0,150) )
		draw.DrawText( "Чайник", "DermaDefault", 130, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
	end;
	local TeaPotItems = vgui.Create( "DGrid", TeaPot )
	TeaPotItems:SetPos(10, 40)
	TeaPotItems:SetCols( 4 )
	TeaPotItems:SetColWide( 55 )
	TeaPotItems:SetRowHeight(55)

	AddExactItems(konforks, inv, inside, entity, "teapot", "Кипячение", TeaPot, TeaPotItems, frame, konforks[3])

	if konforks[3] then
		TeaPot:SetEnabled(false);
	end;

	local LittlePot = vgui.Create( "DPanel", frame )
	LittlePot:SetPos(405, 330)
	LittlePot:SetSize(290, 100)
	LittlePot.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,255) )
		draw.RoundedBox( 0, 0, 0, w, 35, Color(0,0,0,150) )
		draw.DrawText( "Маленькая кострюля", "DermaDefault", 90, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
	end;
	local LittlePotItems = vgui.Create( "DGrid", TeaPot )
	LittlePotItems:SetPos(10, 40)
	LittlePotItems:SetCols( 4 )
	LittlePotItems:SetColWide( 55 )
	LittlePotItems:SetRowHeight(55)

	AddExactItems(konforks, inv, inside, entity, "littlepot", "Обваривание", LittlePot, LittlePotItems, frame, konforks[4])

	if konforks[4] then
		LittlePot:SetEnabled(false);
	end;

end;

cable.receive('OpenGasStation', function(inv, konforks, inside, ent, exData)
	
	OpenGasStation(konforks, inv, inside, ent, exData)
end);
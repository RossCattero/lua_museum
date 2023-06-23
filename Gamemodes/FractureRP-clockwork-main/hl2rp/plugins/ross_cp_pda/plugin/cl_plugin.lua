
local PLUGIN = PLUGIN;

-- PLUGIN.CPchat = {};

cable.receive('OpenCivilProtectionPDA', function(table, settings, ID, logs, chat)
    OpenCPPDA_Password(table, settings, ID, logs, chat)
end);

cable.receive('OpenRegistrationObject', function(table, chat)
    RegObj(table, chat)
end);

cable.receive('OpenPDACWU', function(citizens, code, hasitem, cardEdited)
    DrawMePls(citizens, code, hasitem, cardEdited)
end);

cable.receive('OpenCitizenInfo', function(cardsInPocket)
    CitizenInfoTerminal(cardsInPocket)
end);

function CitizenInfoTerminal(cardsInPocket)
    local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local frame = vgui.Create("DFrame");
	frame:SetPos((scrW/2) - 390, (scrH/2) - 300)
	frame:SetSize(800, 250)
	frame:SetTitle("")
	frame.keyselected = ""
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(36, 146, 255, 255));
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local OutLinedPanel = vgui.Create( "DPanel", frame )
	OutLinedPanel:SetPos( 5, 5 )
	OutLinedPanel:SetSize( 790, 240 )
	OutLinedPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
	end;
	local closebtn = vgui.Create( "DButton", OutLinedPanel )
	closebtn:SetText("[X]")
	closebtn:SetPos( 10, 210 )
	closebtn:SetSize(100, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
		end;
	end;
	
    closebtn.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
        frame:Close(); frame:Remove();
	end;
	local CardsList = vgui.Create( "DComboBox", OutLinedPanel )
	CardsList:SetPos( 10, 10 )
	CardsList:SetSize( 120, 20 )
	CardsList:SetValue( "Выбрать карточку" )
	for k, v in pairs(cardsInPocket) do
		CardsList:AddChoice( k )
	end;
	CardsList.OnSelect = function( self, index, value )
		frame.keyselected = value
	end;

	local InformationPanel = vgui.Create( "DPanel", frame )
	InformationPanel:SetPos( 150, 10 )
	InformationPanel:SetSize( 640, 230 )
	InformationPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
		if frame.keyselected != "" then
		draw.DrawText( "Имя: "..cardsInPocket[frame.keyselected]["OwnerName"], "Trebuchet18", 5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "CID: "..cardsInPocket[frame.keyselected]["CID"], "Trebuchet18", 5, 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Рационов: "..cardsInPocket[frame.keyselected]["Rations"], "Trebuchet18", 5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "До следующего рациона: "..cardsInPocket[frame.keyselected]["CooldownRations"], "Trebuchet18", 5, 50, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОЛ: "..cardsInPocket[frame.keyselected]["OL"], "Trebuchet18", 5, 65, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОН: "..cardsInPocket[frame.keyselected]["ON"], "Trebuchet18", 5, 80, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end;
	end;

end;

function RegObj(table, chat)
    local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();

	local codes = {
		["block"] = {
			func = function(text, frame, table)
				local pattern = "([%w_]+)%s*([%d_]+)%s*([%a_]+)"
				local k, v, reason = string.match( text:GetValue(), pattern )
				local v = tonumber(v);
				
				if table[v] then
					table[v][1] = true;
					table[v][2] = reason;
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v, table[v]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;				
			end;
		},
		["changepass"] = {
			func = function(text, frame, table)
				local pattern = "([%w_]+)%s*([%d_]+)%s*([%a_]+)"
				local k, v, newpassword = string.match( text:GetValue(), pattern )
				local v = tonumber(v);

				if table[v] then
					table[v][3] = newpassword;
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v, table[v]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;
			end;
		},
		["unblock"] = {
			func = function(text, frame, table)
				local pattern = "([%w_]+)%s*([%d_]+)"
				local k, v = string.match( text:GetValue(), pattern )
				local v = tonumber(v);

				if table[v] then
					table[v][1] = false;
					table[v][2] = "none";
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v, table[v]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;
			end;
		},
		["mathematic"] = {
			func = function(self, frame)
				frame.Game = true;
				local result;
				local znak;
				local ran = math.random(1, 3)
		
				local firstrandom = math.random(1, 10)
				local secondrandom = math.random(1, 25)
				if ran == 1 then
					result = firstrandom + secondrandom;
					znak = "+";
				elseif ran == 2 then
					result = firstrandom * secondrandom;
					znak = "*";
				elseif ran == 3 then
					result = firstrandom / secondrandom;
					znak = "/"
				end;

				frame.Result = result;
				frame.modifcator = ran;

				self:SetText(firstrandom.." "..znak.." "..secondrandom.." = ".."<?>(Напиши stop, чтобы остановить игру, либо сотри строку и напиши ответ)")
				
			end;
		},
		["blockchat"] = {
			func = function(text, frame, table)
				local pattern = "([%w_]+)%s*([%d_]+)"
				local k, v = string.match( text:GetValue(), pattern )
				local v = tonumber(v);

				if table[v] then
					table[v][4] = true;
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v, table[v]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;
			end;
		},
		["unblockchat"] = {
			func = function(text, frame, table)
				local pattern = "([%w_]+)%s*([%d_]+)"
				local k, v = string.match( text:GetValue(), pattern )
				local v = tonumber(v);

				if table[v] then
					table[v][4] = false;
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v, table[v]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;
			end;
		}
 	}

	local frame = vgui.Create("DFrame");
	frame:SetPos((scrW/2) - 390, (scrH/2) - 300)
	frame:SetSize(800, 500)
	frame:SetTitle("")
	frame.Game = false;
	frame.Result = 0;
	frame.Combo = 0;
	frame.modifcator = 1;
	frame.Info = {
		id = "",
		password = ""
	}
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(36, 146, 255, 255));
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local OutLinedPanel = vgui.Create( "DPanel", frame )
	OutLinedPanel:SetPos( 5, 5 )
	OutLinedPanel:SetSize( 790, 490 )
	OutLinedPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
	end;

	local ItemInside = vgui.Create( "DPanel", OutLinedPanel )
	ItemInside:SetPos( 5, 5 )
	ItemInside:SetSize( 780, 100 )
	ItemInside.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
		draw.DrawText( "Выбран идентификатор: "..frame.Info["id"], "Trebuchet18", 5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Пароль: "..frame.Info["password"], "Trebuchet18", 5, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		if frame.Game then
			draw.DrawText( "COMBO: "..frame.Combo, "Trebuchet18", 700, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end;
	end;

	local closebtn = vgui.Create( "DButton", ItemInside )
	closebtn:SetText("[X]")
	closebtn:SetPos( 720, 10 )
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

	local UnitsOnline = vgui.Create( "DPanel", OutLinedPanel )
	UnitsOnline:SetPos( 5, 110 )
	UnitsOnline:SetSize( 390, 320 )
	UnitsOnline.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
		if vgui.GetHoveredPanel() != self then
			frame.Info["id"] = ""
			frame.Info["password"] = ""
		end;
	end;

	local ChatHere = vgui.Create( "DPanel", OutLinedPanel )
	ChatHere:SetPos( 396, 110 )
	ChatHere:SetSize( 388, 320 )
	ChatHere.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
	end;

	local chatPanelX = vgui.Create( "DScrollPanel", ChatHere )
	chatPanelX:Dock(FILL)

	for k, v in pairs(chat) do
		local chatInfo = chatPanelX:Add( "DButton" )
		chatInfo:Dock( TOP )
		chatInfo:SetText("")
		chatInfo:DockMargin( 5, 5, 5, 5 )
		chatInfo.Paint = function(self, w, h)
			draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
			draw.DrawText( v["text"], "DermaDefault", 100, 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.DrawText( v["name"].."["..v["id"].."]", "DermaDefault", 3, 4, Color(100, 255, 100, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end;
		chatInfo.DoClick = function(self)
		
		local menu = DermaMenu()
			menu:AddOption( "Удалить", function()
				chat[k] = nil
				cable.send('RemoveChatMessage', k);
				frame:Close(); frame:Remove();
				RegObj(table, chat)
			end):SetImage("icon16/textfield_key.png")
			menu:AddOption( "Заблокировать", function()
				if table[v["id"]] then
					table[v["id"]][1] = true;
					table[v["id"]][2] = "BLOCKED_BY_ADMINISTRATOR";
					surface.PlaySound("ui/buttonclick.wav");
					cable.send('ChangePDAGlobalData', v["id"], table[v["id"]]);
					frame:Close(); frame:Remove();
					RegObj(table, chat)
				end;
			end):SetImage("icon16/textfield_rename.png")
			menu:AddOption( "Скопировать идентификатор", function()
				SetClipboardText( v["id"] )
			end):SetImage("icon16/textfield_key.png")
			menu:Open()
		end;

	end;

	local CodeInsert = vgui.Create( "DTextEntry", OutLinedPanel ) 
    CodeInsert:SetPos( 5, 432 )
    CodeInsert:SetSize( 780, 25 )
	CodeInsert:SetText( "" )
	CodeInsert:SetMultiline(false);
	CodeInsert.Paint = function(self, w, h)
		self:DrawTextEntryText( color_white, color_white, color_white )
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
	end;
	CodeInsert.OnEnter = function(self)
		local pattern = "([%w_]+)%s*"
		if codes[string.match( self:GetValue(), pattern )] then
			codes[string.match( self:GetValue(), pattern )].func(self, frame, table)
		end;

		if frame.Game then
			if frame.Result == tonumber(self:GetValue()) then
				codes["mathematic"].func(self, frame)
				frame.Combo = frame.Combo + frame.modifcator;
			end;
			if self:GetValue() == "stop" then
				frame.Game = false;
				frame.Combo = 0;
				frame.Result = 0;
				frame.modifcator = 1;
				frame:Close(); frame:Remove();
				RegObj(table, chat)
			end;
		end;

	end;

	local PdaList = vgui.Create( "DScrollPanel", UnitsOnline )
	PdaList:Dock( FILL )

	for k, v in pairs(table) do
		local PdaOnline = PdaList:Add( "DButton" )
		PdaOnline:SetText( "" )
		PdaOnline:Dock( TOP )
		PdaOnline:DockMargin( 5, 5, 5, 0 )
		PdaOnline.Paint = function(self, w, h)
			if v[1] == false then
				draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(36, 146, 255), Color(255, 255, 255) )
				draw.DrawText( k, "Trebuchet18", 130, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			elseif v[1] == true then
				draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(150, 100, 100), Color(255, 255, 255) )
				draw.DrawText( k.." [ЗАБЛОКИРОВАНО ("..v[2]..")]", "Trebuchet18", 130, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end;
			
			if vgui.GetHoveredPanel() == self then
				frame.Info["id"] = k;
				frame.Info["password"] = v[3]
			end;
		end;
		PdaOnline.DoClick = function(self)
			CodeInsert:SetValue(k)
		end;
	end

	local ButtonPanel = vgui.Create( "DPanel", OutLinedPanel )
	ButtonPanel:SetPos( 5, 460 )
	ButtonPanel:SetSize( 780, 25 )
	ButtonPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
	end;
	local EditPassword = vgui.Create( "DButton", ButtonPanel )
	EditPassword:SetSize( 150, 20 )
	EditPassword:SetPos(5, 3)
	EditPassword:SetText("")
	EditPassword:SetTextColor(Color(0, 0, 0, 255))
	EditPassword.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 15, h, Color(0, 0, 0, 255));
		draw.DrawText( "1", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Изменить пароль", "Trebuchet18", 15, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditPassword.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		CodeInsert:SetValue("changepass id Новый пароль")
	end;
	EditPassword.Think = function(self)
		if input.IsButtonDown( KEY_1 ) && (!self.cooldown or CurTime() >= self.cooldown) && CodeInsert:GetValue() == "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local BlockPDA = vgui.Create( "DButton", ButtonPanel )
	BlockPDA:SetSize( 135, 20 )
	BlockPDA:SetPos(160, 3)
	BlockPDA:SetText("")
	BlockPDA:SetTextColor(Color(0, 0, 0, 255))
	BlockPDA.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 15, h, Color(0, 0, 0, 255));
		draw.DrawText( "2", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Заблокировать", "Trebuchet18", 15, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	BlockPDA.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		CodeInsert:SetValue("block id Причина на английском")
	end;
	BlockPDA.Think = function(self)
		if input.IsButtonDown( KEY_2 ) && (!self.cooldown or CurTime() >= self.cooldown) && CodeInsert:GetValue() == "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local UnBlockPDA = vgui.Create( "DButton", ButtonPanel )
	UnBlockPDA:SetSize( 143, 20 )
	UnBlockPDA:SetPos(300, 3)
	UnBlockPDA:SetText("")
	UnBlockPDA:SetTextColor(Color(0, 0, 0, 255))
	UnBlockPDA.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 15, h, Color(0, 0, 0, 255));
		draw.DrawText( "3", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Разблокировать", "Trebuchet18", 15, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	UnBlockPDA.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		CodeInsert:SetValue("unblock id")
	end;
	UnBlockPDA.Think = function(self)
		if input.IsButtonDown( KEY_3 ) && (!self.cooldown or CurTime() >= self.cooldown) && CodeInsert:GetValue() == "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local Clear = vgui.Create( "DButton", ButtonPanel )
	Clear:SetSize( 143, 20 )
	Clear:SetPos(445, 3)
	Clear:SetText("")
	Clear:SetTextColor(Color(0, 0, 0, 255))
	Clear.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 15, h, Color(0, 0, 0, 255));
		draw.DrawText( "4", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Очистить", "Trebuchet18", 15, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	Clear.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		CodeInsert:SetText("")
	end;
	Clear.Think = function(self)
		if input.IsButtonDown( KEY_PAD_0 ) && (!self.cooldown or CurTime() >= self.cooldown) && CodeInsert:GetValue() != "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;

	local BlockChat = vgui.Create( "DButton", ButtonPanel )
	BlockChat:SetSize( 140, 20 )
	BlockChat:SetPos(550, 3)
	BlockChat:SetText("")
	BlockChat:SetTextColor(Color(0, 0, 0, 255))
	BlockChat.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 15, h, Color(0, 0, 0, 255));
		draw.DrawText( "5", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Блокировать чат", "Trebuchet18", 15, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	BlockChat.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		CodeInsert:SetValue("blockchat id")
	end;
	BlockChat.Think = function(self)
		if input.IsButtonDown( KEY_5 ) && (!self.cooldown or CurTime() >= self.cooldown) && CodeInsert:GetValue() == "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	
end;

function OpenCPPDA_Password(table, Settings, ID, actualLogs, chat)
    local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();
	local password = Settings["password"]

	local frame = vgui.Create("DFrame");
	frame:SetPos((scrW/2) - 390, (scrH/2) - 300)
	frame:SetSize(800, 500)
	frame:SetTitle("")
	frame.everything = table;
	frame.settings = Settings;
	frame.stop = false;
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;
	
	local OutLinedPanel = vgui.Create( "DPanel", frame )
	OutLinedPanel:SetPos( 5, 5 )
	OutLinedPanel.ColorFrameBackground = Color(0, 0, 0, 255);
	OutLinedPanel.getPageOfPDA = "password";
	OutLinedPanel:SetSize( 790, 455 )
	OutLinedPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 2, 0, 0, w, h, OutLinedPanel.ColorFrameBackground, Color(100, 100, 100) )
		
		if self.getPageOfPDA == '' then
            draw.DrawText( "Добро пожаловать в Civil Protection Control System!\nДля начала работы выберите любой пункт.", "DermaDefault", 10, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end;
	end;
	
	local InfoPanelDown = vgui.Create( "DPanel", frame )
	InfoPanelDown:SetPos( 0, 465 )
	InfoPanelDown:SetSize( 800, 35 )
	InfoPanelDown.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255));
		draw.DrawText( "| "..os.date( "%H:%M:%S" , os.time() ).." |", "DermaDefault", 700, 10, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;

	local DecorativeButton = vgui.Create( "DButton", InfoPanelDown )
	DecorativeButton:SetText("CPC.sys")
	DecorativeButton:SetPos( 10, 5 )
	DecorativeButton:SetSize(100, 25)
	DecorativeButton:SetTextColor(Color(0, 0, 0, 255))
	DecorativeButton.Paint = function(self, x, y)
		draw.RoundedBoxOutlined( 0, 0, 0, x, y, Color(100, 100, 100), Color(0, 0, 0) )
	end;
	
	local PasswordPanel = vgui.Create( "DPanel", OutLinedPanel )
	PasswordPanel:SetPos( 250, 150 )
	PasswordPanel:SetSize( 280, 150 )
	PasswordPanel.Paint = function(self, w, h)
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 0));
		if !Settings["blocked"] then
			draw.SimpleTextOutlined( "ВВЕДИТЕ ПАРОЛЬ ", "HudSelectionText", 90, 30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		elseif Settings["blocked"] then
			draw.SimpleTextOutlined( "ДОСТУП ЗАПРЕЩЕН!", "HudSelectionText", 90, 30, Color( 255, 50, 50, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		end;
	end;
	
	if Settings["blocked"] then
		PasswordPanel:SetEnabled(false)
	end;

	local Password = vgui.Create( "DTextEntry", PasswordPanel ) 
    Password:SetPos( 15, 50 )
    Password:SetSize( 250, 25 )
    Password.TextColor = Color(255, 255, 255, 255);
	Password:SetText( "" )
	Password:SetMultiline(false);
	Password.Paint = function(self, w, h)
		self:DrawTextEntryText( Password.TextColor, Color(255, 255, 255, 255), Color(255, 255, 255, 255) )
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
	end;
	
    Password.OnTextChanged = function(self)
        
        if Password.TextColor == Color(255, 100, 100, 255) then
            Password.TextColor = Color(255, 255, 255, 255)
        end;

	end;
	Password.OnEnter = function()
		if Password:GetValue() != password then
            Password.TextColor = Color(255, 100, 100, 255)
        elseif Password:GetValue() == password then
            Password.TextColor = Color(255, 255, 255, 255)
            Password:SetEnabled(false);
            PasswordPanel:AlphaTo(0, 1, 0, function()
                PasswordPanel:Remove();
                OpenCPPDA(frame, OutLinedPanel, frame.everything, frame.settings, ID, actualLogs, chat)
            end);
            
        end;
	end

	local closebtn = vgui.Create( "DButton", PasswordPanel )
	closebtn:SetText("[ЗАКРЫТЬ]")
	closebtn:SetPos( 15, 90 )
	closebtn:SetSize(250, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(30, 30, 150, 0));
		end;
	end;
	closebtn.DoClick = function(self)
		frame:Close(); frame:Remove();
	end;
	
end;
function OpenCPPDA(frame, OutLinedPanel, tableInformation, Settings, ID, actualLogs, chat)
	OutLinedPanel.ColorFrameBackground = Color(0, 0, 200)
	OutLinedPanel.getPageOfPDA = "";

	local InfoPanelUP = vgui.Create( "DPanel", frame )
	InfoPanelUP:SetPos( 0, 0 )
	InfoPanelUP:SetSize( 800, 20 )
	InfoPanelUP.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255));
		-- draw.DrawText( "< --- >", "DermaDefault", 330, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;

	local one = vgui.Create( "DButton", InfoPanelUP )
	one:SetText("ИНФОРМАЦИЯ")
	one:SetPos( 10, 0 )
	one:SetSize(85, 25)
	one:SetTextColor(Color(255, 255, 255, 255))
	one.Paint = function(self, x, y)
		if self:IsHovered() || (OutLinedPanel.getPageOfPDA == "information") then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	one.DoClick = function(self)
		if OutLinedPanel.getPageOfPDA != "information" then
			OpenCPInformation(OutLinedPanel, frame)
		end;
		OutLinedPanel.getPageOfPDA = "information";
	end;

	local two = vgui.Create( "DButton", InfoPanelUP )
	two:SetText("ЧАТ")
	two:SetPos( 100, 0 )
	two:SetSize(35, 25)
	two:SetTextColor(Color(255, 255, 255, 255))
	two.Paint = function(self, x, y)
		if self:IsHovered() || (OutLinedPanel.getPageOfPDA == "chat") then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	two.DoClick = function(self)
		if OutLinedPanel.getPageOfPDA != "chat" then
			OpenCPChat(OutLinedPanel, frame.everything, frame.settings, ID, chat)
		end;
		OutLinedPanel.getPageOfPDA = "chat";
	end;

	local three = vgui.Create( "DButton", InfoPanelUP )
	three:SetText("ГРАЖДАНЕ")
	three:SetPos( 140, 0 )
	three:SetSize(100, 25)
	three:SetTextColor(Color(255, 255, 255, 255))
	three.Paint = function(self, x, y)
		if self:IsHovered() || (OutLinedPanel.getPageOfPDA == "list") then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	three.DoClick = function(self)
		if OutLinedPanel.getPageOfPDA != "list" then
			OpenCPCitizenEdit(OutLinedPanel, frame)
		end;
		OutLinedPanel.getPageOfPDA = "list";
	end;
	
	local four = vgui.Create( "DButton", InfoPanelUP )
	four:SetText("НАСТРОЙКИ")
	four:SetPos( 250, 0 )
	four:SetSize(75, 25)
	four:SetTextColor(Color(255, 255, 255, 255))
	four.Paint = function(self, x, y)
		if self:IsHovered() || (OutLinedPanel.getPageOfPDA == "settings") then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	four.DoClick = function(self)
		if OutLinedPanel.getPageOfPDA != "settings" then
			OpenCPPDASettings(OutLinedPanel, frame.everything, frame.settings, ID)
		end;
		OutLinedPanel.getPageOfPDA = "settings";
	end;

	local six = vgui.Create( "DButton", InfoPanelUP )
	six:SetText("ЛОГИ")
	six:SetPos( 330, 0 )
	six:SetSize(75, 25)
	six:SetTextColor(Color(255, 255, 255, 255))
	six.Paint = function(self, x, y)
		if self:IsHovered() || (OutLinedPanel.getPageOfPDA == "logs") then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	six.DoClick = function(self)
		if OutLinedPanel.getPageOfPDA != "logs" then
			OpenLogs(OutLinedPanel, frame.settings, actualLogs)
		end;
		OutLinedPanel.getPageOfPDA = "logs";
	end;

	local five = vgui.Create( "DButton", InfoPanelUP )
	five:SetText("ВЫХОД")
	five:SetPos( 690, 0 )
	five:SetSize(50, 25)
	five:SetTextColor(Color(255, 255, 255, 255))
	five.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(0, 0, 0, x, y, Color(0, 128, 255, 255));
		end;
	end;
	five.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
        frame:Close(); frame:Remove();
	end;

	frame.Think = function(self)
		if (!self.cooldown or CurTime() >= self.cooldown) then
			if input.IsButtonDown( KEY_RIGHT ) && !frame.stop then
				surface.PlaySound("ui/buttonclick.wav");
				if OutLinedPanel.getPageOfPDA == "" then
					OpenCPInformation(OutLinedPanel, frame)
					OutLinedPanel.getPageOfPDA = "information";

				elseif OutLinedPanel.getPageOfPDA == "information" then
					OpenCPChat(OutLinedPanel, frame.everything, frame.settings, ID, chat)
					OutLinedPanel.getPageOfPDA = "chat";

				elseif OutLinedPanel.getPageOfPDA == "chat" then
					OpenCPCitizenEdit(OutLinedPanel, frame)
					OutLinedPanel.getPageOfPDA = "list";
				
				elseif OutLinedPanel.getPageOfPDA == "list" then
					OpenCPPDASettings(OutLinedPanel, frame.everything, frame.settings, ID)
					OutLinedPanel.getPageOfPDA = "settings";

				elseif OutLinedPanel.getPageOfPDA == "settings" then
					OpenLogs(OutLinedPanel, frame.settings, actualLogs)
					OutLinedPanel.getPageOfPDA = "logs";

				elseif OutLinedPanel.getPageOfPDA == "logs" then
					OpenCPInformation(OutLinedPanel, frame)
					OutLinedPanel.getPageOfPDA = "information";
				end;

			elseif input.IsButtonDown( KEY_LEFT ) && !frame.stop then
				surface.PlaySound("ui/buttonclick.wav");
				if OutLinedPanel.getPageOfPDA == "" then
					OpenLogs(OutLinedPanel, frame.settings, actualLogs)
					OutLinedPanel.getPageOfPDA = "logs";
				
				elseif OutLinedPanel.getPageOfPDA == "logs" then
					OpenCPPDASettings(OutLinedPanel, frame.everything, frame.settings, ID)
					OutLinedPanel.getPageOfPDA = "settings";

				elseif OutLinedPanel.getPageOfPDA == "settings" then
					OpenCPCitizenEdit(OutLinedPanel, frame)
					OutLinedPanel.getPageOfPDA = "list";
				
				elseif OutLinedPanel.getPageOfPDA == "list" then
					OpenCPChat(OutLinedPanel, frame.everything, frame.settings, ID, chat)
					OutLinedPanel.getPageOfPDA = "chat";

				elseif OutLinedPanel.getPageOfPDA == "chat" then
					OpenCPInformation(OutLinedPanel, frame)
					OutLinedPanel.getPageOfPDA = "information";

				elseif OutLinedPanel.getPageOfPDA == "information" then
					OpenLogs(OutLinedPanel, frame.settings, actualLogs)
					OutLinedPanel.getPageOfPDA = "logs";
				end;
			end;
			self.cooldown = CurTime() + 0.2;
		end;
	end;

end;
function OpenCPInformation(OutLinedPanel, frame)
	local Settings = frame.settings;
	local panelsColor = Color(0, 0, 255)
	local tableInformation = frame.everything;

	local InfoCPPanel = vgui.Create( "DPanel", OutLinedPanel )
	InfoCPPanel:SetPos( 10, 25 )
	InfoCPPanel:SetSize( 750, 420 )
	InfoCPPanel.info = {
			code = "---",
			status = "---",
			name = "---",
			rank = "---",
			squad = "---",
			info = "---"
	}
	InfoCPPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, panelsColor);
	end;
	InfoCPPanel.Think = function(self)
		if OutLinedPanel.getPageOfPDA != "information" then
			self:Remove();
		end;
	end;
	local InfoCPPanelI = vgui.Create( "DPanel", InfoCPPanel )
	InfoCPPanelI:SetPos( 5, 5 )
	InfoCPPanelI:SetSize( 375, 410 )
	InfoCPPanelI.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
	end;

	local InfoCPPanelI2 = vgui.Create( "DPanel", InfoCPPanel )
	InfoCPPanelI2:SetPos( 381, 5 )
	InfoCPPanelI2:SetSize( 365, 410 )
	InfoCPPanelI2.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
		draw.RoundedBox(0, 0, 384, w, 25, Color(0, 0, 0, 255));
		draw.DrawText( "Кодовое имя: "..InfoCPPanel.info.name, "DermaDefault", 5, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Ранг: "..InfoCPPanel.info.rank, "DermaDefault", 5, 30, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Отряд: "..InfoCPPanel.info.squad, "DermaDefault", 5, 45, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Статус сейчас: "..InfoCPPanel.info.status, "DermaDefault", 5, 60, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;

	local PersonalInfoCP = vgui.Create( "DTextEntry", InfoCPPanelI2 ) 
    PersonalInfoCP:SetPos( 5, 80 )
    PersonalInfoCP:SetSize( 355, 285 )
	PersonalInfoCP:SetText( "" )
	PersonalInfoCP:SetMultiline(true);
	PersonalInfoCP.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255, 255), Color(255, 255, 255, 255), Color(255, 255, 255, 255) )
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
	end;
	PersonalInfoCP:SetEnabled(false)
	PersonalInfoCP:SetAlpha(0)
	PersonalInfoCP:SetText( "" )

	local unitList = vgui.Create( "DGrid", InfoCPPanelI )
		unitList:SetPos( 10, 10 )
		unitList:SetCols( 4 )
		unitList:SetColWide( 60 )
		unitList:SetRowHeight( 30 )
	
	for k, v in pairs(tableInformation) do	
		
		if v["Rank"] then
			local Unit = vgui.Create( "DButton" )
			Unit:SetSize( 50, 30 )
			Unit:SetText(k)
			Unit:SetTextColor(Color(255, 255, 255, 255))
			Unit.Paint = function(self, w, h)
				draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
			end;
			Unit.DoClick = function()	
				InfoCPPanel.info.code = k
				InfoCPPanel.info.name = v["Name"]
				InfoCPPanel.info.rank = v["Rank"]
				InfoCPPanel.info.squad = v["Squad"]
				InfoCPPanel.info.info = v["Info"]
				InfoCPPanel.info.status = v["Status"]
				PersonalInfoCP:SetEnabled(true)
				PersonalInfoCP:SetAlpha(255)
				PersonalInfoCP:SetText( InfoCPPanel.info.info )
				if InfoCPPanel.info.name == Clockwork.Client:GetName() then
					InfoCPPanelI2:SetEnabled(false)
				else
					InfoCPPanelI2:SetEnabled(true)
				end;
			end;
			
			unitList:AddItem( Unit )
		end;

	end;	

	local EditRank = vgui.Create( "DButton", InfoCPPanelI2 )
	EditRank:SetSize( 50, 20 )
	EditRank:SetPos(7, 386)
	EditRank:SetText("")
	EditRank:SetTextColor(Color(0, 0, 0, 255))
	EditRank.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "1", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Ранг", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditRank.DoClick = function(self)
		surface.PlaySound("ui/buttonclick.wav");
		if InfoCPPanel.info.rank != "---" then
		InfoCPPanelI2:SetEnabled(false)
		frame.stop = true;
			Derma_StringRequest( "Изменить ранг юнита", "", InfoCPPanel.info.rank, function(text)
				if InfoCPPanel.info.rank != "---" && Schema:IsCombineRank(text) then
				local nameStart, nameEnd = string.find( tableInformation[InfoCPPanel.info.code].Name, "%p"..InfoCPPanel.info.rank.."%p" )
					InfoCPPanel.info.rank = text
					cable.send('ChangeDataOfUnit', {"Rank", InfoCPPanel.info.rank, InfoCPPanel.info.name});
                	if nameStart then
						local nameReplacedText = string.sub( tableInformation[InfoCPPanel.info.code].Name, 1, nameStart - 1 ) .. "-"..text..":" .. string.sub( tableInformation[InfoCPPanel.info.code].Name, nameEnd + 1 )
						tableInformation[InfoCPPanel.info.code].Name = nameReplacedText
						InfoCPPanel.info.name = nameReplacedText
					end;
					tableInformation[InfoCPPanel.info.code].Rank = text
					InfoCPPanelI2:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				InfoCPPanelI2:SetEnabled(true)
				frame.stop = false;
			end);
		end;
	end;
	EditRank.Think = function(self)
		if input.IsButtonDown( KEY_1 ) && (!self.cooldown or CurTime() >= self.cooldown) && InfoCPPanelI2:IsEnabled() && InfoCPPanel.info.rank != "---" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;

	local EditSquad = vgui.Create( "DButton", InfoCPPanelI2 )
	EditSquad:SetSize( 62, 20 )
	EditSquad:SetPos(65, 386)
	EditSquad:SetText("")
	EditSquad:SetTextColor(Color(0, 0, 0, 255))
	EditSquad.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "2", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Отряд", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditSquad.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if InfoCPPanel.info.squad != "---" then
		InfoCPPanelI2:SetEnabled(false)
		frame.stop = true;
			Derma_StringRequest( "Изменить отряд юнита", "", InfoCPPanel.info.squad, function(text)
				if InfoCPPanel.info.squad != "---" then
					InfoCPPanel.info.squad = text;
					tableInformation[InfoCPPanel.info.code].Squad = text
					cable.send('ChangeDataOfUnit', {"Squad", InfoCPPanel.info.squad, InfoCPPanel.info.name});
					InfoCPPanelI2:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				InfoCPPanelI2:SetEnabled(true)
				frame.stop = false;
			end);
		end;
	end;
	EditSquad.Think = function(self)
		if input.IsButtonDown( KEY_2 ) && (!self.cooldown or CurTime() >= self.cooldown) && InfoCPPanelI2:IsEnabled() && InfoCPPanel.info.squad != "---" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;

	local SaveInfo = vgui.Create( "DButton", InfoCPPanelI2 )
	SaveInfo:SetSize( 96, 20 )
	SaveInfo:SetPos(135, 386)
	SaveInfo:SetText("")
	SaveInfo:SetTextColor(Color(0, 0, 0, 255))
	SaveInfo.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "3", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Сохранить", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	SaveInfo.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if InfoCPPanel.info.info != "---" && InfoCPPanel.info.info != PersonalInfoCP:GetValue() then
			InfoCPPanel.info.info = PersonalInfoCP:GetValue();
			tableInformation[InfoCPPanel.info.code].Info = PersonalInfoCP:GetValue();
			cable.send('ChangeDataOfUnit', {"Info", PersonalInfoCP:GetValue(), InfoCPPanel.info.name});
		end;
	end;
	SaveInfo.Think = function(self)
		if input.IsButtonDown( KEY_3 ) && (!self.cooldown or CurTime() >= self.cooldown) && InfoCPPanelI2:IsEnabled() && InfoCPPanel.info.info != "---" && InfoCPPanel.info.info != PersonalInfoCP:GetValue() then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;

	if !Schema:IsPlayerCombineRank(Clockwork.Client, {"EpU", "CmR", "DvL", "SeC"}) || !Schema:IsPlayerCombineRankShared(Clockwork.Client, {"EpU", "CmR", "DvL", "SeC"}) then
		local BlockedPanels = vgui.Create( "DPanel", OutLinedPanel )
		BlockedPanels:SetPos( 10, 25 )
		BlockedPanels:SetSize( 750, 420 )
		BlockedPanels.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 100));
			draw.DrawText( "ВАМ ЗАПРЕЩЕНО ИСПОЛЬЗОВАТЬ ЭТУ ПАНЕЛЬ!", "DermaDefault", 350, 210, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end;
		BlockedPanels.Think = function(self)
			if OutLinedPanel.getPageOfPDA != "information" then
				self:Remove();
			end;
		end;	
		InfoCPPanel:SetEnabled(false);
	end;
end;
function OpenCPChat(OutLinedPanel, tableInformation, Settings, id, chat)
	local panelsColor = Color(0, 0, 200)

	local chatPanel = vgui.Create( "DPanel", OutLinedPanel )
	chatPanel:SetPos( 10, 25 )
	chatPanel:SetSize( 750, 420 )
	chatPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, panelsColor);
	end;
	chatPanel.Think = function(self)
		if OutLinedPanel.getPageOfPDA != "chat" then
			self:Remove();
		end;
	end;

	local chatPanelII = vgui.Create( "DScrollPanel", chatPanel )
	chatPanelII:SetPos( 5, 5 )
	chatPanelII:SetSize( 740, 374 )
	chatPanelII.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
	end;

	for k, v in pairs(chat) do
		local chateek = chatPanelII:Add( "DPanel" )
		chateek:Dock( TOP )
		chateek:DockMargin( 5, 5, 5, 5 )
		chateek.Paint = function(self, w, h)
			draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
			draw.DrawText( v["text"], "DermaDefault", 140, 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
			draw.DrawText( v["name"].."["..v["id"].."]", "DermaDefault", 3, 4, Color(100, 255, 100, 255), TEXT_ALIGN_LEFT )
		end;
	end;

	local ChatSend = vgui.Create( "DTextEntry", chatPanel ) 
    ChatSend:SetPos( 5, 380 )
    ChatSend:SetSize( 740, 35 )
	ChatSend:SetText( "" )
	ChatSend:SetMultiline(false);
	ChatSend.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255, 255), Color(255, 255, 255, 255), Color(255, 255, 255, 255) )
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
	end;
	ChatSend.OnEnter = function()
		if Settings["chatBlocked"] then
			return;
		end;
		local nameself = "Неизвестный";
		if Clockwork.Client:GetFaction() == FACTION_MPF then
			one, two, nameself = string.find(Clockwork.Client:GetName(), ".+(%d%d%d)")
		end;
		table.insert(chat, {
			text = ChatSend:GetValue(),
			name = nameself,
			id = id
		})
		chatPanel:Remove()

		cable.send('AddChatMessage', {ChatSend:GetValue(), nameself, id});
		OpenCPChat(OutLinedPanel, tableInformation, Settings, id, chat)
	end;
	
	if Settings["chatBlocked"] then
		local BlockedPanels = vgui.Create( "DPanel", OutLinedPanel )
		BlockedPanels:SetPos( 10, 25 )
		BlockedPanels:SetSize( 750, 420 )
		BlockedPanels.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 255));
			draw.DrawText( "ВАМ ЗАПРЕЩЕНО ИСПОЛЬЗОВАТЬ ЭТУ ПАНЕЛЬ!", "DermaDefault", 350, 210, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end;
		BlockedPanels.Think = function(self)
			if OutLinedPanel.getPageOfPDA != "chat" then
				self:Remove();
			end;
		end;	
		chatPanel:SetEnabled(false);
	end;
end;
function OpenCPCitizenEdit(OutLinedPanel, frame)
	local Settings = frame.settings;
	local tableInformation = frame.everything;

	local panelsColor = Color(0, 0, 200)

	local citizenInfo = vgui.Create( "DPanel", OutLinedPanel )
	citizenInfo.CitizenInfotable = {
		name = "",
		cid = "",
		ol = "",
		on = "",
		workplace = "",
		liveplace = "",
		informationCitizen = ""
	}
	citizenInfo:SetPos( 10, 17 )
	citizenInfo:SetSize( 750, 435 )
	citizenInfo.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, panelsColor);
		draw.RoundedBox(0, 5, 405, w-10, 25, Color(0, 0, 0, 255));
	end;
	citizenInfo.Think = function(self)
		if OutLinedPanel.getPageOfPDA != "list" then
			self:Remove();
		end;
	end;
	local tblSelf = citizenInfo.CitizenInfotable;

	local citizenInfoI = vgui.Create( "DPanel", citizenInfo )
	citizenInfoI:SetPos( 5, 5 )
	citizenInfoI:SetSize( 740, 365 )
	citizenInfoI.Paint = function(self, w, h)
		local tbl = citizenInfo.CitizenInfotable;
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
		draw.DrawText( "Имя, фамилия: "..tbl.name, "Trebuchet18", 7, 4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "CID: "..tbl.cid, "Trebuchet18", 7, 24, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОЛ: "..tbl.ol, "Trebuchet18", 7, 40, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОН: "..tbl.on, "Trebuchet18", 7, 56, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Место работы: "..tbl.workplace, "Trebuchet18", 7, 74, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Место жительства: "..tbl.liveplace, "Trebuchet18", 7, 92, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	local InformationPanelCitizen = vgui.Create( "DTextEntry", citizenInfoI ) 
    InformationPanelCitizen:SetPos( 5, 110 )
    InformationPanelCitizen:SetSize( 730, 250 )
	InformationPanelCitizen:SetText( "" )
	InformationPanelCitizen:SetMultiline(true);
	InformationPanelCitizen.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255, 255, 255, 255), Color(255, 255, 255, 255), Color(255, 255, 255, 255) )
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, panelsColor, Color(255, 255, 255) )
	end;
	InformationPanelCitizen:Hide();

	local SearchCitizen = vgui.Create( "DTextEntry", citizenInfo ) 
    SearchCitizen:SetPos( 5, 378 )
    SearchCitizen:SetSize( 740, 25 )
    SearchCitizen.TextColor = Color(255, 255, 255, 255);
	SearchCitizen:SetText( "" )
	SearchCitizen:SetMultiline(false);
	SearchCitizen.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(255,255,255), Color(255, 255, 255, 255), Color(255, 255, 255, 255) )
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
	end;
	SearchCitizen.OnEnter = function(self)
		if tableInformation[self:GetText()] && tableInformation[self:GetText()].CID then
			tblSelf.name = self:GetText();
			tblSelf.ol = tableInformation[self:GetText()].ol
			tblSelf.on = tableInformation[self:GetText()].on
			tblSelf.cid = tableInformation[self:GetText()].CID
			tblSelf.workplace = tableInformation[self:GetText()].workplace
			tblSelf.liveplace = tableInformation[self:GetText()].liveplace
			InformationPanelCitizen:SetText(tableInformation[self:GetText()].information)
			InformationPanelCitizen:Show()
			self:SetText("")
		end;
		surface.PlaySound("ui/buttonclick.wav");
	end
	local EditOL = vgui.Create( "DButton", citizenInfo )
	EditOL:SetSize( 40, 25 )
	EditOL:SetPos(5, 405)
	EditOL:SetText("")
	EditOL:SetTextColor(Color(0, 0, 0, 255))
	EditOL.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "1", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОЛ", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditOL.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if tblSelf.name != "" then
			citizenInfo:SetEnabled(false)
			frame.stop = true;
			Derma_StringRequest( "Изменить ОЛ гражданина", "", tblSelf.ol, function(text)
				if tblSelf.name != "" && tonumber(text) < 100 then
					tblSelf.ol = text
					tableInformation[tblSelf.name].ol = text
					cable.send('ChangeDataOfCitizen', {"editOL", text, tblSelf.name});

					citizenInfo:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				frame.stop = false;
				citizenInfo:SetEnabled(true)
			end);
		end;
	end;
	EditOL.Think = function(self)
		if input.IsButtonDown( KEY_1 ) && (!self.cooldown or CurTime() >= self.cooldown) && citizenInfo:IsEnabled() && tblSelf.name != "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local EditON = vgui.Create( "DButton", citizenInfo )
	EditON:SetSize( 40, 25 )
	EditON:SetPos(50, 405)
	EditON:SetText("")
	EditON:SetTextColor(Color(0, 0, 0, 255))
	EditON.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "2", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "ОН", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditON.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if tblSelf.name != "" then
			citizenInfo:SetEnabled(false)
			frame.stop = true;
			Derma_StringRequest( "Изменить ОН гражданина", "", tblSelf.on, function(text)
				if tblSelf.name != "" && tonumber(text) < 100 then
					tblSelf.on = text
					tableInformation[tblSelf.name].on = text
					cable.send('ChangeDataOfCitizen', {"editON", text, tblSelf.name});

					citizenInfo:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				citizenInfo:SetEnabled(true)
				frame.stop = false;
			end);
		end;
	end;
	EditON.Think = function(self)
		if input.IsButtonDown( KEY_2 ) && (!self.cooldown or CurTime() >= self.cooldown) && citizenInfo:IsEnabled() && tblSelf.name != "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local EditLivePlace = vgui.Create( "DButton", citizenInfo )
	EditLivePlace:SetSize( 160, 25 )
	EditLivePlace:SetPos(100, 405)
	EditLivePlace:SetText("")
	EditLivePlace:SetTextColor(Color(0, 0, 0, 255))
	EditLivePlace.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "3", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Место жительства", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditLivePlace.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if tblSelf.name != "" then
			citizenInfo:SetEnabled(false)
			frame.stop = true;
			Derma_StringRequest( "Изменить место жительства гражданина", "", tblSelf.liveplace, function(text)
				if tblSelf.name != "" then
					tblSelf.liveplace = text
					tableInformation[tblSelf.name].liveplace = text
					cable.send('ChangeDataOfCitizen', {"LivePlace", text, tblSelf.name});
					citizenInfo:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				citizenInfo:SetEnabled(true)
				frame.stop = false;
			end);
		end;
	end;
	EditLivePlace.Think = function(self)
		if input.IsButtonDown( KEY_3 ) && (!self.cooldown or CurTime() >= self.cooldown) && citizenInfo:IsEnabled() && tblSelf.name != "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local EditWorkPlace = vgui.Create( "DButton", citizenInfo )
	EditWorkPlace:SetSize( 130, 25 )
	EditWorkPlace:SetPos(265, 405)
	EditWorkPlace:SetText("")
	EditWorkPlace:SetTextColor(Color(0, 0, 0, 255))
	EditWorkPlace.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "4", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Место работы", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	EditWorkPlace.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if tblSelf.name != "" then
			citizenInfo:SetEnabled(false)
			frame.stop = true;
			Derma_StringRequest( "Изменить место работы гражданина", "", tblSelf.workplace, function(text)
				if tblSelf.name != "" then
					tblSelf.workplace = text
					tableInformation[tblSelf.name].workplace = text
					cable.send('ChangeDataOfCitizen', {"WorkPlace", text, tblSelf.name});
					citizenInfo:SetEnabled(true)
					frame.stop = false;
				end;
			end,
			function()
				citizenInfo:SetEnabled(true)
				frame.stop = false;
			end);
		end;
	end;
	EditWorkPlace.Think = function(self)
		if input.IsButtonDown( KEY_4 ) && (!self.cooldown or CurTime() >= self.cooldown) && citizenInfo:IsEnabled() && tblSelf.name != "" then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	local SaveInformation = vgui.Create( "DButton", citizenInfo )
	SaveInformation:SetSize( 200, 25 )
	SaveInformation:SetPos(400, 405)
	SaveInformation:SetText("")
	SaveInformation:SetTextColor(Color(0, 0, 0, 255))
	SaveInformation.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 179, 179, 255));
		draw.RoundedBox(0, 0, 0, 10, h, Color(0, 0, 0, 255));
		draw.DrawText( "5", "Trebuchet18", 4, 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.DrawText( "Сохранить информацию", "Trebuchet18", 12, 2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;
	SaveInformation.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav");
		if tblSelf.name != "" && tblSelf.information != InformationPanelCitizen:GetValue() then
			tblSelf.information = InformationPanelCitizen:GetValue()
			tableInformation[tblSelf.name].information = InformationPanelCitizen:GetValue()
			cable.send('ChangeDataOfCitizen', {"InfoR", InformationPanelCitizen:GetValue(), tblSelf.name});
		end;		
	end;
	SaveInformation.Think = function(self)
		if input.IsButtonDown( KEY_5 ) && (!self.cooldown or CurTime() >= self.cooldown) && citizenInfo:IsEnabled() && tblSelf.name != "" && tblSelf.information != InformationPanelCitizen:GetValue() then
			self.DoClick()
			self.cooldown = CurTime() + 1;
		end;
	end;
	
end;
function OpenCPPDASettings(OutLinedPanel, tableInformation, Settings, ID)
	
end;
function OpenLogs(OutLinedPanel, Settings, logs)
	local panelsColor = Color(0, 0, 200)

	local logpanel = vgui.Create( "DPanel", OutLinedPanel )
	logpanel:SetPos( 10, 25 )
	logpanel:SetSize( 750, 420 )
	logpanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, panelsColor);
	end;
	logpanel.Think = function(self)
		if OutLinedPanel.getPageOfPDA != "logs" then
			self:Remove();
		end;
	end;
	local LogsPanel = vgui.Create( "DListView", logpanel )
	LogsPanel:Dock( FILL )
	LogsPanel:SetMultiSelect( false )
	LogsPanel:AddColumn( "Имя" )
	LogsPanel:AddColumn( "ОЛ" )
	LogsPanel:AddColumn( "ОН" )
	LogsPanel:AddColumn( "Место работы" )
	LogsPanel:AddColumn( "Место жительства" )
	LogsPanel:AddColumn( "Изменивший" )

	for k, v in pairs(logs) do
		LogsPanel:AddLine( v["name"], v["OL"], v["ON"], v["WorkInfo"], v["LiveInfo"], v["editor"] )
	end;
end;

function DrawMePls(citizens, code, hasitem, cardEdited)
	local scrW = surface.ScreenWidth();
	local scrH = surface.ScreenHeight();
	local sW = (scrW/2) - 250;
	local sH = (scrH/2) - 350;

	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(610, 610)
	frame:SetTitle("")
	frame.tray_cash = {}
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;

	local WindowsPanel = vgui.Create( "DPanel", frame )
	WindowsPanel:SetPos( 10, 10 )
	WindowsPanel:SetSize( 540, 590 )
	WindowsPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, code["BackGroundColor"], Color(255, 180, 80, 150));
	end;
	WindowsPanel:Hide()

	local NotePanel = vgui.Create( "DPanel", WindowsPanel )
	NotePanel:SetPos( 0, 560 )
	NotePanel:SetSize( 540, 30 )
	NotePanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 180, 80, 150));
		surface.DrawLine( 160, 0, 160, 35 )
		surface.DrawLine( 480, 0, 480, 35 )
		draw.DrawText( os.date( "%H:%M:%S" , os.time() ), "DermaDefault", 490, 8, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;

	local closebtn = vgui.Create( "DButton", NotePanel )
	closebtn:SetText("[X]")
	closebtn:SetPos( 0, 0 )
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

	local callCPs = vgui.Create( "DButton", NotePanel )
	callCPs:SetText("[Позвать ГО]")
	callCPs:SetPos( 60, 0 )
	callCPs:SetSize(100, 30)
	callCPs:SetTextColor(Color(232, 100, 100, 255))
	callCPs.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 0));
		end;
	end;
	callCPs.DoClick = function(self)
		cable.send('AddNewCombineLinePDA', Clockwork.Client:Name());
		surface.PlaySound("buttons/button16.wav");
	end;

	local PasswordPanel = vgui.Create( "DTextEntry", frame ) 
	PasswordPanel:SetPos( 150, 250 )
	PasswordPanel:SetSize( 250, 20 )
	PasswordPanel:SetText( "" )
	PasswordPanel:SetMultiline(false);
	PasswordPanel.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 150));
	end;

	local EPPanel = vgui.Create( "DPanel", frame )
	EPPanel:SetPos( 150, 350 )
	EPPanel:SetSize( 250, 100 )
	EPPanel.errMessage = "";
	EPPanel.Paint = function(self, w, h)
		if self.errMessage != "" then
			draw.SimpleTextOutlined( self.errMessage, "DermaDefault", 80, 80, Color( 255, 100, 100, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
		end;
	end;

	local EditPassword = vgui.Create( "DTextEntry", EPPanel ) 
	EditPassword:SetPos( 0, 30 )
	EditPassword:SetSize( 250, 0 )
	EditPassword:SetText( code["Code"] )
	EditPassword:SetMultiline(false);
	EditPassword.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 150));
	end;
	
	EditPassword:SetEnabled(false)

	local SavePassword = vgui.Create( "DButton", EPPanel )
	SavePassword:SetText("Сохранить")
	SavePassword:SetPos( 0, 55 )
	SavePassword:SetSize(250, 0)
	SavePassword:SetTextColor(Color(232, 187, 8, 255))
	SavePassword.Paint = function(self, x, y)
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
	end;
	SavePassword.DoClick = function(self)
		local num = tonumber(EditPassword:GetValue());
		if string.len(EditPassword:GetValue()) >= 5 && isnumber(num) && EPPanel:IsEnabled() then
		EPPanel.errMessage = "Готово!";
		self:SetEnabled(false);
		code["Code"] = EditPassword:GetValue();
		EditPassword:SetEnabled(false);
		EPPanel:AlphaTo(0, 1, 0, function()
			EPPanel:Remove()
		end);
		cable.send('EditCodeForPDA', EditPassword:GetValue());
		
		elseif string.len(EditPassword:GetValue()) < 5 then
			EPPanel.errMessage = "Слишком коротко!"
		elseif !isnumber(num) then
			EPPanel.errMessage = "Пароль состоит не из цифр!"
		end;
	end;
	SavePassword:SetEnabled(false)

	local OpenEditPassword = vgui.Create( "DButton", EPPanel )
	OpenEditPassword:SetText(">")
	OpenEditPassword:SetPos( 0, 5 )
	OpenEditPassword:SetSize(250, 20)
	OpenEditPassword:SetTextColor(Color(232, 187, 8, 255))
	OpenEditPassword.Paint = function(self, x, y)
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
	end;
	OpenEditPassword.DoClick = function(self)
		
		if !EditPassword:IsEnabled() then
			EditPassword:SizeTo( 250, 20, 1, 0, -1, function()
				EditPassword:SetEnabled(true);
			end)
			SavePassword:SizeTo( 250, 20, 1, 0, -1, function()
				SavePassword:SetEnabled(true);
			end)
			self:SetText("v")
		else
			EditPassword:SizeTo( 250, 0, 1, 0, -1, function()
				EditPassword:SetEnabled(false);
			end)
			SavePassword:SizeTo( 250, 0, 1, 0, -1, function()
				SavePassword:SetEnabled(false);
			end)
			self:SetText(">")
		end;

	end;

	EPPanel:SetEnabled(false)

	if hasitem && !cardEdited then
		EPPanel:SetEnabled(true);
	end;

	local Enter = vgui.Create( "DButton", frame )
	Enter:SetText("Ввести пароль")
	Enter:SetPos( 235, 280 )
	Enter:SetSize(90, 30)
	Enter:SetTextColor(Color(232, 187, 8, 255))
	Enter.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBoxOutlined(2, 0, 0, x, y, Color(0, 0, 0, 100), Color(255, 180, 80, 150));
		end;
	end;
	Enter.DoClick = function(self)
		
		if code["Code"] == tonumber(PasswordPanel:GetText()) then
			WindowsPanel:Show();
			EPPanel:Remove();
			self:Remove();
			PasswordPanel:Remove();
		else
			surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
			frame:Close(); frame:Remove();
		end;
	end;

	local instrumentsGRID = vgui.Create( "DGrid", WindowsPanel )
	instrumentsGRID:SetPos(10, 10)
	instrumentsGRID:SetSize(350, 250)
	instrumentsGRID:SetCols( 1 )
	instrumentsGRID:SetColWide( 100 )
	instrumentsGRID:SetRowHeight( 60 )
	
		for i = 1, 4 do		
			local InfoIcons = vgui.Create( "DButton" )
			InfoIcons:SetSize( 100, 50 )
			if i == 1 then
				InfoIcons:SetText("Блокнот")
			elseif i == 2 then
				InfoIcons:SetText("Гражданские")
			elseif i == 3 then
				InfoIcons:SetText("Отчетность")
			elseif i == 4 then
				InfoIcons:SetText("Настройки")	
			end;
			InfoIcons:SetTextColor(Color(232, 187, 8, 255))
			InfoIcons.Paint = function(self, w, h)
				draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 100), Color(255, 180, 80, 150));

				if self:IsHovered() then
					draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 10));
				end;

				if i == 1 && table.HasValue(frame.tray_cash, "Notepad") then
					draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 10));
				elseif i == 2 && table.HasValue(frame.tray_cash, "Citizens") then
					draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 10));
				elseif i == 3 && table.HasValue(frame.tray_cash, "Browser") then
						draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 10));
				elseif i == 4 && table.HasValue(frame.tray_cash, "Settings") then
						draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 10));
				end;
			end;
			InfoIcons.DoClick = function(self)
				if i == 1 then
					
					if !table.HasValue(frame.tray_cash, "Notepad") then
						CreateTextPad(WindowsPanel, self, frame, code)
						table.insert(frame.tray_cash, "Notepad")
					end;

				elseif i == 2 then

					if !table.HasValue(frame.tray_cash, "Citizens") then
						CreateCitizenPad(WindowsPanel, self, citizens, frame)
						table.insert(frame.tray_cash, "Citizens")
					end;	

				elseif i == 3 then

					if !table.HasValue(frame.tray_cash, "Browser") then
						CreateBrowser(WindowsPanel, self, frame)
						table.insert(frame.tray_cash, "Browser")
					end;
					
				elseif i == 4 then

					if !table.HasValue(frame.tray_cash, "Settings") then
						CreateSettings(WindowsPanel, self, frame, code)
						table.insert(frame.tray_cash, "Settings")
					end;

				end;

			end;
			instrumentsGRID:AddItem( InfoIcons )
		end;

end
function CreateTextPad(pnl, button, f, textNotePad)

	local Notepad = vgui.Create( "DTextEntry", pnl ) 
	Notepad:SetPos( 120, 20 )
	Notepad:SetSize( 400, 400 )
	Notepad:SetText( textNotePad["Notepad"] )
	Notepad:SetMultiline(true);
	Notepad.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBox(2, 0, 0, w, h, Color(0, 0, 0, 150));
	end;

	local CreateCross = vgui.Create( "DButton", button )
	CreateCross:SetText("")
	CreateCross:SetPos( 85, 35 )
	CreateCross:SetSize(10, 10)
	CreateCross:SetTextColor(Color(232, 187, 8, 255))
	CreateCross.Paint = function(self, x, y)
		draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
		surface.SetDrawColor(232, 187, 8, 255)
		surface.DrawLine( 0, 0, 10, 10 )
		surface.DrawLine( 0, 10, 10, 0 )
	end;
	CreateCross.DoClick = function(self)
		textNotePad["Notepad"] = Notepad:GetValue()
		Notepad:Remove()
		self:Remove()
		table.RemoveByValue(f.tray_cash, "Notepad")

		cable.send('EditOptionsForCWUPDA', "Text", Notepad:GetValue());
	end;

end;
function CreateCitizenPad(pnl, button, citizens, f)

	local Citizens = vgui.Create( "DPanel", pnl )
	Citizens:SetPos( 120, 20 )
	Citizens:SetSize( 400, 400 )
	Citizens.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 180, 80, 150));
	end;

	local CitizensList = vgui.Create( "DListView", Citizens )
	CitizensList:Dock( FILL )
	CitizensList:SetMultiSelect( false )
	CitizensList:AddColumn( "Имя" )
	CitizensList:AddColumn( "CID" )
	CitizensList:AddColumn( "ОЛ" )
	CitizensList:AddColumn( "ОН" )
	CitizensList:AddColumn( "Жительство" )
	CitizensList:AddColumn( "Работа" )

	for k, v in pairs(citizens) do
		CitizensList:AddLine( k, v["CID"], v["ol"], v["on"], v["liveplace"], v["workplace"] )
	end;

	local CreateCross = vgui.Create( "DButton", button )
	CreateCross:SetText("")
	CreateCross:SetPos( 85, 35 )
	CreateCross:SetSize(10, 10)
	CreateCross:SetTextColor(Color(232, 187, 8, 255))
	CreateCross.Paint = function(self, x, y)
		draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
		surface.SetDrawColor(232, 187, 8, 255)
		surface.DrawLine( 0, 0, 10, 10 )
		surface.DrawLine( 0, 10, 10, 0 )
	end;
	CreateCross.DoClick = function(self)
			Citizens:Remove()
			self:Remove()
			table.RemoveByValue(f.tray_cash, "Citizens")
	end;
	
end;
function CreateBrowser(pnl, button, f)

	local BrowseMeShit = vgui.Create( "DPanel", pnl )
	BrowseMeShit:SetPos( 120, 20 )
	BrowseMeShit:SetSize( 400, 400 )
	BrowseMeShit.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 180, 80, 150));
		-- draw.DrawText( "Привет, тут ничего пока-что нет.", "DermaDefault", 110, 200, Color(232, 50, 50, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end;

	local GoogleDrive = vgui.Create( "DHTML", BrowseMeShit )
	GoogleDrive:Dock( FILL )
	GoogleDrive:OpenURL( "https://www.google.com/drive/" )

	local CreateCross = vgui.Create( "DButton", button )
	CreateCross:SetText("")
	CreateCross:SetPos( 85, 35 )
	CreateCross:SetSize(10, 10)
	CreateCross:SetTextColor(Color(232, 187, 8, 255))
	CreateCross.Paint = function(self, x, y)
		draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
		surface.SetDrawColor(232, 187, 8, 255)
		surface.DrawLine( 0, 0, 10, 10 )
		surface.DrawLine( 0, 10, 10, 0 )
	end;
	CreateCross.DoClick = function(self)
			BrowseMeShit:Remove()
			self:Remove()
			table.RemoveByValue(f.tray_cash, "Browser")
	end;

end;
function CreateSettings(pnl, button, f, code)

	local SettingsPanel = vgui.Create( "DPanel", pnl )
	SettingsPanel:SetPos( 120, 20 )
	SettingsPanel:SetSize( 400, 400 )
	SettingsPanel.Paint = function(self, w, h)
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 180, 80, 150));
	end;

	local Mixer = vgui.Create( "DColorMixer", SettingsPanel )
	Mixer:SetPos(10, 10)
	Mixer:SetSize(200, 200)
	Mixer:SetPalette( true )
	Mixer:SetAlphaBar( true )
	Mixer:SetWangs( true )
	Mixer:SetColor( code["BackGroundColor"] )

	local SaveColor = vgui.Create( "DButton", SettingsPanel )
	SaveColor:SetText("Save")
	SaveColor:SetPos( 220, 10 )
	SaveColor:SetSize(50, 30)
	SaveColor:SetTextColor(Color(232, 187, 8, 255))
	SaveColor.Paint = function(self, x, y)
		draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
	end;
	SaveColor.DoClick = function(self)
		code["BackGroundColor"] = Mixer:GetColor();
		cable.send('EditOptionsForCWUPDA', "Color", Mixer:GetColor());
	end;

	local CreateCross = vgui.Create( "DButton", button )
	CreateCross:SetText("")
	CreateCross:SetPos( 85, 35 )
	CreateCross:SetSize(10, 10)
	CreateCross:SetTextColor(Color(232, 187, 8, 255))
	CreateCross.Paint = function(self, x, y)
		draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 100));
		surface.SetDrawColor(232, 187, 8, 255)
		surface.DrawLine( 0, 0, 10, 10 )
		surface.DrawLine( 0, 10, 10, 0 )
	end;
	CreateCross.DoClick = function(self)
			SettingsPanel:Remove()
			self:Remove()
			table.RemoveByValue(f.tray_cash, "Settings")
	end;

end;
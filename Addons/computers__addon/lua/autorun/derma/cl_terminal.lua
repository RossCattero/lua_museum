local PANEL = {};

function PANEL:Init()
    self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(800, 500, 0.31, 0.3)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(5, 5, 5, 255), Color(25, 25, 25) )
    self:CreateCloseDebug()

	if input.IsKeyDown( KEY_TAB ) then
        self._textInput:RequestFocus()
    end;
end;


function PANEL:Populate()
	self.content = self:Add('Panel')
    self.content:Dock(FILL)

	self.history = self.content:Add('DScrollPanel')
    self.history:Dock(FILL)
	self.history:DockMargin(0, 0, 0, 0)

	self.inputPlace = self.content:Add('Panel')
	self.inputPlace:Dock(BOTTOM)
	self.inputPlace:SetTall(25)

	self._infoInput = self.inputPlace:Add('DLabel')
	self._infoInput:SetFont('DebugFixed')
	self._infoInput:Dock(LEFT)
	self._infoInput:SetWide(40)
	self._infoInput:SetText(CMDPREFIX)
	self._infoInput:DockMargin(10, 0, 0, 0)

	self._textInput = self.inputPlace:Add('DTextEntry')
	self._textInput:SetFont('DebugFixed')
	self._textInput:Dock(FILL)
	self._textInput:SetText('')
	self._textInput:DockMargin(0, 5, 0, 5)
	self._textInput.Paint = function(s, w, h)
		s:DrawTextEntryText( Color(255, 255, 255), Color(100, 100, 100), Color(255 ,255, 255) )
	end;
	self._textInput:RequestFocus()

	for k, v in pairs(logsTerminal) do
		local msg = self:addCommand(v, false, 'log');
		msg:DockMargin( 0, 0, 0, 0 )
	end

	self._textInput.OnEnter = function(input)
		if string.len(info) <= 1 then return end;

		if cmdExists(info) then
			self:addCommand(info, true);
			CMDLIST[info].action(self);
		else
			self:addCommand(info, true);
			self:addCommand("Command " .. info .. " is not found in command database. To see all commands, type '-help'.", true);
		end;

    	input:SetText("")
		input:RequestFocus()
	end
	
end;

function PANEL:addCommand(text, prefixed, t_type)
	if !t_type then
		t_type = 'msg'
	end
	if prefixed then
		prefixed = CMDPREFIX;
	else
		prefixed = "";
	end
	self.msgPnl = self.history:Add( "DLabel" )
	self.msgPnl:SetFont('DebugFixed')
	self.msgPnl:SetText( prefixed .. " " .. text )
	self.msgPnl:Dock( TOP )
	self.msgPnl:DockMargin( 7, 0, 0, 0 )
	
	if t_type == 'msg' then
		local ent = validateTerminal(LocalPlayer());
		if ent then
			netstream.Start('storeTerminalMessage', self.msgPnl:GetText(), ent:GetTerminalIndex());
			logsTerminal[#logsTerminal + 1] = message;
		end;
	end;

	return self.msgPnl
end;

function PANEL:OnRemove()
	local ent = validateTerminal(LocalPlayer());
	if ent then
		netstream.Start('closeTerminal', ent:GetTerminalIndex());
	end;
end

// Сделать так, чтобы компьютером нельзя было пользоваться, когда им уже пользуются.
// Сделать так, чтобы при включении, если в нем нужно авторизоваться, то при авторизации проверялась авторизованность на сервере.
// Сделать так, чтобы в случае, если пользователь не авторизовался в компьютере, то он не может им пользоваться.

vgui.Register( "Terminal", PANEL, "EditablePanel" )
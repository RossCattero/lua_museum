local PANEL = {};
local FractureCol = Color(255, 97, 0)
local mat = Material('materials/textures/paper.jpg')

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();

	self:SetPos((scrW/2) - 250, (scrH/2) - 350) 
    self:SetSize( 720, 610 )
    self:ShowCloseButton( false )
    self:SetTitle('')
	self:MakePopup()

    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )

	draw.DrawText( self.currentPage.."/"..table.Count(self.pages), "DermaDefault", 60, 585, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false); 
end;

function PANEL:Populate(pages, infom, entity)
	local pnl = self;
	self.pages = pages; self.infom = infom; self.currentPage = 1;

	self.currentPly = vgui.Create( "DPanel", self )
	self.currentPly:SetSize(150, 50)
	self.currentPly:SetPos(560, 10)
	function self.currentPly:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100));
	end;
	self.currentPlyScroll = vgui.Create("DScrollPanel", self.currentPly)
    self.currentPlyScroll:Dock( FILL )

	self.plylist = vgui.Create( "DPanel", self )
	self.plylist:SetSize(150, 540)
	self.plylist:SetPos(560, 65)
	function self.plylist:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100));
	end;
	self.plylistScroll = vgui.Create("DScrollPanel", self.plylist)
	self.plylistScroll:Dock( FILL )

	if next(infom['owners']) != nil then

		for k, v in pairs(infom['owners']) do
			if k != LocalPlayer():SteamID() && !LocalPlayer():GetCharacter() && infom['owners'][k] then
				local player_ = self.plylistScroll:Add( "DPanel" )
				player_:Dock( TOP )
				player_:SetSize(0, 40)
				player_:DockMargin( 5, 5, 5, 5 )
				function player_:Paint(w, h)    
					draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
					draw.DrawText( 'SID: '..k, "DermaDefault", 5, 15, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
				end;
				local allowTouse = player_:Add( "DCheckBox" )
				allowTouse:SetPos( 5, 20 )
				allowTouse:SetValue( infom['owners'][k] )
				function allowTouse:OnChange( val )
					infom['owners'][k] = val
				end;

			end;
		end;

	end;
	
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() != LocalPlayer():SteamID() && !infom['owners'][v:SteamID()] && LocalPlayer():GetCharacter() then
			local player_ = self.plylistScroll:Add( "DPanel" )
			player_:Dock( TOP )
			player_:SetSize(0, 40)
			player_:DockMargin( 5, 5, 5, 5 )
			function player_:Paint(w, h)
				if !IsValid(v) || !v:HasInitialized() then
					self:Remove();
					return;
				end;
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
				draw.DrawText( 'Имя: '..v:GetName(), "DermaDefault", 5, 5, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.DrawText( 'SID: '..v:SteamID(), "DermaDefault", 5, 15, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )	
			end;
			local allowTouse = player_:Add( "DCheckBox" )
			allowTouse:SetPos( 5, 20 )
			allowTouse:SetValue( infom['owners'][v:SteamID()] )
			function allowTouse:OnChange( val )
				infom['owners'][v:SteamID()] = val
			end;
		elseif v:SteamID() == LocalPlayer():SteamID() && LocalPlayer():GetCharacter() then
			local p_self = self.currentPlyScroll:Add( "DPanel" )
			p_self:Dock( TOP )
			p_self:SetSize(0, 40)
			p_self:DockMargin( 5, 5, 5, 5 )
			function p_self:Paint(w, h)     	
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255));	
				draw.DrawText( 'Имя: '..v:GetName(), "DermaDefault", 5, 5, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.DrawText( 'SID: '..v:SteamID(), "DermaDefault", 5, 15, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )		
			end;
			local allowTouse = p_self:Add( "DCheckBox" )
			allowTouse:SetPos( 5, 20 )
			allowTouse:SetValue( infom['owners'][v:SteamID()] )
			function allowTouse:OnChange( val )
				infom['owners'][v:SteamID()] = val
			end;
		end;
	end;

	self.paper = vgui.Create( "DPanel", self )
	self.paper:SetPos( 10, 10 )
	self.paper:SetSize( 540, 565 )
	self.paper.Paint = function(s, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( 0, 0, w, h )
	end;

	self.textHere = vgui.Create( "DTextEntry", self.paper ) 
	self.textHere:Dock(FILL)
	self.textHere:SetText( pages[pnl.currentPage]['info'] )
	self.textHere:SetMultiline(true);
	self.textHere.Paint = function(self, w, h)
		self:DrawTextEntryText( Color(0, 0, 0), Color(0, 0, 0), Color(0, 0, 0) )
	end;
	self.textHere.OnTextChanged = function(self)
        local txt = self:GetValue()
		local amt = utf8.len(txt)
        if isbool(amt) || amt > 2800 then
            self:SetText(self.OldText)
            self:SetValue(self.OldText)
        else
            self.OldText = txt;
		end;
		
		pages[pnl.currentPage]['info'] = txt
    end;

	self.Before = vgui.Create( "DButton", self )
	self.Before:SetSize( 40, 25 )
	self.Before:SetPos(10, 580)
	self.Before:SetText("<")
	self.Before:SetTextColor(FractureCol)
	self.Before.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
	self.Before.DoClick = function(self)
		pnl.currentPage = math.Clamp(pnl.currentPage - 1, 1, table.Count(pages));
		pnl.textHere:SetText(pages[pnl.currentPage]['info'])
	end;
	self.After = vgui.Create( "DButton", self )
	self.After:SetSize( 40, 25 )
	self.After:SetPos(85, 580)
	self.After:SetText(">")
	self.After:SetTextColor(FractureCol)
	self.After.DoClick = function(self)
		pnl.currentPage = math.Clamp(pnl.currentPage + 1, 1, table.Count(pages));
		pnl.textHere:SetText(pages[pnl.currentPage]['info'])
	end;
	self.After.Paint = function(self, w, h)
		dohover(self, w, h)
	end;

	self.SaveAll = vgui.Create( "DButton", self )
	self.SaveAll:SetSize( 70, 25 )
	self.SaveAll:SetPos(480, 580)
	self.SaveAll:SetText("СОХРАНИТЬ")
	self.SaveAll:SetTextColor(FractureCol)
	self.SaveAll.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
	self.SaveAll.DoClick = function(self)
		netstream.Start('EditNotepadInfo', entity, {pages, infom} );
		pnl:Close();
	end;
	self.SaveAllNoGetOut = vgui.Create( "DButton", self )
	self.SaveAllNoGetOut:SetSize( 150, 25 )
	self.SaveAllNoGetOut:SetPos(320, 580)
	self.SaveAllNoGetOut:SetText("СОХРАНИТЬ(БЕЗ ВЫХОДА)")
	self.SaveAllNoGetOut:SetTextColor(FractureCol)
	self.SaveAllNoGetOut.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
	self.SaveAllNoGetOut.DoClick = function(self)
		netstream.Start('EditNotepadInfo', entity, {pages, infom} );
	end;

	self.allowPickup = vgui.Create( "DCheckBoxLabel", self )
	self.allowPickup:SetPos( 130, 585 )
	self.allowPickup:SetText( 'Разрешить поднимать?' )
	self.allowPickup:SetValue( infom['canpickup'] )
	function self.allowPickup:OnChange( val )
		infom['canpickup'] = val;
	end;

	self.infoButton = vgui.Create( "DImageButton", self )
	self.infoButton:SetPos( 280, 585 )
	self.infoButton:SetImage( "icon16/information.png" )
	self.infoButton:SizeToContents()	
	self.infoButton.DoClick = function()
		gui.OpenURL( "https://docs.google.com/document/d/1PoiFW3y-yAguId0H94rPHZfONjwjBMYQ2aAZ9uuOqDQ/edit?usp=sharing" )
	end	
	self.infoButton.Paint = function(self, w, h)
		dohover(self, w, h)
	end	
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

function dohover(pnl, w, h)
	if !pnl.nol then
		pnl.nol = 0
	end;
	if pnl:IsHovered() then
		pnl.nol = math.Approach( pnl.nol, w, 300 * FrameTime() )
		draw.RoundedBox(0, 0, 0, pnl.nol, h, Color(255, 255, 255, 100));
	else
		pnl.nol = 0
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100));
	end;
end;

vgui.Register( "OpenNotepadEdit", PANEL, "DFrame" )
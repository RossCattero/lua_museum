local PANEL = {};
local FractureCol = Color(255, 97, 0)

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();

	self:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    self:SetSize( 380, 270 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function PANEL:Populate(ent, entinfo, items)
    local pnl = self;
    self.addItemsHere = vgui.Create( "DListView", self )
	self.addItemsHere:SetPos(10, 40)
    self.addItemsHere:SetSize(200, 200)
	self.addItemsHere:SetMultiSelect( false )
    self.addItemsHere:AddColumn( "Индекс" )
    self.addItemsHere:AddColumn( "Шанс" )
    self.addItemsHere.OnClickLine = function( p, l, s )
        self.addItemsHere:ClearSelection()
        self.addItemsHere:SelectItem(l)
        local menu = DermaMenu()
        menu:AddOption( "Удалить линию", function()
            local line = self.addItemsHere:GetSelectedLine();
            local lineinfo = self.addItemsHere:GetLine(line);
            items[ lineinfo.index ] = nil;
			self.addItemsHere:RemoveLine(line)
            self.addItemsHere:ClearSelection()
		end):SetImage("icon16/cancel.png")
		menu:Open()
    end;

    PrintTable(items)

    for k, v in pairs(items) do
        local q = self.addItemsHere:AddLine(k, v);
        q.index = k
    end;
    self.itemindex = vgui.Create( "DTextEntry", self )
	self.itemindex:SetPos( 10, 245 ) self.itemindex:SetSize( 80, 20 )
	self.itemindex:SetText( "" ) self.itemindex:SetMultiline(true) self.itemindex:SetPlaceholderText("Индекс")  
	self.itemindex.Paint = function(self, w, h)
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
    self.chanceHere = vgui.Create( "DNumberWang", self )
	self.chanceHere:SetPos( 95, 245 ) self.chanceHere:SetSize( 45, 20 ) self.chanceHere:SetValue( 1 ) self.chanceHere:SetMinMax( 1, 10 )
	self.chanceHere.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.itemIndexAdd = vgui.Create("DButton", self)
    self.itemIndexAdd:SetPos(145, 245) self.itemIndexAdd:SetSize(65, 20) self.itemIndexAdd:SetColor(Color(255, 100, 100))
    self.itemIndexAdd:SetText( '+' )
    function self.itemIndexAdd:DoClick(self)
        surface.PlaySound("ui/buttonclick.wav");
        if !items[pnl.itemindex:GetValue()] then
            if !Clockwork.item:FindByID(pnl.itemindex:GetValue()) then
                return;
            end;
            items[pnl.itemindex:GetValue()] = pnl.chanceHere:GetValue()
            local q = pnl.addItemsHere:AddLine(pnl.itemindex:GetValue(), pnl.chanceHere:GetValue());
            q.index = pnl.itemindex:GetValue()
        end;
    end;
    self.itemIndexAdd.Paint = function(self, w, h)
        dohover(self, w, h)
    end;
    self.modelText = vgui.Create( "DTextEntry", self )
	self.modelText:SetPos( 220, 40 ) self.modelText:SetSize( 150, 20 )
	self.modelText:SetText( ent:GetModel() ) self.modelText:SetMultiline(true) self.modelText:SetPlaceholderText("Модель")  
	self.modelText.Paint = function(self, w, h)
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

    self.timeSpawnItem = vgui.Create( "DNumberWang", self )
    self.timeSpawnItem:SetPos( 220, 65 ) self.timeSpawnItem:SetSize( 45, 20 ) self.timeSpawnItem:SetValue( 10 ) self.timeSpawnItem:SetMinMax( 10, 3600 )
    self.timeSpawnItem:SetText(entinfo['timetospawn'])
	self.timeSpawnItem.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.timeCleanItems = vgui.Create( "DNumberWang", self )
    self.timeCleanItems:SetPos( 270, 65 ) self.timeCleanItems:SetSize( 45, 20 ) self.timeCleanItems:SetValue( 10 ) self.timeCleanItems:SetMinMax( 1, 3600 )
    self.timeCleanItems:SetText(entinfo['timetoclean'])
	self.timeCleanItems.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;
    self.amountItems = vgui.Create( "DNumberWang", self )
    self.amountItems:SetPos( 320, 65 ) self.amountItems:SetSize( 45, 20 ) self.amountItems:SetValue( 1 ) self.amountItems:SetMinMax( 1, 5 )
    self.amountItems:SetText(entinfo['maxitems'])
	self.amountItems.Paint = function(self, w, h)
    	self:DrawTextEntryText( Color(232, 187, 8, 255), Color(232, 187, 8, 255), Color(232, 187, 8, 255) )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        if self:GetDisabled() then
            self:SetAlpha(100);
        else
            self:SetAlpha(255)
        end;
    end;

    self.CloseEditMenu = vgui.Create( "DButton", self )
	self.CloseEditMenu:SetSize( 60, 25 )
	self.CloseEditMenu:SetPos(10, 10)
	self.CloseEditMenu:SetText("ВЫЙТИ")
	self.CloseEditMenu:SetTextColor(FractureCol)
    self.CloseEditMenu.DoClick = function(self)
        local editable = {
            model = pnl.modelText:GetText(),
            maxitems = pnl.amountItems:GetText(),
            timetospawn = pnl.timeSpawnItem:GetValue(),
            timetoclean = pnl.timeCleanItems:GetValue()
        }
        PrintTable(items)
        cable.send('EditLootableEntity', ent, {editable, items});
        pnl:Close()
	end;
	self.CloseEditMenu.Paint = function(self, w, h)
		dohover(self, w, h)
	end;
end;

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

vgui.Register( "OpenSettingsRandomizer", PANEL, "DFrame" )
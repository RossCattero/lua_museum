local PANEL = {};
local ourMat = Material( "gui/gradient" )
local FractureCol = Color(255, 97, 0)

function PANEL:Init()

    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local pnl = self;

    self:SetPos((scrW/2) - 450, (scrH/2) - 350) 
    self:SetSize( 910, 500 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    self.sellerInventory = vgui.Create("DPanel", self)
    self.sellerInventory:SetPos(10, 10);
    self.sellerInventory:SetSize(500, 480)
    function self.sellerInventory:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
    end;

    self.playerInventory = vgui.Create("DPanel", self)
    self.playerInventory:SetPos(520, 10);
    self.playerInventory:SetSize(380, 430)
    function self.playerInventory:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
    end;

    self.scrollSellerInv = vgui.Create( "DScrollPanel", self.sellerInventory )
    self.scrollSellerInv:Dock( FILL );

    self.gridSellerInv = vgui.Create( "DGrid", self.scrollSellerInv )
    self.gridSellerInv:SetPos(10, 10)
    self.gridSellerInv:SetSize(480, 460)
    self.gridSellerInv:SetCols( 8 )
    self.gridSellerInv:SetColWide( 60 )
    self.gridSellerInv:SetRowHeight( 60 )

    self.scrollPlayerInv = vgui.Create( "DScrollPanel", self.playerInventory )
    self.scrollPlayerInv:Dock( FILL );

    self.close = vgui.Create("DButton", self)
    self.close:SetText( '' )
    self.close:SetPos(520, 450)
    self.close:SetSize(380, 40)
    function self.close:DoClick(self)
        pnl:Close()
        surface.PlaySound("ui/buttonclick.wav");
    end;
    function self.close:Paint(w, h)
        if self:IsHovered() then
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(255, 255, 255, 100), FractureCol )
        else
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
        end;
        draw.DrawText( '>>ЗАКРЫТЬ<<', "DermaDefault", 160, 14, Color(255, 50, 50), TEXT_ALIGN_LEFT )
    end; 

    gui.EnableScreenClicker(true);
end;

function PANEL:Populate(p, s, e, sifno)
    local pnl = self;
    self.playerInv = p; self.sellerInv = s; self.sellerInfo = sifno;
    if sifno['allowsell'] then
        for k, v in pairs(pnl.playerInv) do
            pnl:AddPlayerItemTable(e, k, v)
        end;
        self.sellerInventory:Remove();
    end;
    if sifno['allowbuy'] then
        for k, v in pairs(pnl.sellerInv) do
            pnl:AddItemTable(e, k, v)
        end;
        self.playerInventory:Remove()
    end;
end;

function PANEL:getQuality(cond)
    local text = '' local condcol = Color(255, 255, 255)
    if (cond) then
        if cond >= 9 then
            text = "В хорошем состоянии.";
            condcol = Color(10, 210, 0);
        elseif cond >= 6 then
            text = "В нормальном состоянии.";
            condcol = Color(70, 190, 0);
        elseif cond >= 3 then
            text = "В поношеном состоянии.";
            condcol = Color(170, 100, 0);		
        elseif cond < 3 then
            text = "Изношено.";
            condcol = Color(200, 60, 0);
        end;
    end;
    return text, condcol
end;

function PANEL:AddPlayerItemTable(e, id, tbl)
    local pnl = self;

    local item = self.scrollPlayerInv:Add( "DPanel" )
    item:SetAlpha(255)
    item:SetText( '' )
    item:SetSize(0, 55)
    item:Dock( TOP )
    item:DockMargin( 5, 5, 5, 5 )
    function item:Paint(w, h)
        surface.SetDrawColor( 100, 100, 100, 255 )
        surface.SetMaterial( ourMat	);
        surface.DrawTexturedRect( 0, 0, w, h );
        draw.DrawText( 'Название: '..tbl.name, "DermaDefault", 60, 10, Color(255, 255, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( 'Цена продажи: '..tbl.priceSales, "DermaDefault", 60, 20, Color(255, 255, 255), TEXT_ALIGN_LEFT )
        if Clockwork.item:FindByID(tbl.uniqueID).category == 'Оружие' && tbl.quality != nil then
            local text, col = pnl:getQuality(tbl.quality);
            draw.DrawText( 'Качество: '..text, "DermaDefault", 60, 30, col, TEXT_ALIGN_LEFT )
        end;
    end;
    local iSpawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", item ));
    iSpawnIcon:SetPos(0, 0);
    iSpawnIcon:SetSize(55, 55)
    iSpawnIcon:SetModel( tbl.model, tbl.skin );
    iSpawnIcon.DisAllowedHover = true;
    iSpawnIcon.DoClick = function(self)
        cable.send('MIE', e, {tbl.uniqueID, tbl.itemID, tbl.priceSales, id, 'player'});
        self:GetParent():Remove();
        pnl.playerInv[id] = nil;
        tbl.defaultPrice = tbl.priceSales;
        tbl.priceSales = tbl.priceSales * 1.3;
        pnl.sellerInv[id] = tbl;
        if pnl.sellerInfo['allowbuy'] then
            pnl:AddItemTable(e, id, tbl)
        end;
    end;
end;

function PANEL:AddItemTable(e, id, tbl)
    local pnl = self;
    local sellerItem = vgui.Create( "DPanel" )
    sellerItem:SetSize(55, 55)
    sellerItem.Paint = function(self, w, h)
        draw.RoundedBox( 6, 0, 0, w, h, Color(0, 0, 0, 150) )
    end;
    local sellerItemicon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create( "cwSpawnIcon", sellerItem ));
    sellerItemicon:Dock(FILL);
    sellerItemicon:SetModel( tbl.model, tbl.skin );
    if Clockwork.item:FindByID(tbl.uniqueID).category == 'Оружие' && tbl.quality != nil then
        local text, col = pnl:getQuality(tbl.quality);
        sellerItemicon.SetMarkupToolTip(sellerItemicon, "Название: "..tbl.name.."\nЦена: "..tbl.priceSales..'\nКачество: '..text)
    else
        sellerItemicon.SetMarkupToolTip(sellerItemicon, "Название: "..tbl.name.."\nЦена: "..tbl.priceSales)
    end;
    sellerItemicon.DoClick = function(self)	
        local cash = Clockwork.Client:GetSharedVar("Cash");

        if cash >= tbl.priceSales then
            cable.send('MIE', e, {tbl.uniqueID, tbl.itemID, tbl.priceSales, id, 'entity'});
            pnl.gridSellerInv:RemoveItem( self:GetParent() )
            pnl.sellerInv[id] = nil;
            tbl.priceSales = tbl.defaultPrice
            tbl.defaultPrice = nil;
            pnl.playerInv[id] = tbl;
            if pnl.sellerInfo['allowsell'] then
                pnl:AddPlayerItemTable(e, id, tbl, allowed)
            end;
        end;
    end;
    self.gridSellerInv:AddItem( sellerItem )
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

vgui.Register( "RossSalesmanFleeMarket", PANEL, "DFrame" )
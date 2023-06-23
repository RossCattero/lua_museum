local PANEL = {}
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH()
local math = math;
local appr = math.Approach
local frameTime = FrameTime() * 50

function PANEL:Init()
    self:Dock(LEFT)
    self:SetWide(sw * 0.108)
    self:DockMargin(5, 5, 5, 5);

    timer.Simple(0, function()
        self:Populate();
    end)
end

function PANEL:SetInv(owner, inv)
    self.invOwner = owner;
    self.invList = inv;
end;

function PANEL:Populate()
    if !self.invList then return end;
    local inv = self.invList;

    self.Name = self:Add("DLabel")
    self.Name:SetText(self.invOwner:upper())
    self.Name:SetFont("ButtonStyle")
    self.Name:Dock(TOP)
    self.Name:SetContentAlignment(5)
    self.Name:DockMargin(5, 5, 5, 5)
    self.Name:SetTextColor(Color(255, 255, 255))

    self.itemList = self:Add("DGrid")
    self.itemList:DockMargin(5, 5, 5, 5)
    self.itemList:Dock(FILL)
    self.itemList:SetCols( 2 )
    self.itemList:SetColWide( sw * 0.052 )
    self.itemList:SetRowHeight( sh * 0.090 )

    // Создаю сетку для размещения предметов
    if table.Count(inv) > 0 then
        for k, v in pairs(inv) do
            local item = vgui.Create("ItemPanel")
            item:SetOwned(self.invOwner)
            item:SetItemTable(v)
            self.itemList:AddItem(item)
        end
    else
        self.itemList:Remove();

        self.noItems = self:Add("DLabel")
        self.noItems:SetText("NO ITEMS")
        self.noItems:SetFont("ButtonStyle")
        self.noItems:SetContentAlignment(5)
        self.noItems:CenterVertical(sh * 0.012)
        self.noItems:CenterHorizontal(sw * 0.0008)
        self.noItems:SizeToContents()
    end
end;

function PANEL:Owned(bool)
    self.owned = bool;
end;

function PANEL:Paint(w, h)
    local col = Color(0, 99, 191)
    local rdy = 
    self.owned && PLUGIN:LeftSideReady()
    || 
    !self.owned && PLUGIN:RightSideReady()

    surface.SetDrawColor(!rdy && col || Color(100, 150, 100))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end

vgui.Register( "TradeInventory", PANEL, "ModScroll" )
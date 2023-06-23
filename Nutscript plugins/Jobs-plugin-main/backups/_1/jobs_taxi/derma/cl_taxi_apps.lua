local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}
function PANEL:Init()
    self.buttonsList = self:Add('DPanel')
    self.buttonsList:Dock(FILL)
    self.buttonsList:DockMargin(sw * 0.05, sh * 0.15, sw * 0.05, sh * 0.1)
    self.buttonsList.Paint = function(s, w, h) end;

    self.ask = self.buttonsList:Add('DLabel')
    self.ask:Dock(TOP)
    self.ask:SetText("You want to: ")
    self.ask:SetFont("FontSmall")
    self.ask:SizeToContents()
    self.ask:SetContentAlignment(5)

    self.call = self.buttonsList:Add("CompButton")
    self.call:Dock(TOP)
    self.call:SetText("Call a taxi")
    self.call:SetFont("FontSmall")
    self.call:SizeToContents()
    self.call.DoClick = function(btn)
        self.buttonsList:Remove();

        self.app = self:Add("APP_taxi_call")
        self.app:Dock(FILL)
    end;

    if !LocalPlayer():IsTaxi() then return end;
    self.database = self.buttonsList:Add("CompButton")
    self.database:Dock(TOP)
    self.database:SetText("Open database")
    self.database:SetFont("FontSmall")
    self.database:SizeToContents()
    self.database.DoClick = function(btn)
        self.buttonsList:Remove();

        self.app = self:Add("APP_taxi_database")
        self.app:Dock(FILL)
    end;
end;
vgui.Register( 'APP_taxi', PANEL, 'TaxiApp' )

local PANEL = {}
function PANEL:Init()
    self.textBG = self:Add("CompScroll")
    self.textBG:Dock(TOP)
    self.textBG.Paint = function(s, w, h) end;
    self.textBG:DockMargin(sw * 0.005, 0, sw * 0.005, 0)
    
    self.rules = self.textBG:Add('DLabel')
    self.rules:Dock(FILL)
    self.rules:SetText(TAXI_DATA.rules)
    self.rules:SetFont("TaxiFontSmaller")
    self.rules:SetWrap(true)
    self.rules:SizeToContents()
    self.rules:SetAutoStretchVertical(true)

    self.textBG:SetTall(sh * 0.3)

    local percent = TAXI_DATA.price * ( math.Clamp(TAXI_DATA.fee, 0, 100) / 100)
    self.fee = self:Add('DLabel')
    self.fee:SetText("Taxi call fee: " .. math.Round(percent, 2) .. nut.currency.symbol)
    self.fee:Dock(TOP)
    self.fee:SetFont("TaxiFontBigger")
    self.fee:SizeToContents()
    self.fee:SetContentAlignment(5)
    self.fee:DockMargin(0, sh * 0.005, 0, sh * 0.005)
    self.fee:SetTextColor(Color(241, 138, 230))

    self.price = self:Add('DLabel')
    self.price:SetText("Taxi call price: " .. TAXI_DATA.price .. nut.currency.symbol)
    self.price:SetFont("TaxiFontBigger")
    self.price:Dock(TOP)
    self.price:SizeToContents()
    self.price:SetContentAlignment(5)
    self.price:DockMargin(0, sh * 0.005, 0, sh * 0.005)
    self.price:SetTextColor(Color(255, 199, 249))

    self.additional = self:Add("DPanel")
    self.additional:Dock(TOP)
    self.additional:SetTall(sh * 0.02)
    self.additional:DockMargin(0, sh * 0.005, 0, sh * 0.005)
    self.additional.Paint = function(s, w, h) end;

    self.additionalPrice = self.additional:Add('DLabel')
    self.additionalPrice:SetText("Additional payment: ")
    self.additionalPrice:SetFont("TaxiFontBigger")
    self.additionalPrice:Dock(FILL)
    self.additionalPrice:SizeToContents()
    self.additionalPrice:SetContentAlignment(6)
    self.additionalPrice:SetTextColor(Color(241, 138, 230))

    self.priceEntry = self.additional:Add("CompEntry")
    self.priceEntry:Dock(RIGHT)
    self.priceEntry:SetWidth(sw * 0.05)
    self.priceEntry:DockMargin(0, 0, sw * 0.03, 0)
    self.priceEntry:SetText("0")

    self.requestTaxi = self:Add("CompButton")
    self.requestTaxi:SetText("CALL A TAXI")
    self.requestTaxi:SetFont("TaxiFontBigger")
    self.requestTaxi:Dock(TOP)
    self.requestTaxi:SizeToContents()
    self.requestTaxi:SetContentAlignment(5)
    self.requestTaxi:DockMargin(0, sh * 0.005, 0, sh * 0.005)

    if LocalPlayer():getChar():getMoney() < TAXI_DATA.price then
        self.requestTaxi:SetDisabled(true);
    end

    self.requestTaxi.DoClick = function(btn)

        if timer.Exists("Taxi_Cooldown") then return end;

        local balance = LocalPlayer():getChar():getMoney()
        local price = TAXI_DATA.price;
        local additional = tonumber(self.priceEntry:GetText()) or 0;
            
        if balance < price + additional then
            nut.util.notify("You should have at least " .. nut.currency.get(price + additional) .. " to order a taxi!")
            return;
        end;

        if !LocalPlayer():HasTaxi() && !LocalPlayer():TaxiCalled() then
            self:HideElements()
            local uniqueID = 'TaxiCalled'
            timer.Create(uniqueID, 1, 0, function()
              if !timer.Exists(uniqueID) || LocalPlayer():HasTaxi() then TAXI_SECONDS = 0; timer.Remove(uniqueID) return; end;
              TAXI_SECONDS = TAXI_SECONDS + 1;
            end);

            netstream.Start('taxi:RequestTaxi', additional)

            timer.Create("Taxi_Cooldown", 1, 10, function() 
                local timeLeft = timer.RepsLeft("Taxi_Cooldown");
                local app = TAXI.interface.openedApp
                if app && app:IsValid() then
                    if app.app && app.app:IsValid() then
                        app.app.requestTaxi:SetText("Cooldown: "..timeLeft)
                        if timeLeft <= 0 then
                            app.app.requestTaxi:SetText("CALL A TAXI")
                        end
                    end;
                end
            end)
        end
    end;

    if LocalPlayer():HasTaxi() || (!LocalPlayer():HasTaxi() && !LocalPlayer():CanCallTaxi()) then
        self:HideElements(true)
        return;
    end
    if LocalPlayer():TaxiCalled() then
        self:HideElements(false)
    end;
end;

function PANEL:HideElements(fortaxi)
    local childs = self:GetCanvas():GetChildren();
    local i = #childs;
    while (i > 0) do
        childs[i]:SetVisible(false);
        i = i - 1;
    end;

    self.taxiScreen = self:Add("DPanel")
    self.taxiScreen:Dock(TOP);
    self.taxiScreen:PaintLess()
    self.taxiScreen:SetTall(sh * 0.4)
    
    if !LocalPlayer():CanCallTaxi() then
        self.lbl = self.taxiScreen:Add("CLabel")
        self.lbl:Dock(TOP)
        self.lbl:SetText("You need to wait until your driver arrives.")
        self.lbl:SetContentAlignment(5)
        self.lbl:SizeToContents()
        self.lbl:DockMargin(0, sh * 0.2, 0, 0)

        self.dec = self.taxiScreen:Add("CompButton")
        self.dec:SetText("Decline drive")
        self.dec:SetFont("TaxiFontBigger")
        self.dec:Dock(TOP)
        self.dec:SizeToContents()
        self.dec:SetContentAlignment(5)

        self.dec.DoClick = function(btn)
            netstream.Start('taxi::DeclineDriveCustomer')
        end;

        return;
    end

    self.lbl = self.taxiScreen:Add("CLabel")
    self.lbl:Dock(TOP)
    self.lbl:SetText(fortaxi && "You can't order a taxi now" || "Searching...")
    self.lbl:SetContentAlignment(5)
    self.lbl:SizeToContents()
    self.lbl:DockMargin(0, sh * 0.2, 0, 0)

    if fortaxi then 
        return 
    end;
    self.taxiInfo = self.taxiScreen:Add("CLabel")
    self.taxiInfo:Dock(TOP)
    self.taxiInfo:SetText(RFormatTime(TAXI_SECONDS))
    self.taxiInfo:SetContentAlignment(5)
    self.taxiInfo:SizeToContents()

    self.stopSearching = self.taxiScreen:Add("CompButton")
    self.stopSearching:SetText("Stop searching")
    self.stopSearching:SetFont("TaxiFontBigger")
    self.stopSearching:Dock(TOP)
    self.stopSearching:SizeToContents()
    self.stopSearching:SetContentAlignment(5)

    self.stopSearching.DoClick = function(btn)
        if LocalPlayer():TaxiCalled() then
            self:ShowElements()
            LocalPlayer():StopTaxiSearch()
            netstream.Start('taxi:RemoveTaxiOrder')
        end;
    end;

    local uniqueID = '_ChangeInfoTime'
    timer.Create(uniqueID, 1, 0, function()
      if !timer.Exists(uniqueID) || !self.taxiInfo then timer.Remove(uniqueID) return; end;
      if self.taxiInfo && self.taxiInfo:IsValid() then
          self.taxiInfo:SetText(RFormatTime(TAXI_SECONDS))
      end
    end);
end;

function PANEL:ShowElements()
    if self.taxiScreen then
      self.taxiScreen:Remove();
    end
    local childs = self:GetCanvas():GetChildren();
    local i = #childs;
    while (i > 0) do
        childs[i]:SetVisible(true);
        i = i - 1;
    end;
end;

vgui.Register( 'APP_taxi_call', PANEL, 'CompScroll' )
local PANEL = {}
function PANEL:Init()
    self:Dock(FILL)
    self.tasksList = self:Add("CompScroll")
    self.tasksList:Dock(FILL)
    self.tasksList:DockMargin(sw * 0.005, sh * 0.005, sw * 0.005, sh * 0.005)

    if LocalPlayer():GotCustomer() then
        self:SetOrderData()
        return;
    end

    self:ReloadOrders()
end;

function PANEL:SetOrderData()
    self.tasksList:Dock(TOP)
    self.tasksList:SetTall(sh * 0.1);
    self.tasksList:PaintLess()
    self.tasksList:DockMargin(0, sh * 0.15, 0, 0)

    self.name = self.tasksList:Add("DLabel")
    self.name:Dock(TOP)
    self.name:SetText(TAXI.orders.name);
    self.name:SetFont("TaxiFontBigger")
    self.name:SetContentAlignment(5)
    self.name:SizeToContents()

    self.price = self.tasksList:Add("DLabel")
    self.price:Dock(TOP)
    self.price:SetText(TAXI.orders.price .. nut.currency.symbol);
    self.price:SetFont("TaxiFontBigger")
    self.price:SetContentAlignment(5)
    self.price:SizeToContents()

    self.distance = self.tasksList:Add("DLabel")
    self.distance:Dock(TOP)
    self.distance:SetText(
        MetricSystem(
            LocalPlayer():GetPos(), 
            TAXI.orders.position
        )
    );
    self.distance:SetFont("TaxiFontBigger")
    self.distance:SetContentAlignment(5)
    self.distance:SizeToContents()

    self.dec = self.tasksList:Add("CompButton")
    self.dec:SetText("Decline this order")
    self.dec:SetFont("TaxiFontBigger")
    self.dec:Dock(TOP)
    self.dec:SizeToContents()
    self.dec:SetContentAlignment(5)

    self.dec.DoClick = function(btn)
        netstream.Start('taxi::AcceptCall');
    end;
end;

function PANEL:ReloadOrders()
    self.tasksList:Clear()

    local orders = TAXI.orders
    local i = #orders;

    if self.appScreen then self.appScreen:Remove() end;
    
    if i == 0 then
        if self.tasksList then 
            self.tasksList:SetVisible(false) 
        end;
        self.appScreen = self:Add("DPanel")
        self.appScreen:Dock(TOP);
        self.appScreen:PaintLess()
        self.appScreen:SetTall(sh * 0.4)

        self.lbl = self.appScreen:Add("CLabel")
        self.lbl:Dock(TOP)
        self.lbl:SetText("No available taxi orders")
        self.lbl:SetContentAlignment(5)
        self.lbl:SizeToContents()
        self.lbl:DockMargin(0, sh * 0.2, 0, 0)
        return;
    end

    self.tasksList:SetVisible(true)
    
    while (i > 0) do
        local data = orders[i];

        if !data.taken then
            local task = self.tasksList:Add("TDB_member")
            task:SetTaxiData(data)
        end;

        i = i - 1;
    end;
end;

vgui.Register( 'APP_taxi_database', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
    self:Dock(TOP);
    self:SetTall(sh * 0.025)

    self:SetMouseInputEnabled( true )
    self:SetCursor("hand")

    self:InitHover(Color(0, 0, 0, 150), Color(70, 70, 70, 150), 0.5)
end;

function PANEL:SetTaxiData(data)
    self.data = data;

    self:LoadLabels();
end;

function PANEL:LoadLabels()
    local data = self.data;

    self.name = self:Add("DLabel")
    self.name:Dock(LEFT)
    self.name:SetText(data.name .. " |");
    self.name:SetFont("TaxiFontSmaller")
    self.name:SizeToContents()
    self.name:DockMargin(sw * 0.005, 0, 0, 0)

    local price = tostring(data.price)
    price = price:Replace(".", " , ")

    self.price = self:Add("DLabel")
    self.price:Dock(LEFT)
    self.price:SetText(price .. nut.currency.symbol .. " |");
    self.price:SetFont("TaxiFontSmaller")
    self.price:SizeToContents()
    self.price:DockMargin(sw * 0.002, 0, 0, 0)

    self.distance = self:Add("DLabel")
    self.distance:Dock(LEFT)
    self.distance:SetText(MetricSystem(LocalPlayer():GetPos(), data.position));
    self.distance:SetFont("TaxiFontSmaller")
    self.distance:SizeToContents()
    self.distance:DockMargin(sw * 0.002, 0, 0, 0)
end;
function PANEL:OnMousePressed()
    netstream.Start('taxi::AcceptCall', self.data.id);
end
vgui.Register( 'TDB_member', PANEL, 'EditablePanel' )

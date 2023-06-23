local PLUGIN = PLUGIN;
local PANEL = {}

function PANEL:Init()
    self:Dock(FILL)
    self:DockMargin(5, 5, 5, 5)
end

function PANEL:ADDColumn(str, pos)
    local column = self:AddColumn(str, pos)
    column.Header:SetTextColor(Color(255, 255, 0))
    column.Header:SetFont("Banking info smaller")
    column.Header.id = column:GetColumnID()
    column.Header.Paint = function(s, w, h)  end;

    return column;
end;

function PANEL:ADDLine(...)
    local line = self:AddLine(...)  
    line:SetSelectable(false)  
    line.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
        end
    end;
    line.OnMousePressed = function(btn) 
            local data = pon.decode(PLUGIN.accsList[btn.id])
            local menu = DermaMenu() 
            if data && data.loan == 0 then
                local loan = menu:AddOption( "Set loan (amount)", function() 
                    Derma_StringRequest("SET the amount of loan to individual", "Type loan amount", "", 
                    function(value) 
                        if tonumber(value) then
                            if PLUGIN.fund - value < 0 then
                                Derma_Message( "Bank don't have enough funds for this loan!", "The bank", "Ok" )
							    return;
					        end
                            netstream.Start('bank::bankAction', "loan", btn.id, value)
                            data.loan =  math.Round(value + (value * data.interest/100))
                            data.money = data.money + value;
					        data.startloan = data.loan;
                            data.bankeer = LocalPlayer():Name()
                            PLUGIN.accsList[btn.id] = pon.encode(data)
                            
                            PLUGIN.fund = math.Round( PLUGIN.fund - value )
                            PLUGIN.dbOpened.Database:Refresh(PLUGIN.accsList)
                        end;
                    end)
                end)
                loan:SetIcon("icon16/script_go.png")
            else
                local remLoan = menu:AddOption( "Remove loan (amount)", function() 
                    Derma_StringRequest("Remove loan (amount)", "Remove the amount of loan", "", 
                    function(value) 
                        if tonumber(value) then
                            netstream.Start('bank::bankAction', "removeLoan", btn.id, value)
                            data.loan = math.max(data.loan - value, 0)
                            if data.loan == 0 then
						        data.startloan = 0;
                                data.bankeer = "NONE"
					        end
                            PLUGIN.accsList[btn.id] = pon.encode(data)
                            PLUGIN.dbOpened.Database:Refresh(PLUGIN.accsList)
                        end;
                    end)
                end)
                remLoan:SetIcon("icon16/script_delete.png")
            end;

            local interest = menu:AddOption( "Set loan interest", function() 
                Derma_StringRequest("Set interest", "Type interest percent", data && data.interest || "1", 
                function(value) 
                    if tonumber(value) then
                        netstream.Start('bank::bankAction', "interest", btn.id, value)
                        data.interest = value
                        PLUGIN.accsList[btn.id] = pon.encode(data)

                        PLUGIN.dbOpened.Database:Refresh(PLUGIN.accsList)
                    end;
                end)
            end)
            interest:SetIcon("icon16/lightning.png")
            
            local openItemBank = menu:AddOption( "Show items bank", function()  
                netstream.Start('bank::bankAction', "openInventory", btn.id, value)
            end)            
            openItemBank:SetIcon( "icon16/folder_page_white.png" )

            local remAcc = menu:AddOption( "Remove account", function()  
                Derma_Query("Are you sure?", "Confirm action", 
                "Yes", function() 
                    netstream.Start('bank::bankAction', "removeAcc", btn.id, value)
                    PLUGIN.accsList[btn.id] = nil;

                    PLUGIN.dbOpened.Database:Refresh(PLUGIN.accsList)
                end, 
                "No", function() 
                end)
            end)            
            remAcc:SetIcon( "icon16/error.png" )
        menu:Open()
    end;
    for k, v in pairs(line.Columns) do
        v:SetTextColor(Color(0, 255, 255))
        v:SetContentAlignment(5)
        v:SetFont("Banking info smaller")
        v.Paint = function(s, w, h)
            if line:IsHovered() then
                s:SetTextColor(Color(0, 0, 0))
            else
                s:SetTextColor(Color(0, 255, 255))
            end
        end;
    end

    return line
end;

function PANEL:Refresh(massive)
    if PLUGIN.dbOpened && PLUGIN.dbOpened:IsValid() then
        PLUGIN.dbOpened.GeneralFund:SetText("General fund: " .. PLUGIN.fund .. nut.currency.symbol)
    end;
    self:Clear()
    
    for k, v in pairs(massive) do
        v = pon.decode(v)
		local line = self:ADDLine(
            v.name, 
            k, 
            v.money .. nut.currency.symbol, 
            v.startloan .. nut.currency.symbol, 
            v.bankeer, 
            v.loan .. nut.currency.symbol, 
            v.interest .. "%"
        )
        line.id = k;
	end
end;

function PANEL:Paint( w, h ) 
    surface.SetDrawColor(Color(0, 255, 255))
	surface.DrawLine(0, h-0.1, w, h-0.1)      
end;

vgui.Register( "DatabaseList", PANEL, "DListView" )
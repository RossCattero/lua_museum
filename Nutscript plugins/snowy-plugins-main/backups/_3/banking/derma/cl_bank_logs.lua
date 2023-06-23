local PANEL = {}
local PLUGIN = PLUGIN;

function PANEL:Init()
		self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(900, 500, 0.27, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
		local sw, sh = ScrW(), ScrH()
		self.SubPanel = self:Add("Panel")
		self.SubPanel:Dock(FILL)
		self.SubPanel:DockMargin(4, 4, 4, 4)
		self.SubPanel.Paint = function(s, w, h)
			surface.SetDrawColor(Color(0, 255, 255))
    		surface.DrawOutlinedRect( 0, 0, w, h, 2 )
		end;

		self.Logs = self.SubPanel:Add("BankingLogs")
		self.Logs:Dock(FILL)
		self.Logs:ADDColumn( "Action" )
		self.Logs:ADDColumn( "Who did this" )
		self.Logs:ADDColumn( "Time" )

        local maxOnPage = 23;
        local currentPage = 1;
        local pagesAmount = math.ceil(#BankingLogs/maxOnPage)

        self:ShowPageData(maxOnPage, currentPage, pagesAmount)

		self.CloseBG = self.SubPanel:Add("Panel")
		self.CloseBG:Dock(TOP)
		self.CloseBG:DockMargin(0, 7, 7, 0)

		self.CloseButton = self.CloseBG:Add("MButt")
		self.CloseButton:Dock(RIGHT)
		self.CloseButton:SetWide(sw * 0.02)
		self.CloseButton:SetText("X")
		self.CloseButton.Paint = function(s, w, h)
			if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
			end;
		end;
		self.CloseButton.DoClick = function(btn)
            self:Close()
		end;

        self.PagesBG = self.SubPanel:Add("Panel")
		self.PagesBG:Dock(BOTTOM)
		self.PagesBG:DockMargin(0, 7, 7, 0)

        self.pLBL = self.PagesBG:Add("DLabel")
		self.pLBL:SetTextColor(Color(0, 255, 255))
		self.pLBL:Dock(LEFT)
		self.pLBL:SetFont("Banking info smaller")
		self.pLBL:SetText("Page: " .. currentPage .. " / " .. pagesAmount)
		self.pLBL:DockMargin(sw * 0.01, 0, 0, sh * 0.01)     
        self.pLBL:SizeToContents()

        self.nextPage = self.PagesBG:Add("MButt")
        self.nextPage:Dock(RIGHT)
        self.nextPage:SetText("Next page")  
        self.nextPage:SizeToContents()
        self.nextPage:SetWide(sw * 0.05)
		self.nextPage:DockMargin(sw * 0.01, 0, 0, sh * 0.01)
        self.nextPage.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
		end;

        self.nextPage.DoClick = function(btn)
            if pagesAmount == 1 then return end;

            currentPage = currentPage + 1;
            if currentPage > pagesAmount then
                currentPage = 1;
            end
            
            self:ShowPageData(maxOnPage, currentPage, pagesAmount)

            self.pLBL:SetText("Page: " .. currentPage .. " / " .. pagesAmount)
        end;

        self.prevPage = self.PagesBG:Add("MButt")
        self.prevPage:Dock(RIGHT)
        self.prevPage:SetText("Previous page")      
		self.prevPage:DockMargin(sw * 0.01, 0, 0, sh * 0.01)    
        self.prevPage:SizeToContents()
        self.prevPage:SetWide(sw * 0.05)
        self.prevPage.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 128, 128))
		end;

        self.prevPage.DoClick = function(btn)
            if pagesAmount == 1 then return end;

            currentPage = currentPage - 1;
            if currentPage <= 0 then
                currentPage = pagesAmount;
            end
            
            self:ShowPageData(maxOnPage, currentPage, pagesAmount)

            self.pLBL:SetText("Page: " .. currentPage .. " / " .. pagesAmount)
        end;
        
        if pagesAmount == 1 then
            self.prevPage:SetAlpha(100);
            self.prevPage:SetDisabled(true);
            self.nextPage:SetAlpha(100);
            self.nextPage:SetDisabled(true);
        end;
end

function PANEL:ShowPageData(max, current, pageAmount)
    self.Logs:Clear()
    local FirstPage = current == 1;
    local i = FirstPage && 1 || (current - 1) * max;
    local endOn = FirstPage && max * current || math.min(max * current, #BankingLogs)

    while (i <= endOn) do
        local _log = BankingLogs[i];
        
        if _log && isstring(_log) then
            local info = pon.decode(_log);

            local log = self.Logs:ADDLine(info.text, info.whoIs, info.date)
            log.priority = (info.priority == 1 && Color(255, 0, 255)) ||
            (info.priority == 2 && Color(0, 255, 0)) ||
            Color(0, 255, 255)

            local j = 1;
            while (j <= #log.Columns) do
                local column = log.Columns[j];
                column:SetTextColor(
                    log.priority
                )
                column:SetContentAlignment(5)
                column:SetFont("Banking info smaller")
                column.Paint = function(s, w, h)
                    if log:IsHovered() then
                        s:SetTextColor(Color(0, 0, 0))
                    else
                        s:SetTextColor(log.priority)
                    end
                end;
                j = j + 1;
            end
        end;

        i = i + 1;
        if i % max == 0 then
            break;
        end
    end
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	surface.SetDrawColor(Color(0, 0, 128))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 255, 255))
    surface.DrawOutlinedRect( 0, 0, w, h, 2 )
end;

vgui.Register( "Banking_logs", PANEL, "EditablePanel" )

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
    column.Header.Paint = function(s, w, h) 
        surface.SetDrawColor(Color(255, 255, 10))
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end;

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

    return line
end;


function PANEL:Paint( w, h ) 
    surface.SetDrawColor(Color(0, 255, 255))
	surface.DrawLine(0, h-0.1, w, h-0.1)      
end;

vgui.Register( "BankingLogs", PANEL, "DListView" )
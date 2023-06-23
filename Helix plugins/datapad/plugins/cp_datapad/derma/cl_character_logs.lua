--[[
    Logs display list;
]]

local PANEL = {}

function PANEL:Init()
    self.page = 1;
    self.pages = {
        [self.page] = {min = 1, max = 2}
    }

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:SetText("LOGS")
    self.title:SetFont("Datapad_data_text")
    self.title:SetTall(25)

    self.content = self:Add("Panel")
    self.content:Dock(FILL)
    self.content.OnSizeChanged = function()
        self:ShowLogs()
    end;

    self.buttons = self:Add("Panel")
    self.buttons:Dock(BOTTOM)
    self.buttons:SetTall(25)

    self.left = self.buttons:Add("DButton")
    self.left:Dock(LEFT)
    self.left:SetText("<")
    self.left.Paint = nil;
    self.left.DoClick = function()
        self:SetPage(self.page - 1)
        self:ShowLogs( self:GetPage() and self:GetPage().min )
    end;

    self.pg = self.buttons:Add("DLabel")
    self.pg:Dock(FILL)
    self.pg:SetFont("Datapad_data_text")
    self.pg:SetText(self.page)
    self.pg:SetContentAlignment(5)

    self.right = self.buttons:Add("DButton")
    self.right:Dock(RIGHT)
    self.right:SetText(">")
    self.right.Paint = nil;
    self.right.DoClick = function()
        self:SetPage(self.page + 1)
        self:ShowLogs( self:GetPage() and self:GetPage().max )
    end;
end

function PANEL:GetPage()
    return self.pages[self.page]
end;

function PANEL:SetPage(page)
    if page < 1 then return end;

    self.page = page;
    self.pg:SetText(self.page)
end;

function PANEL:ShowLogs(index)
    self.content:Clear()
    
    if not index then
        index = 1;
        self:SetPage(1)
    end;

    local totalHeight = 0;

    for i = index, #ix.archive.logs.list do
        local log = ix.archive.logs.list[i]
        if log then
            
            local _log = self.content:Add("DLabel")
            log = ix.util.WrapText(log, self.content:GetWide(), "Datapad_log_text");
            log = table.concat(log, "\n")
            _log:Dock(TOP)
            _log:SetFont("Datapad_log_text")
            _log:SetText(log)
            _log:SetContentAlignment(4)
            _log:SizeToContents()
            _log:SetWrap(true)

            totalHeight = totalHeight + _log:GetTall()

            if totalHeight > self.content:GetTall() then
                self.pages[self.page + 1] = {min = self:GetPage().max, max = i}
                _log:Remove()
                return;
            end;
        else
            return;
        end;
    end;
end;

vgui.Register("Datapad_logs", PANEL, "EditablePanel")
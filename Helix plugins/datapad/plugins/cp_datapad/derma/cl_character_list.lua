--[[
    Archive character data list;
]]

local PANEL = {}

function PANEL:Init()
    -- Characters list height;
    local char_list_height = 800

    -- Character info margin;
    local character_info_margin = 10;

    -- Character record info height;
    local character_info_height = 24 + character_info_margin

    -- Records per page
    self.per_page = math.floor(char_list_height/character_info_height)

    -- Page number
    self.page = 1

    -- Total page amount
    self.page_total = #ix.archive.instances <= self.per_page and 1 or math.ceil(#ix.archive.instances/self.per_page)

    -- Buffer page for filter;
    self.newDisplay = {}

    self.filter = self:Add("DPanel")
    self.filter:Dock(TOP)
    self.filter.Paint = function(s, w, h)
        surface.SetDrawColor(ix.datapad.colors.border)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end;

    self.label = self.filter:Add("DLabel")
    self.label:SetText("Search:")
    self.label:Dock(TOP)
    self.label:DockMargin(10, 5, 5, 0)
    self.label:SetFont("Datapad_filter_text")

    self.name = self.filter:Add("DTextEntry")
	self.name:Dock(TOP)
    self.name:SizeToContents()
    self.name:SetFont("Datapad_filter_text")
    self.name:DockMargin(10, 5, 5, 0)
    self.name:SetPlaceholderText("Name...")
    self.name:SetUpdateOnType(true)
    self.name.Paint = function(s, w, h)
        s:DrawTextEntryText(ix.datapad.colors.text, Color(100, 100, 255, 150), Color(255, 255, 255))

        if s:GetPlaceholderText() and s:GetText():len() < 1 then
            draw.SimpleText(s:GetPlaceholderText(), s:GetFont(), 3, h * 0.5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end;
    end;
    self.name.OnChange = function(entry)
        local filter = entry:GetText();
        self.newDisplay = {}

        if filter:len() > 0 then
            for index, character in pairs(ix.archive.instances) do
                if string.find(character.name, filter) and not table.HasValue(self.newDisplay, character) then
                    table.insert(self.newDisplay, character)
                end;
            end
            self.page = 1;
            self:EnlistData(self.page, self.newDisplay)
        else
            self.newDisplay = nil;
            self.page = 1;
            self:EnlistData(self.page)
        end;
    end;
    
    self.filter:InvalidateLayout( true )
	self.filter:SizeToChildren( false, true )
    self.filter:SetHeight(self.filter:GetTall() + 15)

    self.character_list = self:Add("Panel")
    -- Making it top instead of FILL to force constant height if possible
    self.character_list:Dock(TOP)
    self.character_list:SetTall(char_list_height)
    self.character_list.Paint = function(s, w, h)
        surface.SetDrawColor(ix.datapad.colors.border)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end;

    self.pagination = self:Add("Panel")
    self.pagination:Dock(FILL)
    self.pagination.Paint = function(s, w, h)
        surface.SetDrawColor(ix.datapad.colors.border)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end;

    local buttonPress = function(button)
        if not button:IsEnabled() then
            return;
        end;
        
        if button.type == "right" then
            self:ChangePage(1)
        elseif button.type == "left" then
            self:ChangePage(-1)
        end;

        surface.PlaySound("buttons/button16.wav")
    end;

    local buttonPaint = function(s, w, h)
        if not s:IsEnabled() then
            s:SetTextColor(ix.datapad.colors.disabled_text)
            s:SetCursor("arrow")
        else
            s:SetCursor("hand")
            s:SetTextColor(ix.datapad.colors.text)
        end;
    end;

    self.pageLeft = self.pagination:Add("DLabel")
    self.pageLeft.type = "left"
    self.pageLeft:Dock(LEFT)
    self.pageLeft:SetWide(75)
    self.pageLeft:SetText("<")
    self.pageLeft:SetContentAlignment(5)
    self.pageLeft:SetFont("Datapad_names_text")
    self.pageLeft:SetMouseInputEnabled(true)
    self.pageLeft.PaintOver = buttonPaint
    self.pageLeft.OnMousePressed = buttonPress;

    self.pageNumber = self.pagination:Add("DLabel")
    self.pageNumber:Dock(FILL)
    self.pageNumber:SetContentAlignment(5)
    self.pageNumber:SetText(Format("%s / %s", self.page, self.page_total))
    self.pageNumber:SetFont("Datapad_names_text")

    self.pageRight = self.pagination:Add("DLabel")
    self.pageRight.type = "right"
    self.pageRight:Dock(RIGHT)
    self.pageRight:SetWide(75)
    self.pageRight:SetText(">")
    self.pageRight:SetContentAlignment(5)
    self.pageRight:SetFont("Datapad_names_text")
    self.pageRight:SetMouseInputEnabled(true)
    self.pageRight.PaintOver = buttonPaint
    self.pageRight.OnMousePressed = buttonPress;

    -- if it's 1/1 then just disable buttons;
    if self.page == self.page_total then
        self.pageLeft:SetEnabled(false)
        self.pageRight:SetEnabled(false)
    end;

    self:EnlistData(self.page)
end;

function PANEL:ChangePage(number)
    if self.page + number <= 0 then
        self.page = self.page_total
    elseif self.page + number  > self.page_total then
        self.page = 1
    else
        self.page = self.page + number;
    end;

    self:EnlistData(self.page, self.newDisplay)

    self.pageNumber:SetText(Format("%s / %s", self.page, self.page_total))
end;

--- Enlist all data for page
---@param page number (page number)
---@param list table|nil (specific data to display)
function PANEL:EnlistData(page, list)
    if not list then
        list = ix.archive.instances;
    end;

    self.character_list:Clear()

    for i = page > 1 and (self.per_page * (page - 1) + 1) or 1, page * self.per_page do
        local data = list[i];
        if not data then
            return;
        end;
        if data then
            local character = self.character_list:Add("Datapad_info")
            character:SetData(data)
        end;
    end;
end;

vgui.Register("Datapad_character_list", PANEL, "EditablePanel")
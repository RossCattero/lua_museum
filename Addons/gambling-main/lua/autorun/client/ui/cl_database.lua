--[[
    Coinflip database;
]]

local PANEL = {}

function PANEL:Init()
    self.lines = {}
    self.columns = {}
    self.columnSorted = NULL;

    self.columns_list = self:Add("Panel")
    self.columns_list:Dock(TOP)
    self.columns_list:SetTall(35)
    self.columns_list.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(52, 52, 52))
    end;

    self.lines_list = self:Add("Gambling__scroll")
    self.lines_list:Dock(FILL)
    self.lines_list:GetCanvas():DockPadding(15, 10, 12, 10)

    self.add_button = self:Add("DButton")
    -- Position is on function 'OnSizeChanged' on the end of the file;
    self.add_button:SetSize(50, 50)
    self.add_button:SetText("")
    self.add_button.Paint = function(s, w, h)
        draw.NoTexture()

        -- Circle;
        draw.Arc(w/2, h/2, 25, 25, 0, 360, 3, Gambling.colors.button_clr)

        -- Cross;
        draw.RoundedBox(0, w/2-3, h/2-10, 5, 20, color_white)
        draw.RoundedBox(0, w/2-10, h/2-3, 20, 5, color_white)
    end;

    self.add_button.DoClick = function(s, w, h)
        -- $ callback for green cross button;

        if self.info_panel and IsValid(self.info_panel) then 
            self.info_panel:Remove() 
        end;

        self.info_panel = vgui.Create("Gambling__bet_menu")
    end;
end;

--- Sort column;
---@param column userdata (Column panel)
function PANEL:Sort( column )
    column:SetText("▼" .. column.title)
    self.columnSorted = column;

    table.sort( self.lines, column.sort )

    self.lines_list:Clear()

    local subLines = table.Copy(self.lines)
    self.lines = {};

    for k, v in pairs(subLines) do
        local line = self:AddLine( unpack(v:GetChildren()) )
        line:SetStartIndex(v.start_index)
    end;
end;

--- Sort column by its index
---@param index number
function PANEL:SortByColumn( index )
    -- Search for column;
    local column = self.columns[ index ]

    -- If self.columnSorted contains sorted column - change it's sort indicator to stock title;
    if IsValid(self.columnSorted) then
        self.columnSorted:SetText(self.columnSorted.title)
    end;

    -- If self.columnSorted == column to find, then just reverse the column sort result to default
    if column == self.columnSorted then
        self.columnSorted = NULL;

        table.sort(self.lines, function(panel1, panel2)
            return panel1.start_index > panel2.start_index
        end)

        self.lines_list:Clear()
    
        local subLines = table.Copy(self.lines)
        self.lines = {};
    
        for k, v in pairs(subLines) do
            local line = self:AddLine( unpack(v:GetChildren()) )
            line:SetStartIndex(v.start_index)
        end;
        return;
    end;

    -- If column is found - then just change the title and store the column;
    if column and column.sort then
        self:Sort( column )
    end;
end;

--- Add column to the column list;
---@param column_title string
---@param fixedWidth number|nil
function PANEL:AddColumn( column_title, fixedWidth )

    -- Create the column itself
    local column = self.columns_list:Add("Gambling__database_column")
    column:Dock(LEFT)
    column:DockMargin(8, 0, 0, 0)
    column:SetTitle( column_title )
    
    -- Fixed width to allow columns be more flexible;
    column:SetFixedWidth(fixedWidth)

    column:SetIndex(#self.columns + 1)

    column.DoClick = function(column)
        -- $ callback on column click
        self:SortByColumn( column:GetIndex() )
    end;

    -- Add it to the column list;
    self.columns[column:GetIndex()] = column

    return column
end;

--- Add line. 
-- To add line, create any vgui elements and pass them as arguments.
--[[
    Example:

    local player_background = vgui.Create("Panel")
    player_background:SetTall(50)
    player_background:DockPadding(10, 0, 5, 0)

    self.database:AddLine(player_background)

    -- This code will add one column and the line to the top of the list;
    -- All columns in the line set their tallness to the most tall child;
]]
function PANEL:AddLine( ... )
    local data = {...}

    -- Create the line background;
    local line = self.lines_list:Add("Gambling__database_line")
    line:Dock(TOP)
    line:DockPadding(0, 10, 10, 10)
    line:DockMargin(0, 5, 0, 0)

    -- Insert line link to the line list;
    local index = #self.lines + 1
    self.lines[index] = line;

    -- Add the line content to the actual column line;
    line:AddContent( {...}, self.columns )

    -- Check it by even to dynamically change color;
    line:SetEven(index % 2 == 0)
    line:SetStartIndex(index)

    return line;
end;

function PANEL:OnSizeChanged(newW, newH)
    local len = newW / #self.columns

    for k, column in ipairs(self.columns) do
        if next(self.columns, k) == nil then
            column:Dock(FILL)
        else
            column:SetWide(column.fixedWidth or len)
        end;
    end;

    self.add_button:SetPos(newW-75, newH-65)
end;

function PANEL:Paint(w, h)
    draw.RoundedBox( 0, 0, 0, w, h, Color(46, 46, 46) )
end;

vgui.Register("Gambling__database", PANEL, "EditablePanel")
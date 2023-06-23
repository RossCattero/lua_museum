local PANEL = {}

AccessorFunc(PANEL, "fixedWidth", "FixedWidth", FORCE_INT)
AccessorFunc(PANEL, "title", "ColumnTitle", FORCE_STRING)
AccessorFunc(PANEL, "index", "Index", FORCE_INT)

function PANEL:Init()
    self:SetContentAlignment(5)
    self:SetText("")
    self:SetFont("Gambling_6")
    self:SetTextColor(color_white)

    self:SetCursor("cursor")
    self:SetMouseInputEnabled(false)
end;

--- Set the first-time text title for column
---@param column_title string
function PANEL:SetTitle( column_title )
    self:SetText(column_title)

    self:SetColumnTitle(column_title)
end;

--- Add the DoClick function for this pseudo-button on your code for callback;
---@param keyCode number
function PANEL:OnMousePressed(keyCode)
    if keyCode ~= MOUSE_LEFT then
        return;
    end;

    if self.DoClick then
        self:DoClick()
    end;
end;

--- Set the sort function for this column
---@param funcSort function
function PANEL:SetSortFunc(funcSort)
    self.sort = funcSort;

    self:SetCursor("hand")
    self:SetMouseInputEnabled(true)
end;

vgui.Register("Gambling__database_column", PANEL, "DLabel")
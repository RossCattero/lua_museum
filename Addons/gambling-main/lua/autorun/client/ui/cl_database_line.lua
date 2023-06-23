
local PANEL = {}
AccessorFunc(PANEL, "even", "Even")
AccessorFunc(PANEL, "start_index", "StartIndex")

function PANEL:Init()
    self.content_list = {}
end;

--- Add content to the line
---@param contentTable table (Table of vgui content)
---@param columns table (Columns for inheriting wideness from parent column)
function PANEL:AddContent( contentTable, columns )
    for index, panel in ipairs(contentTable) do
        self.content_list[index] = self:Add( panel )
        self.content_list[index]:SetWide( columns[index]:GetWide() )
        self.content_list[index]:Dock(LEFT)
    end;

    self:SizeToChildren(false, true)
    self:InvalidateLayout()
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self:GetEven() and Color(59, 59, 59) or Color(65, 65, 65))
end;

vgui.Register("Gambling__database_line", PANEL, "EditablePanel")
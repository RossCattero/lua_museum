--[[
    Live feed on the right of the chart;
]]

local PANEL = {}

function PANEL:Init()
    self.content_list = {}

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:SetTall(50)
    self.title:SetText("Live Feed")
    self.title:SetContentAlignment(5)
    self.title:SetFont("Gambling_8")
    self.title:SetTextColor(color_white)
    self.title.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(52, 52, 52), true, true, false, false)
    end;

    self.content = self:Add("Panel")
    self.content:Dock(FILL)
    self.content:DockPadding(10, 10, 10, 10)
end;

--- Add feed member
---@param feed_nickname string
---@param feed_time string
---@param feed_price number|string
function PANEL:AddFeed( feed_nickname, feed_time, feed_price )
    local feed = self.content:Add("Gambling__chart_feed")
    feed:Dock(TOP)
    feed:SetTall(72)
    feed:DockPadding(5, 5, 5, 10)
    feed:DockMargin(0, 0, 0, 7)

    feed:Populate(feed_nickname, feed_time, feed_price)

    local index = #self.content_list + 1;
    self.content_list[index] = feed;

    if index % 2 == 0 then
        feed:SetEven(true)
    end;

    return feed;
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))
end;

vgui.Register("Gambling__chart_live_feed", PANEL, "EditablePanel")
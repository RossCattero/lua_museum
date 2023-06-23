--[[
    Live feed element for the live feed list on the right of the chart panel;
]]

local PANEL = {}

AccessorFunc(PANEL, "even", "Even")
AccessorFunc(PANEL, "nick", "Nickname")
AccessorFunc(PANEL, "time", "Time")
AccessorFunc(PANEL, "reward_amount", "Reward")

function PANEL:Init()
    self.nickname = self:Add("DLabel")
    self.nickname:Dock(TOP)
    self.nickname:SetTall(20)
    self.nickname:SetContentAlignment(5)
    self.nickname:SetText("#unknown nickname#")
    self.nickname:SetFont("Gambling_6")
    self.nickname:SetTextColor(color_white)
    self.nickname:SetWrap(false)

    self.reward = self:Add("DLabel")
    self.reward:Dock(TOP)
    self.reward:SetTall(20)
    self.reward:SetContentAlignment(5)
    self.reward:SetText("#unknown reason#")
    self.reward:SetFont("Gambling_4")
    self.reward:SetTextColor(Color(100, 255, 100))
    self.reward:SetWrap(false)

    self.time_ago = self:Add("DLabel")
    self.time_ago:Dock(TOP)
    self.time_ago:SetTall(20)
    self.time_ago:SetContentAlignment(5)
    self.time_ago:SetText("#unknown time ago#")
    self.time_ago:SetFont("Gambling_4")
    self.time_ago:SetTextColor(color_white)
    self.time_ago:SetWrap(false)
end;

--- Populate this feed member with needed data;
---@param name_string string
---@param time_string string
---@param reward_string string
function PANEL:Populate( name_string, time_string, reward_string )
    self:SetNickname(name_string)
    self:SetTime(time_string)
    self:SetReward(reward_string)
end;

--- Set nickname string
---@param name_string string
function PANEL:SetNickname( name_string )
    self.nick = name_string

    self.nickname:SetText(name_string)
end;

--- Set time string
---@param time_string string
function PANEL:SetTime( time_string )
    self.time = time_string

    self.time_ago:SetText(time_string .. " seconds ago")
end;

--- Set reward string
---@param reward_string string
function PANEL:SetReward( reward_string )
    self.reward_amount = reward_string

    self.reward:SetText(reward_string)
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, self.even and Color(59, 59, 59) or Color(65, 65, 65))
end;

vgui.Register("Gambling__chart_feed", PANEL, "EditablePanel")
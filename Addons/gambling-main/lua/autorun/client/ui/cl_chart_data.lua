--[[
    Bet information line under the 'bet line' with info about total bet, etc.
]]

local PANEL = {}

AccessorFunc(PANEL, "total_bet_amount", "TotalBet")
AccessorFunc(PANEL, "your_bet_amount", "YourBet")
AccessorFunc(PANEL, "your_chances_percent", "YourPercent")
AccessorFunc(PANEL, "participants_amount", "Participants")

function PANEL:Init()
    -- Common font for titles;
    local common_font = "Gambling_8"

    -- Common size for panels;
    local common_size = 155;

    -- Total bet --
    self.total_bet_bg = self:Add("Panel")
    self.total_bet_bg:Dock(LEFT)
    self.total_bet_bg:SetWide(common_size)
    self.total_bet_bg:DockMargin(0, 0, 3, 0)
    self.total_bet_bg:DockPadding(5, 10, 5, 10)
    self.total_bet_bg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(65, 65, 65))
    end;
    self.total_bet_label = self.total_bet_bg:Add("DLabel")
    self.total_bet_label:Dock(TOP)
    self.total_bet_label:SetText("Total bet")
    self.total_bet_label:SetFont(common_font)
    self.total_bet_label:SetContentAlignment(5)
    self.total_bet_label:SetTextColor(color_white)
    self.total_bet_label:SizeToContents()

    self.total_bet = self.total_bet_bg:Add("DLabel")
    self.total_bet:Dock(FILL)
    self.total_bet:SetText("0")
    self.total_bet:SetFont("Gambling_5")
    self.total_bet:SetContentAlignment(5)
    self.total_bet:SetTextColor(Color(100, 200, 100))
    self.total_bet:SizeToContents()
    ---------

    -- Your bet --
    self.your_bet_bg = self:Add("Panel")
    self.your_bet_bg:Dock(LEFT)
    self.your_bet_bg:SetWide(common_size)
    self.your_bet_bg:DockMargin(0, 0, 3, 0)
    self.your_bet_bg:DockPadding(5, 10, 5, 10)
    self.your_bet_bg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(65, 65, 65))
    end;
    self.your_bet_label = self.your_bet_bg:Add("DLabel")
    self.your_bet_label:Dock(TOP)
    self.your_bet_label:SetText("Your bet")
    self.your_bet_label:SetFont(common_font)
    self.your_bet_label:SetContentAlignment(5)
    self.your_bet_label:SetTextColor(color_white)
    self.your_bet_label:SizeToContents()

    self.your_bet = self.your_bet_bg:Add("DLabel")
    self.your_bet:Dock(FILL)
    self.your_bet:SetText("0")
    self.your_bet:SetFont("Gambling_5")
    self.your_bet:SetContentAlignment(5)
    self.your_bet:SetTextColor(Color(100, 200, 100))
    self.your_bet:SizeToContents()
    ---------

    -- Your chances, % -
    self.your_chances_bg = self:Add("Panel")
    self.your_chances_bg:Dock(LEFT)
    self.your_chances_bg:SetWide(common_size)
    self.your_chances_bg:DockMargin(0, 0, 3, 0)
    self.your_chances_bg:DockPadding(5, 10, 5, 10)
    self.your_chances_bg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(65, 65, 65))
    end;
    self.your_chances_label = self.your_chances_bg:Add("DLabel")
    self.your_chances_label:Dock(TOP)
    self.your_chances_label:SetText("Your chances")
    self.your_chances_label:SetFont(common_font)
    self.your_chances_label:SetContentAlignment(5)
    self.your_chances_label:SetTextColor(color_white)
    self.your_chances_label:SizeToContents()

    self.your_chances = self.your_chances_bg:Add("DLabel")
    self.your_chances:Dock(FILL)
    self.your_chances:SetText("0%")
    self.your_chances:SetFont("Gambling_5")
    self.your_chances:SetContentAlignment(5)
    self.your_chances:SetTextColor(color_white)
    self.your_chances:SizeToContents()
    ---------

    -- Participants amount, Players --
    self.participants_bg = self:Add("Panel")
    self.participants_bg:Dock(LEFT)
    self.participants_bg:SetWide(common_size)
    self.participants_bg:DockPadding(5, 10, 5, 10)
    self.participants_bg.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(65, 65, 65))
    end;
    self.participants_label = self.participants_bg:Add("DLabel")
    self.participants_label:Dock(TOP)
    self.participants_label:SetText("Participants")
    self.participants_label:SetFont(common_font)
    self.participants_label:SetContentAlignment(5)
    self.participants_label:SetTextColor(color_white)
    self.participants_label:SizeToContents()

    self.participants = self.participants_bg:Add("DLabel")
    self.participants:Dock(FILL)
    self.participants:SetText("0 Players")
    self.participants:SetFont("Gambling_5")
    self.participants:SetContentAlignment(5)
    self.participants:SetTextColor(color_white)
    self.participants:SizeToContents()
    ---------
end;

--- Populate the betting information with all needed data;  
---@param bet_amount number
---@param ply_bet_amount number
---@param ply_chances_percent number
---@param participants_amount number
function PANEL:Populate( bet_amount, ply_bet_amount, ply_chances_percent, participants_amount )
    self:SetTotalBet(bet_amount)
    self:SetYourBet(ply_bet_amount)
    self:SetYourPercent(ply_chances_percent)
    self:SetParticipants(participants_amount)
end;

--- Set total bet
---@param total_bet_amount number
function PANEL:SetTotalBet(total_bet_amount)
    self.total_bet_amount = total_bet_amount

    self.total_bet:SetText(total_bet_amount)
end;

--- Set your bet
---@param your_bet_amount number
function PANEL:SetYourBet(your_bet_amount)
    self.your_bet_amount = your_bet_amount

    self.your_bet:SetText(your_bet_amount)
end;

--- Set percent
---@param your_chances_percent number
function PANEL:SetYourPercent(your_chances_percent)
    self.your_chances_percent = your_chances_percent

    self.your_chances:SetText(your_chances_percent .. "%")
end;

--- Set participant players amount
---@param participants_amount number
function PANEL:SetParticipants(participants_amount)
    self.participants_amount = participants_amount

    self.participants:SetText(participants_amount .. " Players")
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))
end;

vgui.Register("Gambling__chart_data", PANEL, "EditablePanel")
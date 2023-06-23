--[[
    Bet line under the chart with entry, button and label;
]]

local PANEL = {}
AccessorFunc(PANEL, "bet", "Bet")

function PANEL:Init()
    self.chart_bet_label = self:Add("DLabel")
    self.chart_bet_label:SetText("Bet Funds")
    self.chart_bet_label:SetFont("Gambling_4_5")
    self.chart_bet_label:Dock(LEFT)
    self.chart_bet_label:SetWide(90)
    self.chart_bet_label:SetContentAlignment(5)
    self.chart_bet_label:SetTextColor(color_white)
    self.chart_bet_label.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, Color(52, 52, 52), true, false, true, false)
    end;

    self.chart_bet_div = self:Add("Panel")
    self.chart_bet_div:Dock(FILL)
    self.chart_bet_div:DockPadding(10, 7, 8, 7)

    self.chart_bet_btn = self.chart_bet_div:Add("DButton")
    self.chart_bet_btn:Dock(RIGHT)
    self.chart_bet_btn:SetText("Bet")
    self.chart_bet_btn:SetFont("Gambling_5")
    self.chart_bet_btn:SetTextColor(color_white)
    self.chart_bet_btn.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Gambling.colors.button_clr)
    end;
    self.chart_bet_btn.DoClick = function(button)
        -- $ Bet button click callback;

        -- Add functionality on press here;
    end;

    self.chart_bet_entry = self.chart_bet_div:Add("DTextEntry")
    self.chart_bet_entry:Dock(FILL)
    self.chart_bet_entry:SetNumeric(true)
    self.chart_bet_entry:SetFont("Gambling_4_5")
    self.chart_bet_entry:SetPlaceholderText("Enter your amount here...")
    self.chart_bet_entry.Paint = function(s, w, h)
        s:DrawTextEntryText(color_white, Color(255, 255, 255, 100), Color(255, 255, 255, 100))

        if s:GetPlaceholderText() and s:GetText():len() < 1 then
            draw.SimpleText(s:GetPlaceholderText(), s:GetFont(), 3, h * 0.5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end;
    end;
end;

--- Get the bet amount inputed on entry;
---@return number
function PANEL:GetBet()
    return self.chart_bet_entry:GetText()
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(45, 45, 45))
end;

vgui.Register("Gambling__chart_bet", PANEL, "EditablePanel")

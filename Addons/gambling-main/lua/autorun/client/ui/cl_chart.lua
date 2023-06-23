--[[
    Chart panel, chart tab;
]]

local PANEL = {}

AccessorFunc(PANEL, "chart_time", "ChartTime")
AccessorFunc(PANEL, "chart_stake", "ChartStake")


function PANEL:Init()
    self:SetChartStake("$0")
    self:SetChartTime(0)

    self:DockPadding(15, 15, 15, 15)

    -- Right panel with live feed
    self.right_panel = self:Add("Panel")
    self.right_panel:Dock(RIGHT)
    self.right_panel:SetWide(220)

    -- Main panel with chart
    self.main_panel = self:Add("Panel")
    self.main_panel:Dock(FILL)

    -- Live feed --
    self.live_feed = self.right_panel:Add("Gambling__chart_live_feed")
    self.live_feed:Dock(FILL)
    self.live_feed:DockMargin(20, 0, 0, 0)

    -- Default live feed member is here:
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    self.live_feed:AddFeed("Nicknamed nick", math.random(1024), "$" .. math.random(2048))
    ----

    -- Chart --
    self.main_panel.chart = self.main_panel:Add("Panel")
    self.main_panel.chart:Dock(FILL)

    -- Chart data --
    self.chart_data_bg = self.main_panel:Add("Panel")
    self.chart_data_bg:SetTall(91.5)
    self.chart_data_bg:Dock(BOTTOM)

    self.chart_data = self.chart_data_bg:Add("Gambling__chart_data")
    self.chart_data:Dock(FILL)
    self.chart_data:DockPadding(10, 10, 10, 10)
    
    -- Default for chart data is here;
    self.chart_data:Populate( "0$", "0$", 0, 0 )
    ----
    
    -- Bet --
    self.chart_bet_bg = self.main_panel:Add("Panel")
    self.chart_bet_bg:Dock(BOTTOM)
    self.chart_bet_bg:SetTall(85)
    self.chart_bet_bg:DockPadding(110, 15, 110, 20)

    self.chart_bet = self.chart_bet_bg:Add("Gambling__chart_bet")
    self.chart_bet:Dock(FILL)

    -- Default size for charts;
    local def_size = 220;

    self.main_panel.chart.Paint = function(s, w, h)
        draw.NoTexture()

        -- For arc info check cl_charts.lua lib on the client/ folder;

        -- Arc background --
        draw.Arc( 
            w/2, -- x
            h/2, -- y
            def_size, -- radius
            def_size, -- thickness
            0, -- startang
            360, -- endang
            2, -- roughness
            Color(36, 36, 36) -- color
        )

        draw.Arc( 
            w/2, -- x
            h/2, -- y
            def_size-40, -- radius
            def_size-40, -- thickness
            0, -- startang
            360, -- endang
            2, -- roughness
            Color(30, 30, 30) -- color
        )
        -- Arc background --

        -- Blue arc --
        draw.Arc( 
            w/2, -- x
            h/2, -- y
            def_size, -- radius
            def_size, -- thickness
            -35, -- startang
            90, -- endang
            2, -- roughness
            Color(68, 165, 228) -- color
        )

        draw.Arc( 
            w/2, -- x
            h/2, -- y
            def_size-40, -- radius
            def_size-40, -- thickness
            -35, -- startang.
            90, -- endang
            2, -- roughness
            Color(101, 195, 255) -- color
        )
        -- Blue arc --

        surface.SetFont("Gambling_12")
        local textW, textH = surface.GetTextSize(self:GetChartStake())
        draw.SimpleText( self:GetChartStake(), "Gambling_12", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( self:GetChartTime(), "Gambling_8", w/2, h/2 + textH + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end;
    ----

end;

--- Set the chart time and format it to 00:00:00
---@param time_number number
function PANEL:SetChartTime( time_number )
    self.chart_time = string.FormattedTime( time_number, "%02i:%02i:%02i" )
end;

vgui.Register("Gambling__chart", PANEL, "EditablePanel")

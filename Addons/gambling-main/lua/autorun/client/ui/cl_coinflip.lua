--[[
    Coinflip tab;
]]

local PANEL = {}

function PANEL:Init()
    self.database = self:Add("Gambling__database")
    self.database:Dock(FILL)
    self.database:DockMargin(15, 15, 15, 15)

    local column = self.database:AddColumn("Player")
    -- Set the sort function for your unique column;
    column:SetSortFunc(
        function(panel1, panel2)
            return panel1:GetChildren()[1].player_nickname:GetText():lower() 
                < panel2:GetChildren()[1].player_nickname:GetText():lower()
        end
    )

    local column = self.database:AddColumn("Time Created", 350)
    column:SetSortFunc(
        function(panel1, panel2)
            return panel1:GetChildren()[2].time
            < panel2:GetChildren()[2].time
        end
    )

    local column = self.database:AddColumn("Flip Amount", 150)
    column:SetSortFunc(
        function(panel1, panel2)
            return panel1:GetChildren()[3].price
            < panel2:GetChildren()[3].price
        end
    )

    self.database:AddColumn("") -- Empty button column

    -- Add all the players and placeholder data;
    -- Timer to make it on the next frame;
    timer.Simple(0, function()
        for k, v in ipairs(player.GetAll()) do

            local placeholder_price = "$" .. math.random(1, 1024)
            local placeholder_time = math.random(2403)

            -- Draw player data: 
            local player_background = vgui.Create("Panel")
            player_background:SetTall(50)
            player_background:DockPadding(10, 0, 5, 0)

            player_background.player_avatar = player_background:Add("AvatarImage")
            player_background.player_avatar:Dock(LEFT)
            player_background.player_avatar:SetWide(45)
            player_background.player_avatar:SetPlayer( v, 64 )

            player_background.player_nickname = player_background:Add("DLabel")
            player_background.player_nickname:Dock(LEFT)
            player_background.player_nickname:SetText(v:Name())
            player_background.player_nickname:DockMargin(7, 0, 0, 0)
            player_background.player_nickname:SetFont("Gambling_6")
            player_background.player_nickname:SetTextColor(color_white)
            player_background.player_nickname:SizeToContents()

            -- Draw time_created
            local time_created_background = vgui.Create("Panel")
            time_created_background.time = placeholder_time
            
            time_created_background.time_created = time_created_background:Add("DLabel")
            time_created_background.time_created:Dock(FILL)
            time_created_background.time_created:SetText(string.FormattedTime( placeholder_time, "%02i:%02i" ))
            time_created_background.time_created:SetContentAlignment(5)
            time_created_background.time_created:SetFont("Gambling_6")
            time_created_background.time_created:SetTextColor(color_white)

            -- Draw price and button
            local price_panel = vgui.Create("Panel")
            price_panel.price = placeholder_price
            price_panel:DockPadding(12, 0, 10, 0)

            price_panel.price_data = price_panel:Add("DLabel")
            price_panel.price_data:Dock(FILL)
            price_panel.price_data:SetText(placeholder_price)
            price_panel.price_data:SetContentAlignment(5)
            price_panel.price_data:SetFont("Gambling_6")
            price_panel.price_data:SetTextColor(color_white)

            -- Draw a button
            local button_panel = vgui.Create("Panel")
            button_panel:DockPadding(0, 0, 5, 0)
            
            button_panel.play_btn = button_panel:Add("DButton")
            button_panel.play_btn:SetText("Play")
            button_panel.play_btn:Dock(FILL)
            button_panel.play_btn:SetFont("Gambling_6")
            button_panel.play_btn:SetTextColor(color_white)
            button_panel.play_btn.Paint = function(s, w, h)
                draw.RoundedBox(8, 0, 0, w, h, Gambling.colors.button_clr)
            end;

            button_panel.play_btn.DoClick = function(button)
                -- $ coinflip "Play" button click;
                
                --> Do your functionality here on click;
            end;

            self.database:AddLine(player_background, time_created_background, price_panel, button_panel)

        end;
        -- Sort by first column silently;
        self.database:SortByColumn( 1 )
    end);
end;

vgui.Register("Gambling__coinflip", PANEL, "EditablePanel")
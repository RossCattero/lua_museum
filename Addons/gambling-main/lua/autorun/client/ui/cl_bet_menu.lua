--[[
    Bet menu with input bot, select combobox and submit button
]]

local PANEL = {}

function PANEL:Init()
	Gambling.Adaptate(self, 400, 200)

    self:SetFocusTopLevel( true )
    self:MakePopup()

    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);

    -- To make this menu remove if gambling ui is removed or closed
    if Gambling.ui then
        Gambling.ui.OnRemove = function(gambling_ui)
            self:Remove()
        end;
    end;

    self.header = self:Add("Panel")
    self.header:Dock(TOP)
    self.header:SetTall(40)
    self.header:DockPadding(15, 0, 0, 0)
    self.header.Paint = function(s, w, h)
        draw.RoundedBoxEx( 8, 0, 0, w, h, Color(46, 46, 46), true, true )
    end;

    self.header_label = self.header:Add("DLabel")
    self.header_label:Dock(LEFT)
    self.header_label:SetTextColor(color_white)
    self.header_label:SetFont("Gambling_8")
    self.header_label:SetText("Set your bet")
    self.header_label:SizeToContents()

    self.close_button = self.header:Add("DButton")
    self.close_button:Dock(RIGHT)
    self.close_button:SetText("")
    self.close_button:SetWide(40)
    self.close_button.Paint = function(s, w, h)
        if s:IsHovered() then
            draw.RoundedBoxEx( 8, 0, 0, w, h, Gambling.colors.cross, false, true )
        end;
        
        draw.SimpleText("⨯", "Gambling_cross_small", w/2, h/2-11, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.close_button.DoClick = function(button)
        self:Remove()
    end;

    self.body = self:Add("Panel")
    self.body:Dock(FILL)
    self.body:DockPadding(40, 0, 40, 15)

    self.choose_list = self.body:Add("DComboBox")
    self.choose_list:Dock(TOP)
    self.choose_list:SetTextColor(color_white)
    self.choose_list:SetTall(35)
    self.choose_list:SetFont("Gambling_4_5")
    self.choose_list:DockMargin(0, 5, 0, 5)
    self.choose_list.Paint = nil;
    self.choose_list.DropButton.Paint = function( panel, w, h )

        surface.SetDrawColor(color_white)
        draw.SimpleText("▼", "Gambling_4", w-10, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    self.choose_list:AddChoice("Money, $", "money", true)
    self.choose_list:AddChoice("Tokens, tk", "token")

    self.bet_entry = self.body:Add("DTextEntry")
    self.bet_entry:Dock(TOP)
    self.bet_entry:SetTall(40)
    self.bet_entry:SetNumeric(true)
    self.bet_entry:SetTextColor(color_white)
    self.bet_entry:SetFont("Gambling_4_5")
    self.bet_entry:SetPlaceholderText("Enter your amount here...")
    self.bet_entry:DockMargin(0, 5, 0, 0)
    self.bet_entry.Paint = function(s, w, h)

        s:DrawTextEntryText(color_white, Color(255, 255, 255, 100), Color(255, 255, 255, 100))

        if s:GetPlaceholderText() and s:GetText():len() < 1 then
            draw.SimpleText(s:GetPlaceholderText(), s:GetFont(), 4, h * 0.5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end;
    end;

    self.play_btn = self.body:Add("DButton")
    self.play_btn:SetText("Bet")
    self.play_btn:Dock(FILL)
    self.play_btn:SetFont("Gambling_6")
    self.play_btn:SetTextColor(color_white)
    self.play_btn:DockMargin(0, 10, 0, 0)
    self.play_btn.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Gambling.colors.button_clr)
    end;

    self.play_btn.DoClick = function(button)
        -- $ 'Bet' button click callback;
    end;
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Color(62, 62, 62))
end;

vgui.Register("Gambling__bet_menu", PANEL, "EditablePanel")
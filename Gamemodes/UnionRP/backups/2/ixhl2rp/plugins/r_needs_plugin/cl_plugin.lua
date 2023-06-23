function PLUGIN:CreateCharacterInfo( panel )
	local hunger = panel:Add("Panel")
	hunger:Dock(TOP)
    hunger:DockMargin(0, 0, 0, 8)
    hunger.Paint = function(_, w, h) 
        local h = LocalPlayer():GetLocalVar('hunger', 0);
        local tclr = {
            211,
            56,
            61
        }
        if h > 75 then
            tclr[1] = 18 
            tclr[2] = 154
            tclr[3] = 46
        elseif h > 50 then
            tclr[1] = 198 
            tclr[2] = 184
            tclr[3] = 19
        elseif h > 25 then
            tclr[1] = 203 
            tclr[2] = 115
            tclr[3] = 18
        elseif h >= 0 then
            tclr[1] = 211 
            tclr[2] = 56
            tclr[3] = 61
        end;
        surface.SetDrawColor(tclr[1], tclr[2], tclr[3], 150)
        surface.DrawRect(0, 0, w, h)
    end

    local gName = hunger:Add("DLabel")
    gName:Dock(FILL)
    gName:SetText('ГОЛОД')
	gName:SetFont("ixMenuButtonFontSmall")
    gName:SetContentAlignment( 5 )
    
    local thirst = panel:Add("Panel")
	thirst:Dock(TOP)
    thirst:DockMargin(0, 0, 0, 8)
    thirst.Paint = function(_, w, h) 
        local t = LocalPlayer():GetLocalVar('thirst', 0);
        local tclr = {
            211,
            56,
            61
        }
        if t > 75 then
            tclr[1] = 18 
            tclr[2] = 154
            tclr[3] = 46
        elseif t > 50 then
            tclr[1] = 198 
            tclr[2] = 184
            tclr[3] = 19
        elseif t > 25 then
            tclr[1] = 203 
            tclr[2] = 115
            tclr[3] = 18
        elseif t >= 0 then
            tclr[1] = 211 
            tclr[2] = 56
            tclr[3] = 61
        end;
        surface.SetDrawColor(tclr[1], tclr[2], tclr[3], 150)
        surface.DrawRect(0, 0, w, h)
    end

    local tName = thirst:Add("DLabel")
    tName:Dock(FILL)
    tName:SetText('ЖАЖДА')
	tName:SetFont("ixMenuButtonFontSmall")
    tName:SetContentAlignment( 5 )
end;
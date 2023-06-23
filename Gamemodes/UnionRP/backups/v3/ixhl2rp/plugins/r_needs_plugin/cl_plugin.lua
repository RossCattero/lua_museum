local PLUGIN = PLUGIN;

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

    local sleep = panel:Add("Panel")
	sleep:Dock(TOP)
    sleep:DockMargin(0, 0, 0, 8)
    sleep.Paint = function(_, w, h) 
        local t = LocalPlayer():GetLocalVar('sleep', 0);
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

    local sName = sleep:Add("DLabel")
    sName:Dock(FILL)
    sName:SetText('УСТАЛОСТЬ')
	sName:SetFont("ixMenuButtonFontSmall")
    sName:SetContentAlignment( 5 )
end;

function PLUGIN:PlayerBindPress(player, bind, bPress)
	return (string.find(bind, "+forward") || string.find(bind, "+moveright") || string.find(bind, "+moveleft") || string.find(bind, "+back") || string.find(bind, "+jump")) && player:GetLocalVar("IsSleeping", false);
end;

function PLUGIN:RenderScreenspaceEffects()
    local player = LocalPlayer()
    local character = player:GetCharacter();
    local hunger = player:GetLocalVar('hunger', 100)
    local sleep = player:GetLocalVar('sleep', 100)
    local ColorModify = {}
    if character && hunger < 55 then
        DrawMotionBlur(math.Clamp(hunger/100, 0.1, 1), 0.8, 0.01)
    end;
    if (character) then
        local color = 1;
		ColorModify["$pp_colour_brightness"] = 0;
		ColorModify["$pp_colour_contrast"] = 1;
		ColorModify["$pp_colour_colour"] = math.Clamp(color - ((player:GetMaxHealth() - player:Health()) * 0.01), 0, color);
		ColorModify["$pp_colour_addr"] = 0;
		ColorModify["$pp_colour_addg"] = 0;
		ColorModify["$pp_colour_addb"] = 0;
		ColorModify["$pp_colour_mulr"] = 0;
		ColorModify["$pp_colour_mulg"] = 0;
        ColorModify["$pp_colour_mulb"] = 0;
        
		if (system.IsOSX()) then
			ColorModify["$pp_colour_brightness"] = 0;
			ColorModify["$pp_colour_contrast"] = 1;
        end;
        
        if sleep < 35 then
            ColorModify["$pp_colour_colour"] = 0.3
        end;
		
	end;
    DrawColorModify(ColorModify);
end


netstream.Hook("OpenSleepInterface", function()
	if (PLUGIN.sleeping and PLUGIN.sleeping:IsValid()) then
		PLUGIN.sleeping:Close();
	end;

	PLUGIN.sleeping = vgui.Create("SleepPanel");
	PLUGIN.sleeping:Populate()
end);
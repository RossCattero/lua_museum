AddCSLuaFile('libraries/sh_pon.lua') include('libraries/sh_pon.lua')
AddCSLuaFile('libraries/sh_netstream.lua') include('libraries/sh_netstream.lua')

if SERVER then return end;
logsTerminal = {};
// All net-s

netstream.Hook("createTerminal", function(logs)
	logsTerminal = logs;
    createTerminal();
end)

netstream.Hook('cmdInit', function(prefix, cmdprefix, cmds) 
	PREFIX = prefix;
	CMDPREFIX = cmdprefix;
	CMDLIST = cmds;

	print('got it?')
end)

// All net-s

// function of net-s

function createTerminal()
	 if !(terminal and terminal:IsValid()) then
		terminal = vgui.Create("Terminal");
		terminal:Populate()
	end;
end

// function of net-s

local panelMeta = FindMetaTable('Panel')

    function panelMeta:Adaptate(w, h, x, y)
        local sW, sH = ScrW(), ScrH()
        x = x or 0.1; y = y or 0.1
        w = w or 100; h = h or 100
    
        self:SetPos( sW * math.min(x, 1.25), sH * math.min(y, 1.25) ) 
        self:SetSize( sW * (w / 1920), sH * (h / 1080) )
    end;
    
    function panelMeta:CreateCloseDebug()
        if input.IsKeyDown( KEY_PAD_MINUS ) or input.IsMouseDown( 111 ) then
            surface.PlaySound("ui/buttonclick.wav");
            self:CloseMe();
        end;
    end;
    
    function panelMeta:CloseMe()
        self:SetVisible(false); self:Remove();
        gui.EnableScreenClicker(false);
    end;

    function draw.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )
        x, y, w, h = math.Round( x ), math.Round( y ), math.Round( w ), math.Round( h )
        draw.RoundedBox( bordersize, x, y, w, h, color )
        surface.SetDrawColor( bordercol )
        surface.DrawTexturedRectRotated( x + bordersize/2, y + bordersize/2, bordersize, bordersize, 0 ) 
        surface.DrawTexturedRectRotated( x + w - bordersize/2, y + bordersize/2, bordersize, bordersize, 270 ) 
        surface.DrawTexturedRectRotated( x + w - bordersize/2, y + h - bordersize/2, bordersize, bordersize, 180 ) 
        surface.DrawTexturedRectRotated( x + bordersize/2, y + h - bordersize/2, bordersize, bordersize, 90 ) 
        surface.DrawLine( x + bordersize, y, x + w - bordersize, y )
        surface.DrawLine( x + bordersize, y + h - 1, x + w - bordersize, y + h - 1 )
        surface.DrawLine( x, y + bordersize, x, y + h - bordersize )
        surface.DrawLine( x + w - 1, y + bordersize, x + w - 1, y + h - bordersize )
    end;
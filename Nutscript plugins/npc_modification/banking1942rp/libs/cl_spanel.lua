local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
    self:MakePopup()
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
        _G.CLOSEDEBUG = true;
    end);
end

vgui.Register( "SPanel", PANEL, "EditablePanel" )
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH()

local PANEL = {}
function PANEL:Init()
	  self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(625, 700, 0.3, 0.15)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
end

function PANEL:Populate()
    local left = nut.inventory.instances[TRADE_INV.left];
    local right = nut.inventory.instances[TRADE_INV.right];

    if !left || !right then 
      self:Close()
      return 
    end;

    self.invs = {}

    self.lInv = self:Add("TradeInventory")
    self.lInv:SetInv(LocalPlayer():GetName(), left:getItems());
    self.lInv:Owned(true)
    
    self.rInv = self:Add("TradeInventory")
    self.rInv:SetInv(TRADE_INV.otherName, right:getItems());
    self.rInv:Owned(false)
    
    self.invs[LocalPlayer():GetName()] = self.lInv;
    self.invs[TRADE_INV.otherName] = self.rInv;
    
    self.btnList = self:Add("BtnListTrade")
end

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	surface.SetDrawColor(Color(70, 70, 70, 225))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 99, 191))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
end;

vgui.Register( "Trade", PANEL, "EditablePanel" )

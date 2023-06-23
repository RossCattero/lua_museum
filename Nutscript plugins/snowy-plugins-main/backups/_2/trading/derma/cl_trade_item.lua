local PANEL = {}
local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH()
local math = math;
local appr = math.Approach
local frameTime = FrameTime() * 50

function PANEL:Init()
    self:SetSize(sw * 0.05, sh * 0.085)
    timer.Simple(0, function()
        self:Populate()
    end)
end

function PANEL:SetItemTable(itemTable)
    self.itemTable = itemTable;
    self.nutToolTip = true
    self:updateTooltip()

    self.defaultColor = Color(60, 60, 60);
    self.borderColor = Color(90, 90, 90);
end;

function PANEL:Populate()
    if !self.itemTable then self:Remove(); return end;

    self.viewModel = self:Add("nutSpawnIcon")
    self.viewModel:Dock(FILL)
    self.viewModel:SetModel(self.itemTable.model)
    self.viewModel.DoClick = function(btn)
        if !self:GetOwned() || PLUGIN:SideReady(self.owned) then 
            return 
        end;
        if self.clickCD && CurTime() <= self.clickCD then
            return;
        end
        self.clickCD = CurTime() + 1;        
        self.choosen = !self.choosen;
        
        if !INV_TRADABLE then INV_TRADABLE = {} end;

        local item = INV_TRADABLE[self.itemTable:getID()];
        INV_TRADABLE[self.itemTable:getID()] = !item && self || nil;

        netstream.Start('trade::SyncItemChoose', self.itemTable:getID())

        surface.PlaySound("buttons/button18.wav")
    end;
end;

function PANEL:updateTooltip()
    local name = self.itemTable:getName();
    local description = self.itemTable:getDesc();
    local w, h = self.itemTable.width, self.itemTable.height
	  self:SetTooltip(
		string.format("<font=nutItemBoldFont>%s</font>\n"..
		"<font=nutItemDescFont>%s\n"..
        "Width: %d Height: %d</font>", name, description, w, h)
	  )
end

function PANEL:SetOwned(name)
    self.owned = name;
end;

function PANEL:GetOwned()
    return self.owned == LocalPlayer():GetName()
end;

function PANEL:Paint( w, h )
    local hov, choosen = self.viewModel:IsHovered(), self.choosen;
    local red, green, blue = self.defaultColor.r, self.defaultColor.g, self.defaultColor.b
    self.defaultColor = {
        r = appr(red, (!choosen && hov && 70 || choosen && 80) || 60, frameTime),
        g = appr(green, (!choosen && hov && 70 || choosen && 80) || 60, frameTime),
        b = appr(blue, (!choosen && hov && 70 || choosen && 80) || 60, frameTime),
    }
    surface.SetDrawColor(self.defaultColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(90, 90, 90))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )
end;

vgui.Register( "ItemPanel", PANEL, "Panel" )
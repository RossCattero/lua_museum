local PLUGIN = PLUGIN;

local PANEL = {};
local FractureCol = Color(255, 97, 0)

function PANEL:Init()
    local sw = ScrW()
    local sh = ScrH()

	-- self:SetPos(sw * (750/sw), sh * (270/sh)) 
    self:SetSize( sw * (500/sw), sh * (500/sh) )
    self:ShowCloseButton( false )
    self:SetTitle('')
	-- self:MakePopup()
	self:SetDraggable(false)
    -- gui.EnableScreenClicker(true);
end;

function PANEL:Paint( w, h )
    draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 100))
    self:CloseOnMinus()
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

local function DermaMenuItemCreate(model, slot, item)
    local items = LocalPlayer():GetLocalVar('ClothesUps')

    local menu = DermaMenu() 
    menu:AddOption("Снять одежду", function()
        if items[slot] then
            netstream.Start("TakeDownClothes", slot, item)
            model:Remove();
        end;
    end)
    menu:Open()  

end;

function PANEL:Populate()
    local character = LocalPlayer():GetCharacter()
    local items = LocalPlayer():GetLocalVar('ClothesUps')
    local itemlist = ix.item.list;
    
    local head = vgui.Create('Panel', self)
    head:SetPos(10, 10)
    head:SetSize(100, 100)
    head.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local headModel = head:Add("ixSpawnIcon")
    headModel:Dock(FILL)
    if items['head'] == nil or items['head'] == "" then 
        headModel:Remove() 
    else 
        headModel:SetModel(itemlist[items['head']].model) 
    end;

    headModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'head', items['head'] )

    end;

    local hands = vgui.Create('Panel', self)
    hands:SetPos(10, 115)
    hands:SetSize(100, 100)
    hands.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local handsModel = hands:Add("ixSpawnIcon")
    handsModel:Dock(FILL)
    if items['hands'] == nil or items['hands'] == "" then 
        handsModel:Remove() 
    else 
        handsModel:SetModel(itemlist[items['hands']].model) 
    end;
    handsModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'hands', items['hands'] )

    end;

    local tools = vgui.Create('Panel', self)
    tools:SetPos(10, 390)
    tools:SetSize(100, 100)
    tools.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local toolsModel = tools:Add("ixSpawnIcon")
    toolsModel:Dock(FILL)
    if items['tools'] == nil or items['tools'] == "" then 
        toolsModel:Remove() 
    else 
        toolsModel:SetModel(itemlist[items['tools']].model) 
    end;
    toolsModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'tools', items['tools'] )

    end;

    local steto = vgui.Create('Panel', self)
    steto:SetPos(10, 285)
    steto:SetSize(100, 100)
    steto.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local stetoModel = steto:Add("ixSpawnIcon")
    stetoModel:Dock(FILL)
    if items['steto'] == nil or items['steto'] == "" then 
        stetoModel:Remove() 
    else 
        stetoModel:SetModel(itemlist[items['steto']].model) 
    end;
    stetoModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'steto', items['steto'] )

    end;

    local face = vgui.Create('Panel', self)
    face:SetPos(200, 10)
    face:SetSize(100, 100)
    face.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local faceModel = face:Add("ixSpawnIcon")
    faceModel:Dock(FILL)
    if items['gasmask'] == nil or items['gasmask'] == "" then 
        faceModel:Remove() 
    else 
        faceModel:SetModel(itemlist[items['gasmask']].model) 
    end;  
    faceModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'gasmask', items['gasmask'] )

    end;

    local torso = vgui.Create('Panel', self)
    torso:SetPos(180, 120)
    torso:SetSize(140, 200)
    torso.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local torsoModel = torso:Add("ixSpawnIcon")
    torsoModel:Dock(FILL)
    if items['body'] == nil or items['body'] == "" then 
        torsoModel:Remove() 
    elseif items['body'] != nil && items['body'] != "" then 
        torsoModel:SetModel(itemlist[items['body']].model) 
    end;
    torsoModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'body', items['body'] )

    end;

    local gear = vgui.Create('Panel', self)
    gear:SetPos(330, 120)
    gear:SetSize(140, 200)
    gear.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local gearModel = gear:Add("ixSpawnIcon")
    gearModel:Dock(FILL)
    if items['gear'] == nil or items['gear'] == "" then 
        gearModel:Remove() 
    else 
        gearModel:SetModel(itemlist[items['gear']].model) 
    end;
    gearModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'gear', items['gear'] )

    end;

    local legs = vgui.Create('Panel', self)
    legs:SetPos(180, 325)
    legs:SetSize(140, 165)
    legs.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local legsModel = legs:Add("ixSpawnIcon")
    legsModel:Dock(FILL)
    if items['legs'] == nil or items['legs'] == "" then 
        legsModel:Remove() 
    else 
        legsModel:SetModel(itemlist[items['legs']].model) 
    end;
    legsModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'legs', items['legs'] )

    end;

    local elbow = vgui.Create('Panel', self)
    elbow:SetPos(330, 325)
    elbow:SetSize(80, 80)
    elbow.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local elbowModel = elbow:Add("ixSpawnIcon")
    elbowModel:Dock(FILL)
    if items['elbowpads'] == nil or items['elbowpads'] == "" then 
        elbowModel:Remove() 
    else 
        elbowModel:SetModel(itemlist[items['elbowpads']].model) 
    end;
    elbowModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'elbowpads', items['elbowpads'] )

    end;

    local knee = vgui.Create('Panel', self)
    knee:SetPos(330, 410)
    knee:SetSize(80, 80)
    knee.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(30, 30, 30, 100), Color(0,0,0))
    end;

    local kneeModel = knee:Add("ixSpawnIcon")
    kneeModel:Dock(FILL)
    if items['kneepads'] == nil or items['kneepads'] == "" then 
        kneeModel:Remove() 
    else 
        kneeModel:SetModel(itemlist[items['kneepads']].model)
    end;
    kneeModel.DoClick = function(btn)
      
        DermaMenuItemCreate( btn, 'kneepads', items['kneepads'] )

    end;
end;

vgui.Register( "PlayerClothes", PANEL, "DFrame" )

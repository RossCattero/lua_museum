
local PLUGIN = PLUGIN;

local firstHunger, secondHunger, thirdHunger = Material('materials/icons/hung_green.png'), Material('materials/icons/hung_yellow.png'), Material('materials/icons/hung_red.png')
local firstThirst, secondThist, thirdThirst = Material('materials/icons/bottle_green.png'), Material('materials/icons/bottle_yellow.png'), Material('materials/icons/bottle_red.png')
local firstSleep, secondSleep, thirdSleep = Material('materials/icons/spatki_green.png'), Material('materials/icons/spatki_yellow.png'), Material('materials/icons/spatki_red.png')
local healIcon = Material('materials/icons/health_regen.png')
function PLUGIN:HUDPaint()
    local player = LocalPlayer(); local character = player:GetCharacter();
    local sw, sh = ScrW(), ScrH()
    local hunger = player:GetLocalVar('hunger', 100)
    local thirst = player:GetLocalVar('thirst', 100)
    local sleep = player:GetLocalVar('sleep', 100)

    local ishealing = player:GetLocalVar('ishealing')

    if !character then
        return;
    end;

    if ishealing then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( healIcon )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.49, 32, 32 )
    end;

    if hunger <= 25 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( thirdHunger )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.55, 32, 32 )
    elseif hunger <= 50 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( secondHunger )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.55, 32, 32 )
    elseif hunger <= 75 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( firstHunger )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.55, 32, 32 )
    end;
    if thirst <= 25 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( thirdThirst )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.60, 32, 32 )
    elseif thirst <= 50 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( secondThist )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.60, 32, 32 )
    elseif thirst <= 75 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( firstThirst )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.60, 32, 32 )
    end;
    if sleep <= 25 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( thirdSleep )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.65, 32, 32 )
    elseif sleep <= 50 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( secondSleep )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.65, 32, 32 )
    elseif sleep <= 75 then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( firstSleep )
        surface.DrawTexturedRect( sw * 0.97, sh * 0.65, 32, 32 )
    end;
end;

-- function PLUGIN:RenderScreenspaceEffects()
--     local player = LocalPlayer(); local character = player:GetCharacter();
--     local hunger = player:GetLocalVar('hunger', 100)
--     if character && hunger < 65 then
--         DrawMotionBlur(math.Clamp(hunger/100, 0.1, 1), 0.8, 0.01)
--     end;
-- end

netstream.Hook('PreSleeping', function()
        local scrW = surface.ScreenWidth();
        local scrH = surface.ScreenHeight();
        local sW = (scrW/2) - 250;
        local sH = (scrH/2) - 350;
    
        local frame = vgui.Create("DFrame");
        frame:SetPos(sW, sH)
        frame:SetSize(400, 200)
        frame:SetTitle("")
        frame:SetBackgroundBlur( true )
        frame:SetDraggable( false )
        frame:ShowCloseButton( false )
        frame:MakePopup()
        frame.lblTitle:SetContentAlignment(8)
        frame.lblTitle.UpdateColours = function( label, skin )
            label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
        end;
        frame.Paint = function(self, w, h)
            if ( self.m_bBackgroundBlur ) then
                Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
            end
            draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        end;
        
        local DPanelTime = vgui.Create( "DPanel", frame )
        DPanelTime:SetPos( 10, 10 )
        DPanelTime:SetSize( 380, 50 )
        DPanelTime.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150));
        end;
    
        local TimeSlider = vgui.Create( "DNumSlider", DPanelTime )
        TimeSlider:SetPos( 10, 10 )
        TimeSlider:SetSize( 360, 30 )
        TimeSlider:SetText( "Время сна" )
        TimeSlider:SetMin( 0 )
        TimeSlider:SetMax( 80 )
        TimeSlider:SetDecimals( 0 )
        TimeSlider.TextArea:SetTextColor(Color(255, 255, 255))
        
        local startsleep = vgui.Create( "DButton", frame )
        startsleep:SetText("[Начать спать]")
        startsleep:SetPos( 70, 160 )
        startsleep:SetSize(100, 30)
        startsleep:SetTextColor(Color(232, 187, 8, 255))
        startsleep.Paint = function(self, x, y)
            if self:IsHovered() then
                draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
            else
                draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
            end;
        end;
        
        startsleep.DoClick = function()
            netstream.Start('StartSleeping', tonumber(TimeSlider:GetValue()) );
        end;
    
        local closebtn = vgui.Create( "DButton", frame )
        closebtn:SetText("[X]")
        closebtn:SetPos( 10, 160 )
        closebtn:SetSize(50, 30)
        closebtn:SetTextColor(Color(232, 187, 8, 255))
        closebtn.Paint = function(self, x, y)
            if self:IsHovered() then
                draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
            else
                draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
            end;
        end;
        
        closebtn.DoClick = function()
            surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
            frame:Close(); frame:Remove();
        end;
end);

function PLUGIN:PlayerBindPress(player, bind, bPress)
    local isSleeping = player:GetLocalVar("IsSleeping", false)
    if isSleeping then
        return true;
    end;
end;
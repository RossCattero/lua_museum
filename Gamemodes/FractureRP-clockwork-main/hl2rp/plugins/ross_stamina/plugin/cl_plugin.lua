
local PLUGIN = PLUGIN;

CW_CONVAR_STAMINA = Clockwork.kernel:CreateClientConVar("cwStaminaIconDraw", 0, true, true);
Clockwork.setting:AddCheckBox("ИКОНКИ", "Выносливость", "cwStaminaIconDraw", "Включить иконку выносливости?");

local lungs = 0;
local heall = Material('lungsicon3.png')

function PLUGIN:HUDPaint()

    local factionDisallow = {
        FACTION_CREMATOR,
        FACTION_GUARDER,
        FACTION_ASSASIN,
        FACTION_STALKER
    }

    local ply = Clockwork.Client
    if CW_CONVAR_STAMINA:GetBool() && !table.HasValue(factionDisallow, ply:GetFaction()) then
        local sh, wh, rot = ScrH(), ScrW(), -90 	
        lungs = math.Approach( lungs, ply:GetSharedVar('stamina'), 100 * FrameTime() ) 
        local percent = lungs/100  
        local lowamount = 300
        render.SetScissorRect( wh * 0.99, sh-(100*percent) - (lowamount-50), 200, sh, true ) 	
        render.SetMaterial( heall ) 	
        render.DrawQuadEasy( Vector( wh * 0.99 - 50, sh-lowamount, 0), Vector(0, 0, -1), 100, 100, Color(255, 255, 255), rot) 	
        render.SetScissorRect( wh * 0.99, sh, 100, sh, false )
    end;
end;

function PLUGIN:SetupMove(player, mv, cmd)
    if !player:HasInitialized() or player:GetMoveType() == MOVETYPE_NOCLIP then
        return;
    end;
    local stam = player:GetSharedVar('stamina')
    local walkbutton = cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK);
    local jumpbutton = cmd:KeyDown(IN_JUMP);
    local crouchbutton = cmd:KeyDown(IN_DUCK)
    local keybuttons = walkbutton and cmd:KeyDown(IN_SPEED)
    local invw = player:GetSharedVar("InvWeight")
    local maxWeight = Clockwork.player:GetMaxWeight()

    if team.GetName(player:Team()) == 'Синтеты' then
        if player:GetFaction() == FACTION_CREMATOR then
            mv:SetMaxClientSpeed( 40 )
            mv:SetMaxSpeed( 40 )

            return;
        elseif player:GetFaction() == FACTION_GUARDER then
            mv:SetMaxClientSpeed( 70 )
            mv:SetMaxSpeed( 70 )

            return;
        elseif player:GetFaction() == FACTION_STALKER then
            return;

        elseif player:GetFaction() == FACTION_ASSASIN then
            mv:SetMaxClientSpeed( 500 )
            mv:SetMaxSpeed( 500 )
            return;
        end;
    end;

    if invw > maxWeight + 2 then
        mv:SetMaxClientSpeed( 1 )
        mv:SetMaxSpeed( 1 )
        return;
    end;

    if keybuttons then
        mv:SetMaxClientSpeed( 25+(stam*2) )
        mv:SetMaxSpeed( 25+(stam*2) )
    end;
    if crouchbutton && walkbutton then
        mv:SetMaxClientSpeed( 20 + (stam/10) )
        mv:SetMaxSpeed( 20 + (stam/10) )
    end;
    if walkbutton and !cmd:KeyDown(IN_SPEED) then
        mv:SetMaxClientSpeed( 10 + stam )
        mv:SetMaxSpeed( 10 + stam)
    end;
end;
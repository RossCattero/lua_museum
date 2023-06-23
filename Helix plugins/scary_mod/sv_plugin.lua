-- Called when entity spawned. NPCs are entities too
function PLUGIN:OnEntityCreated( npc )
    if IsValid(npc) and npc:GetClass() == ix.scary.target then
        -- Add entity to the global list
        ix.scary.instances[npc] = true
    end;
end;

function PLUGIN:PostPlayerLoadout(client)
    -- Check if player is actually using flashlight
    -- To prevert turning on accidentally
    client:SetLocalVar("flashlight_turned_on", false)
    client:Flashlight( false )
    -- Flickering chance
    client:SetLocalVar("flashlight_percent", 0)
    -- List of emited indexes
    client:SetLocalVar("scary_event_emited", {})
    -- Allow flashlight by default
    -- ! May disable any other flashlight addons
    client:AllowFlashlight( true )

    local flashlight, scary = "ixFlashlightCheck" .. client:SteamID(), "ixScaryCheck" .. client:SteamID()

    timer.Create(scary, 6, 0, function()
        if not IsValid(client) then
            timer.Remove(scary)
            return
        end
        
        -- Seek for all npcs in list
        for npc in pairs(ix.scary.instances) do
            local squareDistance = client:GetPos():DistToSqr( npc:GetPos() )
            local scary_events = client:GetLocalVar("scary_event_emited", {})

            -- And if any npc found - check the distance, notification availability
            -- And pop a notification based on data
            for index, roar in pairs(ix.scary.events) do
                if squareDistance <= (roar.distance * 1000) and not scary_events[index] then
                    scary_events[index] = true
                    client:SetLocalVar("flashlight_percent", roar.flashlight_percent or 0)
                    -- Trigger the sound on clientside
                    -- See libs/cl_netwroking.lua
                    net.Start("ix.scary.emitSound")
                        net.WriteInt(index, 32)
                        net.WriteEntity(npc)
                    net.Send(client)
                    return
                end;
                if squareDistance > (roar.distance * 1000) and scary_events[index] then
                    scary_events[index] = false
                    client:SetLocalVar("flashlight_percent", 0)
                    client:AllowFlashlight( true )
                end;
            end;
        end;
    end)

    timer.Create(flashlight, .35, 0, function()
        if not IsValid(client) then
            timer.Remove(flashlight)
            return
        end

        -- If flashlight is disabled, then return.
        -- if not client:CanUseFlashlight() or not client:GetLocalVar("flashlight_turned_on") then return end;
        if not client:CanUseFlashlight() then return end;

        -- Check if player's flicker percent is 100 or more
        -- If so, to prevent epilepsia, just turn off flashlight
        local flashlightPercent = client:GetLocalVar("flashlight_percent", 0)

        if flashlightPercent >= 100 then
            client:Flashlight( false )
            client:SetLocalVar('flashlight_turned_on', false)
            client:AllowFlashlight( false )
            return
        end;

        -- ! Allow player's flashlight
        -- ! May disable any other flashlight addons
        client:AllowFlashlight( true )

        -- Check if percent is more than random.
        -- If true, then disable and enable flashlight to emitate 'flickering'
        if flashlightPercent > 0 then
            -- Turn on player's flashlight if it's somehow is turned off
            if not client:FlashlightIsOn() then
                client:Flashlight(true)
            end;
            if math.random(100) < flashlightPercent then
                client:Flashlight( false )
                -- client:SetLocalVar('flashlight_turned_on', false)
                timer.Simple(.25, function()
                    if IsValid(client) then
                        client:Flashlight( true )
                        -- client:SetLocalVar('flashlight_turned_on', true)
                    end;
                end)
            end;
        end;
    end)
end

-- Dont forget to sync npc list on player spawn
-- Receive sound emit data
net.Receive("ix.scary.emitSound", function(len)
    local event_index = net.ReadInt(32)
    local npc = net.ReadEntity()

    if IsValid(npc) and ix.scary.instances[npc] then
        local event = ix.scary.events[tostring(event_index)]

        local new = CreateSound( npc, event.path )
        new:Play()
        new:SetSoundLevel( event.pitch or 100 )
    end;
end)
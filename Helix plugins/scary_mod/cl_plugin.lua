-- On network entity created
function PLUGIN:NetworkEntityCreated( npc )
    if IsValid(npc) and npc:GetClass() == ix.scary.target then
        -- Add entity to the global list
        ix.scary.instances[npc] = true
    end;
end;

-- On bind pressed
function PLUGIN:PlayerBindPress(ply, bind, pressed)
    -- Additional check for flashlight
    -- Maybe not good, but working fine.
    if string.find( bind, "impulse 100" ) and ply:GetLocalVar("flashlight_percent", 0) > 0 then
        return true
		-- net.Start("ix.scary.flashlighted")
        -- net.SendToServer()
	end
end;
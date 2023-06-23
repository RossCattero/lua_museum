-- Network string for sound emitation
-- See libs/cl_networking.lua
util.AddNetworkString("ix.scary.emitSound")

-- Network string for flashlight check.
-- See cl_plugin.lua
-- util.AddNetworkString("ix.scary.flashlighted")

-- net.Receive("ix.scary.flashlighted", function(len, ply)
--     if not ply:CanUseFlashlight() or ply:GetLocalVar("flashlight_percent", 0) >= 0 then return end;

--     ply:SetLocalVar("flashlight_turned_on", not ply:GetLocalVar("flashlight_turned_on"))
-- end)
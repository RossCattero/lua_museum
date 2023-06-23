local PLUGIN = PLUGIN

PLUGIN.name = "Scary mod"
PLUGIN.author = "Ross"
PLUGIN.description = "Test mod for Tea-Man"

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("meta/sh_scary.lua")
ix.scary.LoadFromDir(PLUGIN.folder .. "/scary")

-- Called on entity removed.
function PLUGIN:EntityRemoved( npc )
    if npc:GetClass() == ix.scary.target and ix.scary.instances[npc] then
        ix.scary.instances[npc] = nil
    end;
end;

-- Spawn a scary entity
-- See libs/sh_scary.lua > ix.scary.SpawnEntity
ix.command.Add("SpawnScaryEntity", {
	description = "Spawn scary entity",
	superAdminOnly = true,
	OnRun = function(self, client)
		local forward, view_normal = client:GetAngles():Forward(), client:GetPos() - client:EyePos()
        view_normal:Normalize()
        local ViewDot = view_normal:Dot( forward * -1 )

        if ViewDot >= 0 then
            ix.scary.SpawnEntity(client:GetPos() + forward * 100)

            client:Notify("You spawned scary entity!")
        end;
	end
})

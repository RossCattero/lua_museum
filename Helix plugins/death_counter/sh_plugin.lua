local PLUGIN = PLUGIN

PLUGIN.name = "Death counter"
PLUGIN.author = "Ross"
PLUGIN.description = "Death counter plugin."

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")


-- A command to enable or disable death counters for all players.
ix.command.Add("EnableDeathCounter", {
    description = "Enable death counter for event.",
    OnCheckAccess = function(self, client)
        return client:IsAdmin() or client:IsSuperAdmin()
    end,
	arguments = ix.type.bool,
    OnRun = function(self, client, bool)
        -- netstream.Start(client, 'ToggleDeathCounter', bool);

        local getInfo = function()
            local state = "Turned on"

            if bool == false then
                state = 'Turned off'
            end;

            return state;
        end;
        for id, player in pairs(player.GetAll()) do
            player:Notify('The global death counter is now '..getInfo())
        end;

        --[[ ]]--
            EnableDeathCounter = bool;
            for k, v in pairs(player.GetAll()) do
                netstream.Start(v, 'NetworkGlobalDeathCounters', EnableDeathCounter)
            end;
        --[[ ]]--
	end
})

-- A command to edit specified character's death counter;
ix.command.Add("EditDeath", {
    description = "Edit character's death counter. 0 for reset.",
    OnCheckAccess = function(self, client)
        return client:IsAdmin() or client:IsSuperAdmin()
    end,
	arguments = {
        ix.type.player,
        ix.type.number
    },
    OnRun = function(self, client, vic, num)
        vic:EditDeath(num)

        vic:Notify('Your amount of death is now: '..num);
        client:Notify("You've changed the death amount of a character "..vic:Name().." to "..num);
	end
})
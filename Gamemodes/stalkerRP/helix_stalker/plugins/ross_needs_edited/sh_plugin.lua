
local PLUGIN = PLUGIN;

PLUGIN.name = "Needs plugin"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

ix.command.Add("CharSetHunger", {
	description = "Установить игроку значение голода",
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetHunger( number );
	end
})

ix.command.Add("CharSetThirst", {
	description = "Установить игроку значение голода",
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetThirst( number );
	end
})

ix.command.Add("CharSetSleep", {
	description = "Установить игроку значение голода",
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetSleep( number );
	end
})
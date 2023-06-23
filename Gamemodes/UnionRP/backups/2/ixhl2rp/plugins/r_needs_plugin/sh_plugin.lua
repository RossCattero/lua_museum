local PLUGIN = PLUGIN

PLUGIN.name = "Needs plugin"
PLUGIN.author = "Ross"
PLUGIN.description = "Needs plugin done by Ross."

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

        target:SetLocalVar( 'hunger', number );

        client:Notify('Вы изменили значение голода игрока '..target:Name()..' на '..number..'.');

        if client != target then
            target:Notify(client:Name()..' изменил ваше значение голода на '..number..'.');
        end;
	end
})

ix.command.Add("CharSetThirst", {
	description = "Установить игроку значение жажды",
	adminOnly = true,
	arguments = {
		ix.type.player,
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self, client, target, number)
        if !number then
            number = 100;
        end;

        target:SetLocalVar( 'thirst', number );

        client:Notify('Вы изменили значение жажды игрока '..target:Name()..' на '..number..'.');
        if client != target then
            target:Notify(client:Name()..' изменил ваше значение жажды на '..number..'.');
        end;
	end
})

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

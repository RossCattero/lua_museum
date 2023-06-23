PLUGIN.name = "Datapad > ranks"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Ranks plugin for datapad."

ix.util.Include("sh_commands.lua")
ix.util.Include( "meta/sh_rank.lua" )
ix.ranks.LoadFromDir(PLUGIN.folder .. "/ranks")
PLUGIN.name = "Limbs: Injuries"
PLUGIN.author = Schema.author
PLUGIN.description = "Module for limbs system"

INJURIES = INJURIES || {};

ix.util.Include("meta/sh_injury.lua")
INJURIES.LoadFromDir(PLUGIN.folder .. "/injuries")

ix.util.Include("sv_plugin.lua")

netstream.Hook("NETWORK_INJURY_INSTANCE", function(index, id, data)
	if !index then
		INJURIES.INSTANCES = {}
		return;
	end

	local wound = INJURIES.New( index, id, nil, data )
	wound.data = data;
end);
netstream.Hook("NETWORK_INJURY_REMOVE", function(id)
	if INJURIES.INSTANCES[id] then
		INJURIES.INSTANCES[id] = nil;
	end;
end);
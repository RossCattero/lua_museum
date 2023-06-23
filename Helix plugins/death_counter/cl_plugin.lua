local PLUGIN = PLUGIN;
--[[ Clientside boolean to check if death counters should be enabled. ]]--
EnableDeathCounter = EnableDeathCounter or false;

--[[ Synchronize death counter serverside global boolean. It's safe, don't worry. ]]
netstream.Hook('NetworkGlobalDeathCounters', function(bool)
    EnableDeathCounter = bool;
end)
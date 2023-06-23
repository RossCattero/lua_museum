local PLUGIN = PLUGIN;

netstream.Hook("nut.banking.paycheck.take", function(client, entIndex)
	local entity = Entity(tonumber(entIndex))

	if IsValid(entity) && entity:GetClass() == "paycheck_npc" then
		entity:Paycheck( client );
	end;
end)
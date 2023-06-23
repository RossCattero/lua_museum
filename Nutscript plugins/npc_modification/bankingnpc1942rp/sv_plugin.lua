local PLUGIN = PLUGIN;

netstream.Hook('Banking::TalkerActivity', function(client, index, data)
		if !client:ValidEnt() then return end;
		local answer = PLUGIN.answers[index];

		if answer && answer.callback then
				answer.callback(client, data)
		end
end);

local user = FindMetaTable("Player")

function user:ValidEnt()
		local trace = self:GetEyeTraceNoCursor();
		local ent = trace.Entity;

		return ent:GetClass() == "banking_npc" && self:GetPos():DistToSqr( ent:GetPos() ) < 512 * 512;
end;
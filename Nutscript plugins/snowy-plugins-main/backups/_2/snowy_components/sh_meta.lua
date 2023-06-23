local PLUGIN = PLUGIN;
local ent = FindMetaTable("Entity")
local user = FindMetaTable("Player")

function ent:Tracer(amount)
		if !amount then amount = 2058 end;

		local pos = self:GetShootPos()
		if !pos then return end;
		local angle = self:GetAimVector();
		local tracedata = {
			start = pos,
			endpos = pos + (angle * amount), 
			filter = self
		}
		local trace = util.TraceLine(tracedata)

		return trace;
end;

function user:IsTargetTurned(target)
		return IsValid(target) && target.GetAimVector && target:GetAimVector():DotProduct(self:GetAimVector()) > 0;
end

function user:ValidateNPC(class)
		local trace = self:GetEyeTraceNoCursor();
		local ent = trace.Entity;
		if ent && ent:GetClass() == class then
				local distance = self:GetPos():Distance( ent:GetPos() );
				return distance < 128;
		end
		return false;
end;
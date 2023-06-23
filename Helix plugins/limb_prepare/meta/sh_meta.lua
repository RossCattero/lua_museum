local PLUGIN = PLUGIN;

local ent = FindMetaTable("Entity")
function ent:Tracer(amount)
		if !self:IsValid() || !self.GetShootPos then return end;
		if !amount then amount = 2058*2058 end;

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

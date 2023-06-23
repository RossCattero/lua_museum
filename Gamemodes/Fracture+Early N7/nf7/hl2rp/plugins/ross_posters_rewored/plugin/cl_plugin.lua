
local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	local ec = entity:GetClass();
    local mins = entity:OBBMins()
	local maxs = entity:OBBMaxs()
	local startpos = entity:GetPos()
	local dir = -entity:GetForward()

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir,
		maxs = maxs,
		mins = mins,
        filter = function(ent) 
            if ent || ent:IsPlayer() then
                return false;
            end;
        end;
    } )
	
	if ec == 'ross_poster_entity' then
		if tr.Hit then
			options["Приклеить постер"] = "poster_place";
		end;
	end;
    
end;
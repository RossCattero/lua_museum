
local PLUGIN = PLUGIN;


function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)

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

    if (ec == "ross_poster_entity" && arguments == "poster_place") then
        if tr.Hit then
            
            local physObj = entity:GetPhysicsObject();
    		if (IsValid(physObj)) then
	    		physObj:EnableMotion(false);
		    end;

        end;
    end;
end;
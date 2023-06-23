local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

function PLUGIN:OnNPCKilled(entity)
	local class = entity:GetClass()
	local items = {}
	local rand = math.random(0, 100)

	if (class == "npc_headcrab") then
		if rand >= 90 then
		Clockwork.entity:CreateItem(nil, "headcrab_meat", entity:GetPos() + Vector(0, 0, 8))
	else
		return false
	    end;
	end;
	if (class == "npc_headcrab_fast") then
		if rand >= 90 then		
		Clockwork.entity:CreateItem(nil, "headcrab_meat", entity:GetPos() + Vector(0, 0, 8))
	else
		return false
		end;	
	end;	
	if (class == "npc_headcrab_black") then
		if rand >= 85 then
		Clockwork.entity:CreateItem(nil, "headcrab_meat_toxic", entity:GetPos() + Vector(0, 0, 8))
	else
		return false
	    end;
	end;		
	if (class == "npc_antlion") then
		if rand >= 90 then
		Clockwork.entity:CreateItem(nil, "murav_meat", entity:GetPos() + Vector(0, 0, 8))
	else
		return false
	    end;
	end;	
end;
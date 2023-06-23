local PLUGIN = PLUGIN;

function PLUGIN:SaveData()
	local data = {};
	for entity in pairs( nut.rossnpcs.entities ) do
		if entity != NULL then
			local buffer = {};
			buffer.position = entity:GetPos();
			buffer.angles = entity:GetAngles();
			buffer.class = entity:GetClass();
			buffer.data = entity.data;

			table.insert(data, buffer)
		end;
	end

	nut.data.set("RossNPCs", data)
end;

function PLUGIN:LoadData()
	for k, v in pairs( nut.data.get("RossNPCs", {}) ) do
		local entity = ents.Create( v.class )
		entity.spawned = true;
		entity:SetPos( v.position )
		entity:SetAngles( v.angles )
		entity:Spawn()
		if entity.SetData then
			entity:SetData( v.data )
		end;
	end;
end;
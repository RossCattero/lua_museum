local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadEmplacementGuns();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveEmplacementGuns();
end;

-- A function to load the Union locks.
function PLUGIN:LoadEmplacementGuns()
	local emplacementGuns = Clockwork.kernel:RestoreSchemaData( "plugins/emplacementGuns/"..game.GetMap() );
	
	for k, v in pairs(emplacementGuns) do
		local entity = ents.Create("cw_emplacementgun");
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		entity:Activate();
		entity:SpawnProp();
		
		if ( IsValid(entity) ) then
			entity:SetAngles(v.angles);
		end;
	end;
end;

-- A function to save the Union locks.
function PLUGIN:SaveEmplacementGuns()
	local emplacementGuns = {};
	
	for k, v in pairs(ents.FindByClass("cw_emplacementgun")) do
		emplacementGuns[#emplacementGuns + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID")
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/emplacementGuns/"..game.GetMap(), emplacementGuns);
end;

local PLUGIN = PLUGIN;

function PLUGIN:EntityFireBullets(entity, bulletInfo) 
    if (entity.FiredBullet) then return; end;

	local trace = util.QuickTrace(bulletInfo.Src, bulletInfo.Dir * 10000, entity);

	if (IsValid(trace.Entity) && trace.Entity:GetClass() == "ross_forcefield" && entity:GetIsTurned()) then
		for i = 1, (bulletInfo.Num || 1) do
			local newbullet = table.Copy(bulletInfo);
			newbullet.Src = trace.HitPos + trace.Normal * 1;

			entity.FiredBullet = true;
			entity:FireBullets(newbullet);
			entity.FiredBullet = false;
		end;

		return false;
	end;
end;

function PLUGIN:ShouldCollide(ent, entToColl)
    local colIsPly = entToColl:IsPlayer();
    local isFF = ent:GetClass() == "ross_forcefield"
    local bool = true;

    if colIsPly && isFF then
        
        if !ent:GetIsTurned() || ent.AllowedFactions[entToColl:GetFaction()] == true then
            return !bool
        else
            return bool;
        end;

    end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadForceFields();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveForceFields();
end;

function PLUGIN:SaveForceFields()
    local forcefield = {}
    
    for k, v in pairs(ents.FindByClass("ross_forcefield")) do
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
    
        if (v:IsMapEntity() and startPos) then
            model = nil;
        end;
                    
        if (IsValid(physicsObject)) then
            bMoveable = physicsObject:IsMoveable();
        end;	
    
        forcefield[#forcefield + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
            isMoveable = bMoveable,
            isTurnedOn = v:GetIsTurned(),
            secondEnt = v:GetEntInfo()
        };
    end;
    Clockwork.kernel:SaveSchemaData("plugins/forcefields/"..game.GetMap(), forcefield);
end;
    
function PLUGIN:LoadForceFields()
        local forcefield = Clockwork.kernel:RestoreSchemaData("plugins/forcefields/"..game.GetMap());
        
        self.forcefield = {};
        
        for k, v in pairs(forcefield) do
            if (!v.model) then
                local entity = ents.Create("ross_forcefield");
                
                if (IsValid(entity) and entity:IsMapEntity()) then
                    self.forcefield[entity] = entity;
                    
                    if (IsValid(entity:GetPhysicsObject())) then
                        if (!v.isMoveable) then
                            entity:GetPhysicsObject():EnableMotion(false);
                        else
                            entity:GetPhysicsObject():EnableMotion(true);
                        end;
                    end;
                    
                    if (v.angles) then
                        entity:SetAngles(v.angles);
                        entity:SetPos(v.position);
                    end;

                    entity:SetIsTurned(true);
                    entity:SetEntInfo(v.secondEnt);
                end;
            else
                local entity = ents.Create("ross_forcefield");
                
                entity:SetAngles(v.angles);
                entity:SetModel(v.model);
				entity:SetPos(v.position);
                entity:SetIsTurned(true);
                entity:SetEntInfo(v.secondEnt);
				entity:Spawn();
                
                if (IsValid(entity:GetPhysicsObject())) then
                    if (!v.isMoveable) then
                        entity:GetPhysicsObject():EnableMotion(false);
                    end;
                end;
                
                self.forcefield[entity] = entity;
            end;
        end;
end;

cable.receive('GetForceFieldFactionM', function(player, ent, table)

    ent.AllowedFactions = table;

end);
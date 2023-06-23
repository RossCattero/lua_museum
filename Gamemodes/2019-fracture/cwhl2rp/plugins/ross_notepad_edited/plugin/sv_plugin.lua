
local PLUGIN = PLUGIN;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	
	if (entity:GetClass() == "cw_notepad_holder" && arguments == "cw_notepad_holder_open") then
        if (!weight) then 
            weight = 17 
        end;	
        if (!entity.cwInventory) then 
            entity.cwInventory = {}; 
        end;
 
		Clockwork.storage:Open(player, {
			name = "Шкафчик для блокнотов",
			weight = weight,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			OnGiveCash = function(player, storageTable, cash)
				return false;
			end,
			OnTakeCash = function(player, storageTable, cash)
				return false;
			end,
			OnClose = function(player, storageTable, entity)
			end,
            CanGiveItem = function(player, storageTable, itemTable)
                if itemTable("uniqueID") == "ross_notepad" then
                    return true;
                end;
			end
		});				
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LockerLoad();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:LockerSave();
end;

function PLUGIN:LockerSave()
    local locker = {}
    
        for k, v in pairs(ents.FindByClass("cw_notepad_holder")) do
        if (v.cwInventory and (table.Count(v.cwInventory) > 0)) then
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
    
        if (v:IsMapEntity() and startPos) then
            model = nil;
        end;
                    
        if (IsValid(physicsObject)) then
            bMoveable = physicsObject:IsMoveable();
        end;	
    
        locker[#locker + 1] = {
                angles = v:GetAngles(),
                position = v:GetPos(),
                inventory = Clockwork.inventory:ToSaveable(v.cwInventory),
                model = v:GetModel(),
                isMoveable = bMoveable
            };
    
        end;
    end;
        Clockwork.kernel:SaveSchemaData("plugins/lockers/"..game.GetMap(), locker);
    end;
    
    function PLUGIN:LockerLoad()
        local locker = Clockwork.kernel:RestoreSchemaData("plugins/lockers/"..game.GetMap());
        
        self.locker = {};
        
        for k, v in pairs(locker) do
            if (!v.model) then
                local entity = ents.Create("cw_notepad_holder");
                
                if (IsValid(entity) and entity:IsMapEntity()) then
                    self.locker[entity] = entity;
                    
                    entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
                    entity.cwPassword = v.password;
                    
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
                end;
            else
                local entity = ents.Create("cw_notepad_holder");
                
                entity:SetAngles(v.angles);
                entity:SetModel(v.model);
                entity:SetPos(v.position);
                entity:Spawn();
                
                if (IsValid(entity:GetPhysicsObject())) then
                    if (!v.isMoveable) then
                        entity:GetPhysicsObject():EnableMotion(false);
                    end;
                end;
                
                self.locker[entity] = entity;
                
                entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
            end;
        end;
    end;

cable.receive('ClosePad', function(player, tbl, title)
    local t = player:GetEyeTraceNoCursor();
    local ent = t.Entity;
    

    if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "baseItem") == "ross_notepad_base" then
        ent.IsUsedNow = nil;
        git(ent, "data")["NotepadTableForMe"]["information"] = tbl["information"];
        git(ent, "data")["NotepadTableForMe"]["title"]= tbl["title"];
    else
        local notepad = player:FindItemByID(tbl["additionalInfo"]["uniqueID"], tbl["additionalInfo"]["ItemID"]);
        if notepad then
            notepad:GetData("NotepadTableForMe")["information"] = tbl["information"];
            notepad:GetData("NotepadTableForMe")["title"] = tbl["title"];
        end;    
    end;

end);

cable.receive('EditPadSettings', function(player, type, value, tbl)
    local t = player:GetEyeTraceNoCursor();
    local ent = t.Entity;

    if type == "Owner" then
        if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "baseItem") == "ross_notepad_base" then
            git(ent, "data")["NotepadTableForMe"]["owner"] = value;
        else
            local notepad = player:FindItemByID(tbl["additionalInfo"]["uniqueID"], tbl["additionalInfo"]["ItemID"]);
            if notepad then
                notepad:GetData("NotepadTableForMe")["owner"] = value;
            end;
        end;
    end;

    if type == "Pick" then
        if ent:GetClass() == "cw_item" && player:GetPos():Distance(ent:GetPos()) < 90 && git(ent, "baseItem") == "ross_notepad_base" then
            git(ent, "data")["NotepadTableForMe"]["pickup"] = value;
        else
            local notepad = player:FindItemByID(tbl["additionalInfo"]["uniqueID"], tbl["additionalInfo"]["ItemID"]);
            if notepad then
                notepad:GetData("NotepadTableForMe")["pickup"] = value;
            end;
        end;
    end;

end)

local PLUGIN = PLUGIN;

cable.receive('EditNotepadInfo', function(player, ent, tbl)
    local pages = tbl[1];
    local info = tbl[2]
    for k, v in pairs(pages) do
        pages[k]['info'] = pages[k]['info']:gsub('<', "&lt;" ):gsub('>', '&gt;')
        pages[k]['info'] = pages[k]['info']:gsub("%[(/?)([bius])%]", "<%1%2>"):gsub("%[(/?)(h[r1-3])%]", "<%1%2>")
        pages[k]['info'] = pages[k]['info']:gsub('\n', "<br />")
        pages[k]['info'] = pages[k]['info']:gsub('%[color="(#?[0-9a-zA-Z]+)"%]', '<font color=\\\"%1\\\">' ):gsub("%[/color%]", "</font>")
    end;
    
    if IsEntity( ent ) && ent:GetClass() == 'cw_item' then
        local notepadItem = ent:GetItemTable();
        notepadItem:SetData('Pages', pages)
        notepadItem:SetData('NoteInfo', info)
    elseif istable( ent ) then
        local notepadItem = player:FindItemByID(ent['unique'], ent['itemid'])
        if notepadItem && notepadItem:IsBasedFrom('ross_notepad_base') then
            notepadItem:SetData('Pages', pages)
            notepadItem:SetData('NoteInfo', info)
        end;
    end;

end);

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
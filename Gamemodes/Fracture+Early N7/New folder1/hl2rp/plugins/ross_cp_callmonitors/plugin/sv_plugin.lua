
local PLUGIN = PLUGIN;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

	if (ec == "ross_cp_callmonitor" && entity:GetTurned() == false && arguments == "r_monitor_on") then
        entity:SetTurned(true);
    elseif (ec == "ross_cp_callmonitor" && entity:GetTurned() == true && arguments == "r_monitor_off") then
        entity:SetTurned(false);
    end;

end;

function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
    if (!lightSpawn) then
        local citizenData = player:GetCharacterData("CitizenInfo")
		
        if (!player:HasItemByID("citizen_civ_card") && !player:GetCharacterData("GivenCitizenCard") && !Schema:PlayerIsCombine(player)) then
            player:GiveItem(Clockwork.item:CreateInstance("citizen_civ_card"));
            player:SetCharacterData("GivenCitizenCard", true);
            if player:FindItemByID("citizen_civ_card") then
                player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerName"] = player:Name();
                player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerCID"] = player:GetCharacterData("CitizenID")
                citizenData["parentedCardNumber"] = player:FindItemByID("citizen_civ_card").ItemID;
            end;
        end;
        
	end;
	
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadCPMonitors();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveCPMonitors();
end;


function PLUGIN:SaveCPMonitors()
    local cp_monitor = {}
    
    for k, v in pairs(ents.FindByClass("ross_cp_callmonitor")) do
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
		local mapent = v:IsMapEntity();
		local objval = IsValid(physicsObject);

        if (mapent and startPos) then
            model = nil;
        end;
                    
        if (objval) then
            bMoveable = physicsObject:IsMoveable();
		end;
		
		table.insert(cp_monitor, {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
			isMoveable = bMoveable
		});

    end;
    Clockwork.kernel:SaveSchemaData("plugins/cp_monitors/"..game.GetMap(), cp_monitor);
end;

function PLUGIN:LoadCPMonitors()
	local cp_monitor = Clockwork.kernel:RestoreSchemaData("plugins/cp_monitors/"..game.GetMap());
	
	self.cp_monitor = {};
	
	for k, v in pairs(cp_monitor) do
		if (!v.model) then
			local entity = ents.Create("ross_cp_callmonitor");
			local val = IsValid(entity);
			local ismap = entity:IsMapEntity();
			
			if (val && ismap) then
				self.cp_monitor[entity] = entity;
				local physobj = entity:GetPhysicsObject();
				local objval = IsValid(physobj);
				
				if (objval) then
					if (!v.isMoveable) then
						physobj:EnableMotion(false);
					else
						physobj:EnableMotion(true);
					end;
				end;
				
				if (v.angles) then
					entity:SetAngles(v.angles);
					entity:SetPos(v.position);
				end;
			end;
		else
			local entity = ents.Create("ross_cp_callmonitor");
			local physobj = entity:GetPhysicsObject();
			local objval = IsValid(physobj);
			
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);	
			entity:Spawn();
			
			if (objval) then
				if (!v.isMoveable) then
					physobj:EnableMotion(false);
				end;
			end;
			
			self.cp_monitor[entity] = entity;
		end;
	end;
end;
local PLUGIN = PLUGIN;
local pm = FindMetaTable( "Player" )

function git(entity, call)

	if entity:GetClass() == "cw_item" && entity:IsValid() then
		return entity:GetItemTable()(tostring(call));
	end;

	return nil;
end;

function table.getmax( key, tabletka )

	if type(tabletka) == "table" then
		for k, v in pairs(tabletka) do
			if k == key then
				return v;
			end;
		end;
	end;

	return 0;	
end;

function pm:GiveItemOrDrop( item, ent )
	local invw = self:GetInventoryWeight();
	local maxw = self:GetMaxWeight();

	if self:IsValid() && invw < maxw then
		self:GiveItem(Clockwork.item:CreateInstance(item));
	elseif ent:IsValid() && self:IsValid() && invw >= maxw then
		Clockwork.entity:CreateItem(self, Clockwork.item:CreateInstance(item), ent:GetPos() + Vector(0, 0, 15));
	else
		return false;
	end;

return false;
end;

function pm:NumWeight()
	local invw = self:GetInventoryWeight();
	local maxw = self:GetMaxWeight();

	if self:IsValid() && invw < maxw then
		return true;
	elseif self:IsValid() && invw >= maxw then
		return false;
	else
		return false;
	end;

return false;
end;

function table.SurroundValues(table)
local sum = 0;

	if type(table) == "table" then
		for k, v in pairs(table) do

			if !isnumber(v) then
				return 0;
			end;
			sum = sum + v;
		end;
	end;

return sum;	
end;

function table.SurroundValuesToBools(table)
local sum = 0;

	if type(table) == "table" then
		for k, v in pairs(table) do

			if !isbool(v) || v != true then
				return 0;
			end;
			sum = sum + 1;
		end;
	end;

return sum;	
end;

function pm:DecreaseItem(name, dataname, decrease)
	local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

	if self:HasItemByID(name) then
		for k, v in ipairs(items) do
			if v("uniqueID") == name && type(v("data")[dataname]) == "number" && v("data")[dataname] != 0 then
				v("data")[dataname] = v("data")[dataname] - decrease;
			end;
		end;
	end;

	return 0;
end;

function pm:GetItemData(name, dataname)
	local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

	if self:HasItemByID(name) then
		for k, v in ipairs(items) do
			if v("uniqueID") == name && v("data")[dataname] then
				return v("data")[dataname]
			end;
		end;
	end;
	
	return 0;
end;

function pm:TakeItemCount(id, number)
	for i = 1, number do
		item = self:FindItemByID(id);
		if (item) then 
			self:TakeItem(item); 
		else 
			break; 
		end;
	end;
end;

function GetStuffNear(entity, radius, ent)
	local trace = entity:GetEyeTraceNoCursor();

	for k, v in ipairs( ents.FindInSphere(trace.HitPos, radius) ) do
		if v:IsValid() && v:GetClass() == ent then
			return true
		end;
	end;
	return false;
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)

	sound.Add({
		name = "break_ration",
		channel = CHAN_STATIC,
		volume = 3.0,
		level = 80,
		pitch = { 100, 100 },
		sound = "physics/cardboard/cardboard_box_break1.wav"
  })

	local ec = entity:GetClass();

	if (ec == "ross_fur_base" && entity:GetNWBool("IsFurniture") && arguments == "furn_recipe_collect") then
		player:GiveItemOrDrop( entity:GetNWString("unID"), player )
		for k, v in pairs(entity.blueprintToDo["items"]) do
			for i = 1, v do
				player:GiveItemOrDrop( k, player )
			end;
		end;
		for k, v in pairs(entity.blueprintToDo["instruments"]) do
			for i = 1, v do
				player:GiveItemOrDrop( k, player )
			end;
		end;

		entity:Remove()
	end;

	if (ec == "ross_fur_base" && entity:GetNWBool("IsFurniture") && arguments == "furn_recipe_create" && table.Compare( entity.blueprintToDo, entity.blueprint )) then
		Clockwork.player:SetAction(player, "CreateItem", 6);
			Clockwork.player:EntityConditionTimer(player, entity, entity, 6, 192, function()
				return player:Alive() and !player:IsRagdolled()
			end, function(success)
			if (success) then
				entity:SetMaterial("")
				local physObj = entity:GetPhysicsObject();
	
				if (IsValid(physObj)) then
					physObj:EnableMotion(true);
					physObj:Wake();
				end;
				entity:SetCollisionGroup( 0 );
				entity:SetNWBool("IsFurniture", false);
				entity:SetColor(Color(255, 255, 255))
			end;
	
			Clockwork.player:SetAction(player, "CreateItem", false);
		end);
	end;

	if ec == "ross_furnace" && arguments == "furn_fire_start" && table.Count(entity.cwInventory) > 0 && !entity:GetFired() then
		if !IsValid(entity.light) then
			entity.light = ents.Create("light_dynamic")
			entity.light:SetPos( entity:GetPos() )
			entity.light:SetKeyValue("distance", 400)
			entity.light:SetKeyValue("brightness", 2)
			entity.light:SetKeyValue("_light", "228 170 63 255")
			entity.light:Fire("TurnOn")
			entity.light:SetParent( entity )
			entity.light:Spawn()
			entity.light:Activate()
		end;
		entity:SetFired(true);
		timer.Create("TakeItemEntityPlease", table.Count(entity.cwInventory)*10, 1, function()
			local items = Clockwork.inventory:GetAsItemsList(entity.cwInventory);
			for k, v in pairs(items) do
				if string.StartWith(v("uniqueID"), "fuel_") then
					Clockwork.inventory:RemoveInstance(entity.cwInventory, v)
				end;	
			end;
			entity.light:Remove()
			entity:SetFired(false);
		end);
	end;
	if ec == "ross_furnace" && arguments == "furn_open_pls" && !entity:GetFired() then
		if (!weight) then 
            weight = 10 
        end;	
        if (!entity.cwInventory) then 
            entity.cwInventory = {}; 
        end;
 
		Clockwork.storage:Open(player, {
			name = "Печь",
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
			end
		});		

	end;

	if ec == "ross_ration_crate" && arguments == "open_crate_rations" then
		if (!weight) then 
            weight = 5 
        end;	
        if (!entity.cwInventory) then 
            entity.cwInventory = {}; 
        end;
 
		Clockwork.storage:Open(player, {
			name = "Коробка",
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
				if itemTable("baseItem") != "ration_base" then
					return false;
				end;
			end
		});		

	end;

	if ec == "ross_gas_furnace" && arguments == "take_gas_ballone" && entity:GetGasCan() then
		if player:GetInventoryWeight() + 2 < player:GetMaxWeight() then
			player:GiveItem(Clockwork.item:CreateInstance("gas_fuel_tank", nil, {Fuel = entity:GetFuel()}));
			entity:SetGasCan(false);
			entity:SetFuel(0);
			entity:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")
		elseif player:GetInventoryWeight() + 2 >= player:GetMaxWeight() then
			Clockwork.chatBox:SendColored(player, Color(255, 100, 100), "Вы не можете взять баллон в инвентарь!")
		end;
	end;

	if ec == "ross_gas_furnace" && arguments == "cook_food_gas" then
		local inventories = {}
		for k, v in ipairs(Clockwork.inventory:GetAsItemsList(player:GetInventory())) do
            if v("baseItem") == "food_base" && v("cookingBlueprint") && v:GetData("IsCrafted") == false then
                table.insert(inventories, {
                    uniqueID = v.uniqueID,
                    name = v.name,
                    model = v.model,
                    skin = v.skin,
					itemID = v.itemID,
					cookingBlueprint = v.cookingBlueprint,
					needsList = {
						dhunger = v.hunger,
						dthirst = v.thirst,
						dsleep = v.sleep				
					},
					IsCrafted = v:GetData("IsCrafted")
                })
            end;
		end;
		cable.send(player, 'OpenGasStation', inventories, {entity.konforka2:GetNoDraw(), entity.konforka3:GetNoDraw(), entity.konforka1:GetNoDraw(), entity.konforka4:GetNoDraw(), entity:GetFuel(), entity:GetGasCan()}, entity.inventoryInside, entity)
		
	end;

	if ec == "ross_ration_pack" && arguments == "crack_ration_packet" then
		entity:SetIsBroken(true);
		for k, v in pairs(entity.FoodInside) do
			player:GiveItem(Clockwork.item:CreateInstance(v))
		end;
		player:EmitSound("break_ration")
		entity.FoodInside = {}
	end;

end;

function PLUGIN:PlayerThink(player, curTime, infoTable)

	if (!PLUGIN.RationPhaseTime || curTime >= PLUGIN.RationPhaseTime) then
		
		Clockwork.kernel:SetSharedVar("RationPhase", math.Clamp(Clockwork.kernel:GetSharedVar("RationPhase") - 1, 0, 900))
		PLUGIN.RationPhaseTime = curTime + 1;
	end;

	if (!player.RationGiveTime || curTime >= player.RationGiveTime) then
		if player:HasItemByID("citizen_civ_card") then
			local items = Clockwork.inventory:GetAsItemsList(player:GetInventory());
			for k, v in ipairs(items) do
				if v("uniqueID") == "citizen_civ_card" && v["data"]["CardInformation"]["CooldownRations"] > 0 then
					v["data"]["CardInformation"]["CooldownRations"] = math.Clamp(v["data"]["CardInformation"]["CooldownRations"] - 1, 0, 2600)
				end;
			end;
		end;

		player.RationGiveTime = curTime + 1;
	end;
end;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadFactoryDispenser();
	self:LoadRationDispenser();	

	self:LoadGasFurnace();
	self:LoadTrashBins()
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveFactoryDispenser();
	self:SaveRationDispenser();

	self:SaveGasFurnace();
	self:SaveTrashBins()
end;


function PLUGIN:SaveGasFurnace()
    local gas_furnace = {}
    
    for k, v in pairs(ents.FindByClass("ross_gas_furnace")) do
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
		
		table.insert(gas_furnace, {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
			isMoveable = bMoveable,
			inventoryInside = v.inventoryInside,
			slots = v.slots,
			hasFuel = v:GetGasCan(),
			fuelamount = v:GetFuel()
		});

    end;
    Clockwork.kernel:SaveSchemaData("plugins/gas_furnaces/"..game.GetMap(), gas_furnace);
end;

function PLUGIN:LoadGasFurnace()
	local gas_furnace = Clockwork.kernel:RestoreSchemaData("plugins/gas_furnaces/"..game.GetMap());
	
	self.gas_furnaces = {};
	
	for k, v in pairs(gas_furnace) do
		if (!v.model) then
			local entity = ents.Create("ross_gas_furnace");
			local val = IsValid(entity);
			local ismap = entity:IsMapEntity();
			
			if (val && ismap) then
				self.gas_furnaces[entity] = entity;
				local physobj = entity:GetPhysicsObject();
				local objval = IsValid(physobj);

				entity.inventoryInside = v.inventoryInside;
				entity.slots = v.slots;
				entity:SetGasCan(v.hasFuel);
				entity:SetFuel(v.fuelamount)
				
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
			local entity = ents.Create("ross_gas_furnace");
			local physobj = entity:GetPhysicsObject();
			local objval = IsValid(physobj);
			
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity.inventoryInside = v.inventoryInside;
			entity.slots = v.slots;
			entity:SetGasCan(v.hasFuel);
			entity:SetFuel(v.fuelamount)			
			entity:Spawn();
			
			if (objval) then
				if (!v.isMoveable) then
					physobj:EnableMotion(false);
				end;
			end;
			
			self.gas_furnaces[entity] = entity;
		end;
	end;
end;

function PLUGIN:SaveFactoryDispenser()
    local factory_dispenser = {}
    
    for k, v in pairs(ents.FindByClass("ross_ration_factory")) do
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
    
        if (v:IsMapEntity() and startPos) then
            model = nil;
        end;
                    
        if (IsValid(physicsObject)) then
            bMoveable = physicsObject:IsMoveable();
        end;	
    
        factory_dispenser[#factory_dispenser + 1] = {
			angles = v:GetAngles(),
			spawnItemAngles = v.spawnItem:GetAngles(),
			position = v:GetPos(),
			spawnItemPos = v.spawnItem:GetPos(),
			model = v:GetModel(),
			spawnItemModel = v.spawnItem:GetModel(),
			isMoveable = bMoveable,
			GetRationsInside = v.spawnItem.inside,
			GetTypeInside = v.spawnItem.type,
			GetLevelInside = v.spawnItem.level
        };
    end;
    Clockwork.kernel:SaveSchemaData("plugins/factory_dispenser/"..game.GetMap(), factory_dispenser);
end;
    
function PLUGIN:LoadFactoryDispenser()
        local factory_dispenser = Clockwork.kernel:RestoreSchemaData("plugins/factory_dispenser/"..game.GetMap());
        
        self.factory_dispenser = {};
        
        for k, v in pairs(factory_dispenser) do
            if (!v.model) then
                local entity = ents.Create("ross_ration_factory");
                
                if (IsValid(entity) and entity:IsMapEntity()) then
                    self.factory_dispenser[entity] = entity;
					
					if IsValid(entity.spawnItem) then
						entity.spawnItem:SetPos(v.spawnItemPos)
						entity.spawnItem:SetAngles(v.spawnItemAngles)
						entity.spawnItem:SetModel(v.spawnItemModel)
						entity.spawnItem.inside = v.GetRationsInside
						entity.spawnItem.type = v.GetTypeInside
						entity.spawnItem.level = v.GetLevelInside
					end;
                    
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
                local entity = ents.Create("ross_ration_factory");
                
                entity:SetAngles(v.angles);
                entity:SetModel(v.model);
                entity:SetPos(v.position);
				entity:Spawn();
				if IsValid(entity.spawnItem) then
					entity.spawnItem:SetPos(v.spawnItemPos)
					entity.spawnItem:SetAngles(v.spawnItemAngles)
					entity.spawnItem:SetModel(v.spawnItemModel)
					entity.spawnItem.inside = v.GetRationsInside
					entity.spawnItem.type = v.GetTypeInside
					entity.spawnItem.level = v.GetLevelInside
				end;
                
                if (IsValid(entity:GetPhysicsObject())) then
                    if (!v.isMoveable) then
                        entity:GetPhysicsObject():EnableMotion(false);
                    end;
                end;
                
                self.factory_dispenser[entity] = entity;
            end;
        end;
end;

function PLUGIN:SaveRationDispenser()
    local ration_dispenser = {}
    
    for k, v in pairs(ents.FindByClass("ross_dispenser_food")) do
        local physicsObject = v:GetPhysicsObject();
        local bMoveable = nil;
        local model = v:GetModel();	
    
        if (v:IsMapEntity() and startPos) then
            model = nil;
        end;
                    
        if (IsValid(physicsObject)) then
            bMoveable = physicsObject:IsMoveable();
        end;	
    
        ration_dispenser[#ration_dispenser + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
			isMoveable = bMoveable,
			RationsInside = v.rationsInside,
			TurnRegime = v:GetRegimeTurned()
        };
    end;
    Clockwork.kernel:SaveSchemaData("plugins/ration_dispenser/"..game.GetMap(), ration_dispenser);
end;
    
function PLUGIN:LoadRationDispenser()
        local ration_dispenser = Clockwork.kernel:RestoreSchemaData("plugins/ration_dispenser/"..game.GetMap());
        
        self.ration_dispenser = {};
        
        for k, v in pairs(ration_dispenser) do
            if (!v.model) then
                local entity = ents.Create("ross_dispenser_food");
                
                if (IsValid(entity) and entity:IsMapEntity()) then
                    self.ration_dispenser[entity] = entity;
                    
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
                local entity = ents.Create("ross_dispenser_food");
                
                entity:SetAngles(v.angles);
                entity:SetModel(v.model);
				entity:SetPos(v.position);
				entity:SetRegimeTurned(TurnRegime)
				entity:Spawn();
                
                if (IsValid(entity:GetPhysicsObject())) then
                    if (!v.isMoveable) then
                        entity:GetPhysicsObject():EnableMotion(false);
                    end;
                end;
                
                self.ration_dispenser[entity] = entity;
            end;
        end;
end;

cable.receive('AddItemToRoaster', function(player, choosenItems, data)
	for k, v in pairs(choosenItems) do
		if player:HasItemByID(v.uniqueID, v.itemID) then
				player:TakeItemByID(v.uniqueID, v.itemID)
				data[1].inventoryInside[data[2]][v.itemID] = {
					uniqueID = v.uniqueID,
					name = v.name,
					skin = v.skin,
					model = v.model,
					itemID = v.itemID,
					cookingBlueprint = v.cookingBlueprint,
					needsList = v.needsList,
					IsCrafted = v.IsCrafted
				};
		end;
	end;
end);

cable.receive('ReturnItemToInventory', function(player, entity, data)
	local invw = player:GetInventoryWeight();
	local maxw = player:GetMaxWeight();

	for k, v in pairs(entity.inventoryInside[data[1]]) do
		if v.uniqueID == data[2] && v.itemID == data[3] && (invw + Clockwork.item:FindByID(data[2]).weight) <= maxw then
			local placemodel = "";
			if v.cookingBlueprint[ data[4] ].model == nil || v.cookingBlueprint[ data[4] ].model == "" then
				placemodel = v.model
			elseif v.cookingBlueprint[ data[4] ].model != nil && v.IsCrafted == true then
				placemodel = v.cookingBlueprint[ data[4] ].model
			end;
			entity.inventoryInside[data[1]][k] = nil;
			local item = Clockwork.item:CreateInstance(data[2], data[3]);
			item.model = placemodel;
			item("data").hunger = v.needsList.dhunger;
			item("data").thirst = v.needsList.dthirst;
			item("data").sleep = v.needsList.dsleep;
			item("data").Model = placemodel;
			item("data").IsCrafted = v.IsCrafted;
			player:GiveItem(item);
		end;
	end;
end);

cable.receive('ManipulateConnectedStuff', function(player, entity, type)

	local mins = entity:OBBMins()
	local maxs = entity:OBBMaxs()
	local startpos = entity:GetPos()
	local dir = entity:GetForward()
	local len = 50

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = entity
	} )

	if type == "pan" then
		entity.konforka3:SetNoDraw(true);
		if tr.Hit then
			player:GiveItem(Clockwork.item:CreateInstance("frying_pan"));
		elseif !tr.Hit then
			Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("frying_pan"), startpos + dir * 50);
		end;

		entity.slots['three'] = false;
	elseif type == "pot" then
		entity.konforka2:SetNoDraw(true);
		if tr.Hit then
			player:GiveItem(Clockwork.item:CreateInstance("big_potty"));
		elseif !tr.Hit then
			Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("big_potty"), startpos + dir * 50);
		end;

		entity.slots['two'] = false;
	elseif type == "littlepot" then
		entity.konforka4:SetNoDraw(true);
		if tr.Hit then
			player:GiveItem(Clockwork.item:CreateInstance("little_potty"));
		elseif !tr.Hit then
			Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("little_potty"), startpos + dir * 50);
		end;

		entity.slots['four'] = false;
	elseif type == "teapot" then
		entity.konforka1:SetNoDraw(true);
		if tr.Hit then
			player:GiveItem(Clockwork.item:CreateInstance("tea_pot"));
		elseif !tr.Hit then
			Clockwork.entity:CreateItem(player, Clockwork.item:CreateInstance("tea_pot"), startpos + dir * 50);
		end;

		entity.slots['one'] = false;
	end;

end);

cable.receive('StartCooking', function(player, entity, data)
	local timeToCreate = 5;
	local invw = player:GetInventoryWeight();
	local maxw = player:GetMaxWeight();
	for k, v in pairs(entity.inventoryInside[data[1]]) do
		timeToCreate = timeToCreate + tonumber(v.cookingBlueprint[data[2]]["time"])
	end;

	if entity:GetFuel() == 0 || (entity:GetFuel() - timeToCreate * 5) <= 0 then
		return;
	end;

	Clockwork.player:SetAction(player, "cooking", timeToCreate);
	Clockwork.player:EntityConditionTimer(player, entity, entity, timeToCreate, 192, function()
		if !flameEmitted then
			player:EmitSound("ambient/fire/mtov_flame2.wav")
			flameEmitted = true;
		end;
		if (!nextEmit || CurTime() >= nextEmit) then
				player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 5)..".wav")
	    	nextEmit = CurTime() + 7;
        end;
		return player:Alive() && !player:IsRagdolled() && player:GetSharedVar("IsTied") == 0;
		end, function(success)
		if (success) then
			if IsValid(entity) then
				for k, v in pairs(entity.inventoryInside[data[1]]) do
					if v.IsCrafted == false then
						local placemodel = "";
						local getCook = 0;
						if v.cookingBlueprint[data[2]]["model"] == nil || v.cookingBlueprint[data[2]]["model"] == "" then
							placemodel = v.model
						elseif v.cookingBlueprint[data[2]].model != nil then
							placemodel = v.cookingBlueprint[data[2]].model
						end;

						if GetSkillValue(player, ATB_COOK) < 5 then
							getCook = math.random(-5, GetSkillValue(player, ATB_COOK))
						elseif GetSkillValue(player, ATB_COOK) >= 5 then
							getCook = math.random(1, GetSkillValue(player, ATB_COOK))
						end;

						entity.inventoryInside[data[1]][k] = {
							uniqueID = v.uniqueID,
							name = v.name,
							skin = v.skin,
							itemID = v.itemID,
							cookingBlueprint = v.cookingBlueprint,							
							model = placemodel,
							needsList = {
								dhunger = v.needsList.dhunger + v.cookingBlueprint[data[2]].hun + getCook,
								dthirst = v.needsList.dthirst + v.cookingBlueprint[data[2]].thirst + getCook,
								dsleep = v.needsList.dsleep + v.cookingBlueprint[data[2]].sleep			
							},
							IsCrafted = true;
						};

						entity:SetFuel(math.Clamp(entity:GetFuel() - timeToCreate*5, 0, 1000));

						Clockwork.attributes:Update(player, ATB_COOK, math.random(0.01, 0.1))
					end;
				end;
			end;
		end;

		Clockwork.player:SetAction(player, "cooking", false);
	end);	

end);

cable.receive('UniteFoodUP', function(player, tbl)
	local entity = tbl[1];
	local needsAdd = tbl[2];
	local ItemsChoosen = tbl[3];

	--[[ 
		Check if items is in entity inventory. Else - get out of net.cycle
	--]]
	for k, v in pairs(entity.inventoryInside['pan']) do
		if !table.HasValue(ItemsChoosen, v.itemID) then
			return;
		end;
	end;
	for k, v in pairs(entity.inventoryInside['pot']) do
		if !table.HasValue(ItemsChoosen, v.itemID) then
			return;
		end;
	end;
	for k, v in pairs(entity.inventoryInside['littlepot']) do
		if !table.HasValue(ItemsChoosen, v.itemID) then
			return;
		end;
	end;
	for k, v in pairs(entity.inventoryInside['teapot']) do
		if !table.HasValue(ItemsChoosen, v.itemID) then
			return;
		end;
	end;

	--[[
		If cycles is parsed succesfully - go and take items.
	--]]

	for k, v in pairs(entity.inventoryInside['pan']) do
		if table.HasValue(ItemsChoosen, v.itemID) then
			entity.inventoryInside['pan'][k] = nil;
		end;
	end;

	for k, v in pairs(entity.inventoryInside['pot']) do
		if table.HasValue(ItemsChoosen, v.itemID) then
			entity.inventoryInside['pot'][k] = nil;
		end;
	end;

	for k, v in pairs(entity.inventoryInside['littlepot']) do
		if table.HasValue(ItemsChoosen, v.itemID) then
			entity.inventoryInside['littlepot'][k] = nil;
		end;
	end;

	for k, v in pairs(entity.inventoryInside['teapot']) do
		if table.HasValue(ItemsChoosen, v.itemID) then
			entity.inventoryInside['teapot'][k] = nil;
		end;
	end;

	local item = Clockwork.item:CreateInstance("food_readymeal_cook");
	item("data").hunger = needsAdd['hunger']
	item("data").thirst = needsAdd['thirst']
	item("data").sleep = needsAdd['sleep']
	item("data").IsCrafted = true;

	player:GiveItem(item, true);

end);


function PLUGIN:SaveTrashBins()
    local tb = {}
    
    for k, v in pairs(ents.FindByClass("ross_trash_bin")) do
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
		
		table.insert(tb, {
			angles = v:GetAngles(),
			position = v:GetPos(),
			model = v:GetModel(),
			isMoveable = bMoveable
		});

    end;
    Clockwork.kernel:SaveSchemaData("plugins/tbins/"..game.GetMap(), tb);
end;

function PLUGIN:LoadTrashBins()
	local tb = Clockwork.kernel:RestoreSchemaData("plugins/tbins/"..game.GetMap());
	
	self.tb = {};
	
	for k, v in pairs(tb) do
		if (!v.model) then
			local entity = ents.Create("ross_trash_bin");
			local val = IsValid(entity);
			local ismap = entity:IsMapEntity();
			
			if (val && ismap) then
				self.tb[entity] = entity;
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
			local entity = ents.Create("ross_trash_bin");
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
			
			self.tb[entity] = entity;
		end;
	end;
end;
local PLUGIN = PLUGIN;

function PLUGIN:CanTransferItem(item, old, inv) 
    if inv.vars then
        local findItem = ix.item.Get(inv.vars.isBag);
        if inv.vars.isBag && findItem && tobool(findItem.Isration) && old:GetID() != 0 then
            return false;
        end;
    end;
end

function PLUGIN:CanPlayerHoldObject(client, entity)
	if entity:GetClass() == 'factory_ration' then
		return true
	end
end

function PLUGIN:LoadData()
	self:LoadRationDispensers()
end

function PLUGIN:SaveData()
	self:SaveRationDispensers()
end

function PLUGIN:SaveRationDispensers()
    local data = {
        ['r_rat_1'] = {},
        ['r_rat_2'] = {},
        ['r_rat_3'] = {},
        ['r_ration_dispenser'] = {},
        ['r_garbage_refiner'] = {}
    }
    
    local ration_dispensers = ents.FindByClass("r_ration_dispenser")
    local rrat1 = ents.FindByClass("r_rat_1")
    local rrat2 = ents.FindByClass("r_rat_2")
    local rrat3 = ents.FindByClass("r_rat_3")

    local garbage = ents.FindByClass("r_garbage_refiner")

	for _, v in ipairs(ration_dispensers) do
		data['r_ration_dispenser'][#data['r_ration_dispenser'] + 1] = {
            v:GetPos(), 
            v:GetAngles(),
            v:GetTurned(),
            v:GetLevel(),
            v.rationNext,
            v.RationLoaded
        }
    end
    
    for _, v in ipairs(rrat1) do
		data['r_rat_1'][#data['r_rat_1'] + 1] = {
            v:GetPos(), 
            v:GetAngles(),
            v:GetLevel(),
            v:GetWorkable(),
            v.ingredientsInside
        }
    end
    
    for _, v in ipairs(rrat2) do
		data['r_rat_2'][#data['r_rat_2'] + 1] = {
            v:GetPos(), 
            v:GetAngles(),
            v:GetLevel(),
            v:GetWorkable(),
            v.ingredientsInside
        }
    end
    
    for _, v in ipairs(rrat3) do
		data['r_rat_3'][#data['r_rat_3'] + 1] = {
            v:GetPos(), 
            v:GetAngles(),
            v:GetLevel(),
            v:GetWorkable(),
            v.ingredientsInside
        }
    end
    
    for _, v in ipairs(garbage) do
		data['r_garbage_refiner'][#data['r_garbage_refiner'] + 1] = {
            v:GetPos(), 
            v:GetAngles()
        }
	end

	ix.data.Set("FactoryDispensers", data)
end
function PLUGIN:LoadRationDispensers()
    local factories = ix.data.Get("FactoryDispensers") or {};

    for k, v in pairs(factories['r_ration_dispenser']) do
        local dispenser = ents.Create("r_ration_dispenser")
        dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
        dispenser:Spawn()
        dispenser:SetTurned(v[3])
        dispenser:SetLevel(v[4])
        dispenser.rationNext = v[5]
        dispenser.RationLoaded = v[6]
    end;

    for k, v in pairs(factories['r_rat_1']) do
        local dispenser = ents.Create("r_rat_1")
        dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
        dispenser:Spawn()
        dispenser:SetLevel(v[3])
        dispenser:SetWorkable(v[4])
        dispenser.ingredientsInside = v[5]
    end;

    for k, v in pairs(factories['r_rat_2']) do
        local dispenser = ents.Create("r_rat_2")
        dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
        dispenser:Spawn()
        dispenser:SetLevel(v[3])
        dispenser:SetWorkable(v[4])
        dispenser.ingredientsInside = v[5]
    end;

    for k, v in pairs(factories['r_rat_3']) do
        local dispenser = ents.Create("r_rat_3")
        dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
        dispenser:Spawn()
        dispenser:SetLevel(v[3])
        dispenser:SetWorkable(v[4])
        dispenser.ingredientsInside = v[5]
    end;

    for k, v in pairs(factories['r_garbage_refiner']) do
        local dispenser = ents.Create("r_garbage_refiner")
        dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
        dispenser:Spawn()
    end;
end
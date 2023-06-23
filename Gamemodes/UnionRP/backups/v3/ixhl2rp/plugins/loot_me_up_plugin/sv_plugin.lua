
local PLUGIN = PLUGIN;

netstream.Hook('EditLootableEntity', function(player, entity, tbl)
    if !player:IsAdmin() then
        return;
    end;
    local entinfo = tbl[1]; local itemTables = tbl[2]
    if entinfo['model'] != entity:GetModel() then
        local looter = ents.Create("ross_loot_here");
        looter:SetPos(entity:GetPos());
        looter.informTable = entinfo;
        looter.items = itemTables;
        looter:Spawn();
        entity:Remove()
    else
        entity.informTable = entinfo;
        entity.items = itemTables;

        timer.Adjust(entity:EntIndex()..' - lootProp', entity.informTable['timetoclean'], 0, function()
            if !IsValid(entity) then
                timer.Remove(entity:EntIndex()..' - lootProp')
                return;
            end;
    
            if table.Count(entity.items) == 0 then return end;
    
            entity.itemsInside = {};
        end)

        timer.Adjust(entity:EntIndex()..' - lootProp_2', entity.informTable['timetospawn'], 0, function()
            if !IsValid(entity) then
                timer.Remove(entity:EntIndex()..' - lootProp_2')
                return;
            end;
            if table.Count(entity.items) == 0 then return end;
    
            for k, v in pairs(entity.items) do
                if v == 0 then
                    entity.items[k] = v + 10;
                end;
                if v == 10 then
                    entity.items[k] = entity.items[k] + math.random(1, 5) * 10;
                end;
            end;
            if table.Count(entity.itemsInside) < tonumber(entity.informTable['maxitems']) then
                for k, v in pairs(entity.items) do
                    if math.random(100) <= v then
                        entity.itemsInside[k] = v
                        entity.items[k] = 0;
                    end;
                end;
            end;
        end)
    end;
end);

function PLUGIN:SaveData()
    local data = {}

    for _, entity in ipairs(ents.FindByClass("ross_loot_here")) do
        data[#data + 1] = {
            pos = entity:GetPos(),
            angles = entity:GetAngles(),
            model = entity:GetModel(),
            skin = entity:GetSkin(),
            infoTable = entity.informTable,
            itemList = entity.items
        }
    end

    self:SetData(data)
end

function PLUGIN:LoadData()
    for _, v in ipairs(self:GetData() or {}) do
        local entity = ents.Create("ross_loot_here")
        entity:SetPos(v.pos)
        entity:SetAngles(v.angles)
        entity:Spawn()
        entity:SetModel(v.model)
        entity:SetSkin(v.skin or 0)
        entity:SetSolid(SOLID_BBOX)
        entity:PhysicsInit(SOLID_BBOX)
        local physObj = entity:GetPhysicsObject()
        if (IsValid(physObj)) then
            physObj:EnableMotion(false)
            physObj:Sleep()
        end
        entity.informTable = v.infoTable
        entity.items = v.itemList
    end
end
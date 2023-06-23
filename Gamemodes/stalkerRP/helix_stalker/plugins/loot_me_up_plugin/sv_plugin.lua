
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

local PLUGIN = PLUGIN;

cable.receive('EditLootableEntity', function(player, entity, tbl)
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

function PLUGIN:ClockworkInitPostEntity()
    self:LoadLootEnts();
end;

function PLUGIN:PostSaveData()
    self:SaveLootEnts();
end;

function PLUGIN:SaveLootEnts()
    local tbl = {}
    for k, v in pairs(ents.FindByClass("ross_loot_here")) do
        local mdl = v:GetModel();
        local ang = v:GetAngles();
        local pos = v:GetPos();
        local itemTBL = v.items;
        local settingsTBL = v.informTable
        table.insert(tbl, {
            angles = ang, position = pos, model = mdl, ei = settingsTBL, its = itemTBL
        });
    end;
    Clockwork.kernel:SaveSchemaData("plugins/looter_npcs/"..game.GetMap(), tbl);
end;
    
function PLUGIN:LoadLootEnts()
    local tbl = Clockwork.kernel:RestoreSchemaData("plugins/looter_npcs/"..game.GetMap());
    for k, v in pairs(tbl) do
        local entity = ents.Create("ross_loot_here");      
        entity:SetAngles(v.angles);
        entity:SetModel(v.model);
        entity:SetPos(v.position);
        entity.informTable = v.ei;
        entity.items = v.its;
        entity:Spawn();
    end;
end;
local ITEM = Clockwork.item:New();
ITEM.name = "Спальный мешок";
ITEM.model = "models/frp/props/models/sleeping_bag3.mdl";
ITEM.weight = 1;
ITEM.uniqueID = "sleeping_bag";
ITEM.category = "Прочее";

ITEM:AddData("Packed", true, true)

function ITEM:OnDrop(player, position)
end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local pack = self:GetData("Packed");
    local trace = player:GetEyeTraceNoCursor();
    
    if (option == "Распаковать") then
        entity:Remove();

        local spawnedEnt = scripted_ents.Get("sleeping_bag_unpacked");
        spawnedEnt:SpawnFunction(player, trace)
    end;
    
end;

if CLIENT then

    function ITEM:GetEntityMenuOptions(entity, options)
	    if (!IsValid(entity)) then
    		return;
        end;
        
        options["Распаковать"] = function()
            Clockwork.entity:ForceMenuOption(entity, "Распаковать");
        end;

    end;

end;

ITEM:Register();
local ITEM = Clockwork.item:New();
ITEM.name = "Спальный мешок";
ITEM.model = "models/frp/props/models/sleeping_bag3.mdl";
ITEM.weight = 0.6;
ITEM.uniqueID = "ross_sleepbag";
ITEM.category = "Прочее";

function ITEM:OnDrop(player, position) end;

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local trace = player:GetEyeTraceNoCursor();
    local tr = player:GetEyeTrace();
    local action, percentage = Clockwork.player:GetAction(player, true);

    if (option == "Разложить спальный мешок") then
        local entity2 = ents.Create("prop_physics");
        entity2:SetModel("models/frp/props/models/sleeping_bag1.mdl");
        entity2:SetPos(tr.HitPos + tr.HitNormal);
        entity2:SetAngles(player:GetAngles());
        entity2:SetNWBool("SleepBag", true);
        entity2:Spawn();
        Clockwork.entity:MakeSafe(entity2, true, true, true);
        entity:Remove();
    end;

    
end;

if (CLIENT) then

    function ITEM:GetEntityMenuOptions(entity, options)
		if (!IsValid(entity)) then
			return;
        end;
        
		options["Разложить спальный мешок"] = function()
			Clockwork.entity:ForceMenuOption(entity, "Разложить спальный мешок", nil);
        end;

    end;
    
end;

ITEM:Register();
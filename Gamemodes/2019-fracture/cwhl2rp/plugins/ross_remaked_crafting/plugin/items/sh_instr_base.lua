local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "[База]Инструменты";
ITEM.model = "models/items/largeboxsrounds.mdl";
ITEM.weight = 50;
ITEM.uniqueID = "base_clean_instruments_hi";
ITEM.category = "Прочее";
ITEM.canBeUsed = false;
ITEM.instrumentlvl = 1;

ITEM:AddData("Instruments_Quality", 100, true);

-- 100 - (lvl * 25)

function ITEM:EntityHandleMenuOption(player, entity, option, argument)
    local instrumentsQuality = self:GetData("Instruments_Quality");
    local information = (100 - (self.instrumentlvl * 25));
    local tableItem = {}

    if (option == "Почистить") then

	    for k, v in ipairs( ents.FindInSphere(entity:GetPos(), 30) ) do
            if v:IsValid() && v:GetClass() == "cw_item" && (entity:GetPos():Distance(v:GetPos()) < 30) && git(v, "baseItem") == "weapon_base" && table.Count(tableItem) == 0 then
                if information > (git(v, "data")["Quality"]*10) || instrumentsQuality == 0 then
                    return;
                end;
                tableItem["weapon"] = git(v, "uniqueID")
                Clockwork.player:SetAction(player, "cleanWeapon", 10);
                Clockwork.player:EntityConditionTimer(player, entity, entity, 10, 192, function()
                    return player:Alive() 
                end, function(success)
                    
                    if tableItem["weapon"] == git(v, "uniqueID") then
                        git(v, "data")["Quality"] = math.Clamp(git(v, "data")["Quality"] + 2.5, 0, 10)
                        self:SetData("Instruments_Quality", math.Clamp(instrumentsQuality - 25, 0, 100))
                    end;
        
                    Clockwork.player:SetAction(player, "cleanWeapon", false);
                end);                

		    end;
        end;  
      
    end;
    
end;

if CLIENT then
    function ITEM:GetEntityMenuOptions(entity, options)
	    if (!IsValid(entity)) then
    		return;
        end;
        
    	options["Почистить"] = function()
	    	Clockwork.entity:ForceMenuOption(entity, "Почистить", nil);
        end;

    end;
    function ITEM:OnHUDPaintTargetID(entity, x, y, alpha)
    
        y = Clockwork.kernel:DrawInfo("Осталось использований: "..self:GetData("Instruments_Quality").."\n", x, y, Color(120, 120, 255), alpha);

        return y;
    end;
end;
function ITEM:OnDrop(player, position) end;

ITEM:Register();
local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Вода";
ITEM.model = "models/props_nunk/popcan01a.mdl";
ITEM.weight = 0.4;
ITEM.uniqueID = "drink_dirtywater";
ITEM.foodtype = 2;
ITEM.customFunctions = {"Очистить воду"};
ITEM.hasgarbage = true;

ITEM.portions = 5;
ITEM.dthirst = 5;
ITEM.addDamage = 4;

if (SERVER) then
    function ITEM:OnCustomFunction(player, funcName)
		if (funcName == "Очистить воду" && player:HasItemByID("med_pill") && self:GetData("Damage") > 0) then
            player:TakeItemByID("med_pill");
            self:SetData("Damage", 0);
            self("customFunctions")[1] = nil;
        else
            Clockwork.chatBox:SendColored(player, Color(230, 230, 72), "**Вы ищете по карманам что-нибудь, чем можно очистить воду и не находите.");
        end;   
    end;
end;

ITEM:Register();
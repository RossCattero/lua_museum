local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Окунь";
ITEM.model = "models/foodnhouseholditems/fishbass.mdl";
ITEM.weight = 0.9;
ITEM.uniqueID = "food_fish";
ITEM.foodtype = 1;

ITEM.portions = 3;
ITEM.dhunger = 6;
ITEM.dthirst = -2;
ITEM.addDirt = 2;

ITEM:AddData("Fried", false, true);

if (CLIENT) then
    function ITEM:GetClientSideName()
        if self:GetData("Fried") == true then
            return "Жареный окунь";
        end;
	end;
end;

ITEM:Register();
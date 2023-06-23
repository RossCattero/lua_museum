local ITEM = Clockwork.item:New("food_base");
ITEM.name = "Картофель";
ITEM.model = "models/fallout 3/potato.mdl";
ITEM.weight = 0.5;
ITEM.uniqueID = "food_potato";
ITEM.foodtype = 1;

ITEM.portions = 4;
ITEM.dhunger = 3;
ITEM.addDirt = 5;

ITEM:AddData("Fried", false, true);

if (CLIENT) then
    function ITEM:GetClientSideName()
        if self:GetData("Fried") == true then
            return "Жареный картофель";
        end;
	end;
end;

ITEM:Register();
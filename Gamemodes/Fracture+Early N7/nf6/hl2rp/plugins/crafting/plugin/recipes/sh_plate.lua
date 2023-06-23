local RECIPE = PLUGIN.recipe:New();

RECIPE.name = "Объединить бронепластины"; -- Название.
RECIPE.uniqueID = "rec_plastics"; -- ID.
RECIPE.model = "models/gibs/scanner_gib02.mdl"; -- Модель.
RECIPE.category = "Прочее"; -- Категория.
RECIPE.description = "Объединить пластины."; -- Описание.
RECIPE.ingredients = {["armor_plate"] = 5}; -- Ингридиенты.
RECIPE.result = {["bigplate"] = 1}; -- Результат.
RECIPE.tools = {"ross_pajalnek"}; -- Инструменты(необязательно).
RECIPE.onlyGround = true;

function PLUGIN:PlayerCanCraftRecipe(player, inventory)
    local item = player:FindItemByID("ross_pajalnek");
    if item:GetData("Fuel") == 0 then
        return false;
    end;
    return true;
end;

-- if (SERVER) then
function RECIPE:PlayerCraftRecipe(player)
    local item = player:FindItemByID("ross_pajalnek")
    Clockwork.player:SetAction(player, "Crafting", 10, 3, function()
        self:TakeItems(player);
        self:GiveResults(player);
        item:SetData("Fuel", math.Clamp(item:GetData("Fuel") - 1, 0, 10));
    
        if (self.OnCrafted) then
            self:OnCrafted(player);
        end;
        Clockwork.player:SetAction(player, "Crafting", false);
    end);
end;
-- end;

RECIPE:Register();

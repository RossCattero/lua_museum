
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

PLUGIN.recipe = Clockwork.kernel:NewLibrary("Recipe");
PLUGIN.recipe.stored = {};

--[[
	Begin defining the recipe class base for other recipe's to inherit from.
--]]

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE};

CLASS_TABLE.name = "Recipe Base";
CLASS_TABLE.uniqueID = "recipe_base";
CLASS_TABLE.skin = 0;
CLASS_TABLE.model = "models/error.mdl";
CLASS_TABLE.category = "Other";
CLASS_TABLE.description = "A recipe with no description.";

-- Called when the recipe is converted to a string.
function CLASS_TABLE:__tostring()
	return "RECIPE["..self.name.."]";
end;

--[[
	A function to override an recipe's base data. This is
	just a nicer way to set a value to go along with
	the method of querying.
--]]
function CLASS_TABLE:Override(varName, value)
	self[varName] = value;
end;

-- A function to register a new recipe.
function CLASS_TABLE:Register()
	return PLUGIN.recipe:Register(self);
end;

function CLASS_TABLE:PlayerHasTools(player, inventory)
	if (self.tools) then
		for k, tool in pairs(self.tools) do
			if (!Clockwork.inventory:HasItemByID(inventory, tool)) then
				local item = Clockwork.item:FindByID(tool);

				if (item) then
					return false, "У вас нету "..item("name")..".";
				else
					ErrorNoHalt("[Clockwork] Recipe "..self.name.." has an unexisting tool "..tool.."!\n");
					return false, "У рецепта есть неверный "..tool.."!";
				end;
			end;
		end;
	end;
end;

function CLASS_TABLE:PlayerHasIngredients(player, inventory)
	-- Check for the ingredients
	if (self.ingredients) then
		for ingredient, amount in pairs(self.ingredients) do
			if (type(ingredient) != "string") then
				continue;
			end;
			
			if (!Clockwork.inventory:HasItemByID(inventory, ingredient)) then
				local item = Clockwork.item:FindByID(ingredient);

				if (item) then
					local name = item("name");
					return false, "У вас нету "..name..".";
				else
					ErrorNoHalt("[Clockwork] Recipe "..self.name.." has an unexisting ingredient "..ingredient.."!\n");
					return false, "У рецепта нет игридиента "..ingredient.."!";
				end;
			elseif (table.Count(Clockwork.inventory:GetItemsByID(inventory, ingredient)) < amount) then
				local item = Clockwork.item:FindByID(ingredient);

				if (item) then
					local name = item("name");
					if (amount > 1) then
						name = Clockwork.kernel:Pluralize(name);
					end;
					return false, "Вам нужно не более "..tostring(amount).." "..name..".";
				else
					ErrorNoHalt("[Clockwork] Recipe "..self.name.." has an unexisting ingredient "..ingredient.."!\n");
					return false, "Recipe has unexisting ingredient "..ingredient.."!";
				end;
			end;
		end;
	end;

end;

function CLASS_TABLE:PlayerIsNearStation(player)
	-- Check if player is near a crafting station if needed
	if (self.station) then
		-- Find the entity the player is looking at
		local entity = player:GetEyeTraceNoCursor().Entity;
		local item = Clockwork.item:FindByID(self.station);
		if (!item) then
			ErrorNoHalt("[Clockwork] Recipe "..self.name.." has an unexisting station "..self.station.."!\n");
			return false, "Recipe has unexisting station "..self.station..".";
		end;
		local failReason = "Вы должны быть возле и смотреть на "..item("name");
		
		if (!IsValid(entity)) then
			return false, failReason;
		end;

		if (entity:GetClass() != "cw_item") then
			return false, failReason;
		end;
		
		local itemTable = entity:GetItemTable();
		if (!itemTable or itemTable("uniqueID") != self.station) then
			return false, failReason;
		elseif (player:GetShootPos():DistToSqr(entity:GetPos()) > 10000) then
			return false, failReason;
		end;

		if (self.IsValidCraftingStation) then
			local b, e = self:IsValidCraftingStation(itemTable, entity);
			if (b == false) then
				return b, e;
			end;
		end;
	end;
end;

function CLASS_TABLE:PlayerCanCraftRecipe(player, inventory)
	
	-- Check if the player has all the needed flags
	if (self.flag and !Clockwork.player:HasAnyFlags(player, self.flag)) then
		return false, "У вас нету "..self.flag.." флага.";
	end;

	-- Get the player's inventory in case it is not given yet
	local inventory = inventory or player:GetInventory();

	if (self.tools) then
		-- Check if a player has all the needed tools.
		local bCanCraft, err = self:PlayerHasTools(player, inventory);
		if (bCanCraft == false) then
			return false, err or "У вас нету нужного инструмента.";
		end;
	end;

	if (self.ingredients) then
		-- Check if a player has all the needed ingredients.
		local bCanCraft, err = self:PlayerHasIngredients(player, inventory);
		if (bCanCraft == false) then
			return false, err or "У вас нету нужного ингредиента.";
		end;
	end;

	if (self.station) then
		-- Check if a player has all the needed ingredients.
		local bCanCraft, err = self:PlayerIsNearStation(player);
		if (bCanCraft == false) then
			return false, err or "Вы далеко от станции для крафта.";
		end;
	end;
	
	if (self.PlayerCanCraft) then
		-- Check if a player has all the needed ingredients.
		local bCanCraft, err = self:PlayerCanCraft(player, inventory);
		if (bCanCraft == false) then
			return false, err or "Вы не можете это сделать.";
		end;
	end;
	
	return true;
end;

if (SERVER) then

	function CLASS_TABLE:TakeLyingItems(player)
		local trace = player:GetEyeTraceNoCursor()
		local itemInfo = {};

		for k, v in ipairs( ents.FindInSphere(trace.HitPos, 30) ) do
			if v:IsValid() && v:GetClass() == "cw_item" then
				itemInfo[git(v, "itemID")] = git(v, "uniqueID");
			end;
		end;

	end;

	function CLASS_TABLE:GetLyingItems(player)
		local trace = player:GetEyeTraceNoCursor()
		local itemInfo = {};

		for k, v in ipairs( ents.FindInSphere(trace.HitPos, 30) ) do
			if v:IsValid() && v:GetClass() == "cw_item" then
				itemInfo[git(v, "itemID")] = git(v, "uniqueID");
			end;
		end;

		PrintTable(itemInfo)
	end;

	function CLASS_TABLE:TakeItems(player)
		-- Take all the ingredients
		local item = nil
		for ingredient, amount in pairs(self.ingredients) do
			if (type(ingredient) != "string") then
				continue;
			end;

			for i = 1, amount do
				item = player:FindItemByID(ingredient);
				if (item) then player:TakeItem(item); else break; end;
			end;
		end;
	end;

	function CLASS_TABLE:GiveResults(player)
		-- Give the result
		for result, amount in pairs(self.result) do
			if (type(result) != "string") then
				continue;
			end;

			local actualAmount;
			if (type(amount) == "table") then
				actualAmount = amount[math.random(1, #amount)];
			else
				actualAmount = amount;
			end;

			for i = 1, actualAmount do
				local itemTable = Clockwork.item:CreateInstance(result);
				if (itemTable) then player:GiveItem(itemTable, true); else break; end;
			end;
		end;
	end;

	function CLASS_TABLE:PlayerCraftRecipe(player)
		if !self.onlyGround then
			self:TakeItems(player);
			self:GiveResults(player);

			if self.AttrbuteInc then
				Clockwork.attributes:Update(entity, ATB_COLLECTING, self.AttrbuteInc);
			else
				Clockwork.attributes:Update(entity, ATB_COLLECTING, 0.2);
			end;

			if (self.OnCrafted) then
				self:OnCrafted(player);
			end;
		elseif self.onlyGround then
			player:GetLyingItems()
		end;
	end;
end;

--[[
	End defining the base recipe class.
	Begin defining the recipe utility functions.
--]]

-- A function to get all recipes.
function PLUGIN.recipe:GetAll()
	return self.stored;
end;

-- A function to get a new recipe.
function PLUGIN.recipe:New(recipe)
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE);
	return object;
end;

-- A function to register a new recipe.
function PLUGIN.recipe:Register(recipe)
	recipe.uniqueID = string.lower(string.gsub(recipe.uniqueID or string.gsub(recipe.name, "%s", "_"), "['%.]", ""));
	self.stored[recipe.uniqueID] = recipe;
	
	if (recipe.model) then
		util.PrecacheModel(recipe.model);
		
		if (SERVER) then
			Clockwork.kernel:AddFile(recipe.model);
		end;
	end;
end;

-- A function to get an recipe by its name.
function PLUGIN.recipe:FindByID(identifier)
	if (identifier and identifier != 0 and type(identifier) != "boolean") then
		if (self.stored[identifier]) then
			return self.stored[identifier];
		end;
		
		local lowerName = string.lower(identifier);
		local recipe = nil;
		
		for k, v in pairs(self.stored) do
			local recipeName = v.name;
			
			if (string.find(string.lower(recipeName), lowerName)
			and (!recipe or string.len(recipeName) < string.len(recipe.name))) then
				recipe = v;
			end;
		end;
		
		return recipe;
	end;
end;

function PLUGIN.recipe:Initialize()
	local recipes = self:GetAll();

	for k, v in pairs(recipes) do
		if (v.OnSetup) then 
			v:OnSetup(); 
		end;
		
		Clockwork.plugin:Call("ClockworkRecipeInitialized", v);
	end;
end;

-- Called when a player attempts to craft an item.
function PLUGIN.recipe:PlayerCanCraftRecipe(recipe, player, inventory)
	return recipe:PlayerCanCraftRecipe(player, inventory);
end;

if (CLIENT) then
	function PLUGIN.recipe:GetIconInfo(recipe)
		local model = recipe.model or "models/error.mdl";
		local skin = recipe.skin;
		
		return model, skin;
	end;

	local function getMinMax(table)
		local min, max = table[1], table[1];
		for i = 2, #table do
			if (table[i] < min) then
				min = table[i];
			elseif (table[i] > max) then
				max = table[i];
			end;
		end;
		return min, max;
	end;
	
	-- A function to get a recipe's markup tooltip.
	function PLUGIN.recipe:GetMarkupToolTip(recipe)
		if (recipe.GetMarkupToolTip) then
			return recipe:GetMarkupToolTip();
		end;

		local informationColor = Clockwork.option:GetColor("information");

		local toolTipTitle = "["..recipe.name.."]";
		
		toolTipTitle = Clockwork.kernel:MarkupTextWithColor(toolTipTitle, informationColor);
		
		toolTipTitle = toolTipTitle.."\n"..Clockwork.config:Parse(recipe.description);

		toolTipTitle = toolTipTitle.."\n"..Clockwork.kernel:MarkupTextWithColor("[Необходимо]", informationColor);

		-- Temporary value to use
		local name;
		-- Add needed tools
		if (recipe.tools) then
			for k, item in pairs(recipe.tools) do
				name = "";
				local tool = Clockwork.item:FindByID(item);

				if (tool) then
					name = tool("name");
				else
					name = item.." (Предмет не найден!)";
				end;

				toolTipTitle = toolTipTitle.."\n-"..name;
			end;
		end;
		-- Add needed crafting station
		if (recipe.station) then
			name = "";

			local station = Clockwork.item:FindByID(recipe.station);

			if (station) then
				name = station("name");
			else
				name = recipe.station.." (Предмет не может быть найден!)";
			end;

			toolTipTitle = toolTipTitle.."\n-"..name;
		end;
		-- Add ingredients
		for item, amount in pairs(recipe.ingredients) do
			if (type(item) != "string") then
				continue;
			end;
			
			name = "";

			local ingredient = Clockwork.item:FindByID(item);

			if (ingredient) then
				name = ingredient("name");
			else
				name = item.." (Предмет не может быть найден!)";
			end;

			toolTipTitle = toolTipTitle.."\n"..amount.."x "..name;
		end;

		toolTipTitle = toolTipTitle.."\n"..Clockwork.kernel:MarkupTextWithColor("[Результат]", informationColor);
		-- Add ingredients
		for item, amount in pairs(recipe.result) do
			if (type(item) != "string") then
				continue;
			end;

			name = "";

			local result = Clockwork.item:FindByID(item);

			if (result) then
				name = result("name");
			else
				name = item.." (Предмет не может быть найден!)";
			end;

			local amountText = "";
			if (type(amount) == "table") then
				local min, max = getMinMax(amount);
				amountText = min.."-"..max;
			else
				amountText = amount;
			end;

			toolTipTitle = toolTipTitle.."\n"..amountText.."x "..name;
		end;
		
		toolTipTitle = toolTipTitle.."\n"..Clockwork.kernel:MarkupTextWithColor("[Категория]", informationColor);
		toolTipTitle = toolTipTitle.."\n"..recipe.category;

		if recipe.onlyGround then
			toolTipTitle = toolTipTitle.."\n"..Clockwork.kernel:MarkupTextWithColor("[ТОЛЬКО С ПОЛА!]", Color(255, 100, 100));
		end;
		
		return toolTipTitle;
	end;

	function PLUGIN.recipe:CanPlayerSeeRecipe(recipe)
		--[[if (recipe.flag and !Clockwork.player:HasAnyFlags(Clockwork.Client, recipe.flag)) then
			return false;
		end;]]
		
		if (recipe.CanPlayerSee) then
			return recipe:CanPlayerSee(Clockwork.Client);
		end;

		return true;
	end;
else
	function PLUGIN.recipe:PlayerCraftRecipe(recipe, player)
		local bCanCraftRecipe, err = recipe:PlayerCanCraftRecipe(player);
		if (!bCanCraftRecipe) then
			if (!err) then
				err = "Вы не можете это создать!";
			end;
			Clockwork.player:Notify(player, err);
			return false;
		end;

		local success, err = recipe:PlayerCraftRecipe(player);
		if (success != false) then
			-- Set the player's next crafting time
			player.cwNextCraftTime = CurTime() + 2;
			Clockwork.datastream:Start(player, "CraftTime", player.cwNextCraftTime);
			-- Print log
			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has crafted the "..recipe.name.." recipe.");
		elseif (err) then
			Clockwork.player:Notify(player, err);
		end;
	end;
end;

for k, v in pairs(file.Find(Clockwork.kernel:GetSchemaFolder().."/plugins/crafting/plugin/recipes/*.lua", "LUA", "namedesc")) do
	Clockwork.kernel:IncludePrefixed(Clockwork.kernel:GetSchemaFolder().."/plugins/crafting/plugin/recipes/"..v);
end;
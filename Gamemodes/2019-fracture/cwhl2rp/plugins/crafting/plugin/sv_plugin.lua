local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:Add("crafting_menu", false, true);

Clockwork.datastream:Hook("CraftRecipe", function(player, data)
	local recipe = PLUGIN.recipe:FindByID(data);
	if (!recipe) then
		return;
	end;

	local bPlayerCanCraft, err = PLUGIN:PlayerCanCraft(player);
	if (!bPlayerCanCraft) then
		if (!err) then
			err = "You cannot craft right now (but a Dev fucked up and forgot to add in why)!";
		end;
		Clockwork.player:Notify(player, err);
		return false;
	end;

		PLUGIN.recipe:PlayerCraftRecipe(recipe, player);
end);

function PLUGIN:PlayerCanCraft(player)
	-- Check if the player has waited long enough for the next craft time
	local curTime = CurTime();
	if (player.cwNextCraftTime and curTime < player.cwNextCraftTime) then
		return false, "Вам нужно подождать еще "..tostring(player.cwNextCraftTime - curTime).." секунд(ы).";
	end;

	return true;
end;

-- Called when a player's crafted item should be adjusted.
function PLUGIN:PlayerAdjustCraftRecipe(player, recipe) end;
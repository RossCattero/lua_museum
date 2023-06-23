local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

Clockwork.option:SetKey("name_crafting", "Крафтинг");
Clockwork.option:SetKey("description_crafting", "Комбинируйте предметы и получайте что-то новое.");

--[[-- Called when the Clockwork shared variables are added.
function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("cancraftchem");
	playerVars:Bool("cancraftweapons");
	playerVars:Bool("cancraftmate");
	playerVars:Bool("craftingwardore");
	playerVars:Bool("cancraftarmor");	
	playerVars:Bool("cancraftfood");	
end;

function RECIPE:PlayerCanCraftRecipe(player, inventory)
	if (player:GetSharedVar("") == false) then
		Clockwork.chatBox:SendColored(player, Color(200, 0, 0), "Вы не знаете, как сделать этот рецепт!");
   return false
end;
    return true
end;
]]


Clockwork.config:ShareKey("craftin_menu");
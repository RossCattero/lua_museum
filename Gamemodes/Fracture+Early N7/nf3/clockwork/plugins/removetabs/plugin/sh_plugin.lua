local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the menu's items should be destroyed.
function PLUGIN:MenuItemsDestroy(menuItems)
	if (CLIENT) then
		menuItems:Destroy("Community"); -- C16 is love, C16 is life... NOT
		menuItems:Destroy("Attributes");
		menuItems:Destroy("Classes");
		menuItems:Destroy("Donations"); 
		menuItems:Destroy("Community");
		menuItems:Destroy("Сообщество");
		menuItems:Destroy("Классы");
		menuItems:Destroy("Бизнес");
		menuItems:Destroy("Business");
		menuItems:Destroy("Plugin Center");
		 menuItems:Destroy("Плагины");
		 menuItems:Destroy("Атрибуты");
	end;
end;
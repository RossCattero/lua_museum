local PLUGIN = PLUGIN;
local icons = {
	["Ammunition"] = "briefcase",
	["Clothing"] = "user_suit",
	["Communication"] = "telephone",
	["Consumables"] = "cake",
	["Crafting Resource"] = "cog",
	["Crafting Station"] = "cog",
	["Crafting"] = "cog",
	["Deployables"] = "arrow_down",
	["Filters"] = "weather_clouds",
	["Junk"] = "box",
	["Lights"] = "lightbulb",
	["Literature"] = "book",
	["Medical"] = "heart",
	["Melee Weapons"] = "bomb",
	["Other"] = "brick",
	["Promotional"] = "coins",
	["Reusables"] = "arrow_rotate_clockwise",
	["Storage"] = "package",
	["Tools"] = "wrench",
	["Turret"] = "gun",
	["UU-Branded Items"] = "asterisk_yellow",
	["Weapons"] = "gun",
	["Workstations"] = "page",
};

spawnmenu.AddContentType("cwItem", function(container, data)
	if (!data.name) then return; end;

	local icon = vgui.Create("ContentIcon", container);

	icon:SetContentType("cwItem");
	icon:SetSpawnName(data.uniqueID);
	icon:SetName(data.name);

	function icon:DoClick()
		Clockwork.datastream:Start("MenuItemSpawn", data.uniqueID);
		surface.PlaySound("ui/buttonclickrelease.wav");
	end;

	function icon:OpenMenu()
		local menu = DermaMenu();
		menu:AddOption("Скопировать идентификатор", function()
			SetClipboardText(data.uniqueID);
		end);

		menu:AddOption("Выдать себе 1 шт.", function()
			Clockwork.datastream:Start("MenuItemGive", data.uniqueID);
		end);

		menu:AddOption("Выдать себе 5 шт.", function()
			Clockwork.datastream:Start("MenuItemGivex5", data.uniqueID);
		end);

		menu:Open();
	end;

	if (IsValid(container)) then
		container:Add(icon);
	end;
end);

spawnmenu.AddCreationTab("Items", function()
	local base = vgui.Create("SpawnmenuContentPanel");
	local tree = base.ContentNavBar.Tree;
	local categories = {};

	vgui.Create("ItemSearchBar", base.ContentNavBar);

	for k, v in SortedPairsByMemberValue(Clockwork.item.stored, "category") do
		if !v.isBaseItem then
			if (!categories[v.category]) then
				categories[v.category] = true;

				local category = tree:AddNode(v.category, icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png");

				category.DoPopulate = function(self)
					if (self.Container) then return; end;

					self.Container = vgui.Create("ContentContainer", base);
					self.Container:SetVisible(false)
					self.Container:SetTriggerSpawnlistChange(false);

					for uniqueID, itemTable in SortedPairsByMemberValue(Clockwork.item.stored, "name") do
						if (itemTable.category == v.category) then
							spawnmenu.CreateContentIcon("cwItem", self.Container, itemTable);
						end;
					end;
				end;

				category.DoClick = function(self)
					self:DoPopulate();
					base:SwitchPanel(self.Container);
				end;
			end;
		end
	end;

	local FirstNode = tree:Root():GetChildNode(0);

	if (IsValid(FirstNode)) then
		FirstNode:InternalDoClick();
	end;

	PLUGIN:PopulateContent(base, tree, nil);

	return base;
end,

"icon16/script_key.png");
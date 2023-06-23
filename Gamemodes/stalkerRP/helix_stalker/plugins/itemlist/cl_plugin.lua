local PLUGIN = PLUGIN

local icons = {
	["Ammunition"] = "attach",
	["Armored Clothing"] = "shield",
	["Cards"] = "vcard",
	["Clothing"] = "user_suit",
	["Communication"] = "transmit",
	["Consumables"] = "cake",
	["Crafting"] = "add",
	["Deployables"] = "arrow_down",
	["Filters"] = "weather_clouds",
	["Gasmasks"] = "user_gray",
	["Ingredients"] = "package_add",
	["Junk"] = "bin_closed",
	["Literature"] = "book",
	["Medical"] = "heart_add",
	["Miscellaneous"] = "box",
	["Outfit"] = "user_add",
	["Permits"] = "report",
	["Raw Materials"] = "cog",
	["Remains"] = "bullet_red",
	["Reusables"] = "arrow_rotate_clockwise",
	["Storage"] = "briefcase",
	["Union Branded Items"] = "asterisk_yellow",
	["Tools"] = "wrench_orange",
	["Weapons"] = "gun"
}

spawnmenu.AddContentType("ixItem", function(container, data)
	if (!data.name) then return end

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("ixItem")
	icon:SetSpawnName(data.uniqueID)
	icon:SetName(data.name)

	function icon:DoClick()
		netstream.Start("MenuItemSpawn", data.uniqueID)
		surface.PlaySound("ui/buttonclickrelease.wav")
	end

	function icon:OpenMenu()
		local menu = DermaMenu()

		menu:AddOption("Copy to Clipboard", function()
			SetClipboardText(data.uniqueID)
		end)

		menu:AddOption("Give to Self", function()
			netstream.Start("MenuItemGive", data.uniqueID)
		end)

		menu:Open()
	end

	if (IsValid(container)) then
		container:Add(icon)
	end
end)

spawnmenu.AddCreationTab("Items", function()
	local base = vgui.Create("SpawnmenuContentPanel")
	local tree = base.ContentNavBar.Tree
	local categories = {}

	vgui.Create("ItemSearchBar", base.ContentNavBar)

	for _, v in SortedPairsByMemberValue(ix.item.list, "category") do
		if (!categories[v.category]) then
			categories[v.category] = true

			local node = tree:AddNode(L(v.category), icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png")

			node.DoPopulate = function(self)
				if (self.Container) then return end

				self.Container = vgui.Create("ContentContainer", base)
				self.Container:SetVisible(false)
				self.Container:SetTriggerSpawnlistChange(false)

				for _, itemTable in SortedPairsByMemberValue(ix.item.list, "name") do
					if (itemTable.category == v.category) then
						spawnmenu.CreateContentIcon("ixItem", self.Container, itemTable)
					end
				end
			end

			node.DoClick = function(self)
				self:DoPopulate()
				base:SwitchPanel(self.Container)
			end
		end
	end

	local FirstNode = tree:Root():GetChildNode(0)

	if (IsValid(FirstNode)) then
		FirstNode:InternalDoClick()
	end

	PLUGIN:PopulateContent(base, tree, nil)

	return base
end, "icon16/script_key.png")

timer.Simple(0, function()
	RunConsoleCommand("spawnmenu_reload")
end)



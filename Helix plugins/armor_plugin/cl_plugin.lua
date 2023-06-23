local PLUGIN = PLUGIN;

hook.Add("CreateMenuButtons", "rossArmorPlugin", function(tabs)
		tabs["armor"] = {
		bHideBackground = false,
		Create = function(info, container)
			container.infoPanel = container:Add("CheckArmor")
			container.infoPanel:Populate()

			INT_armor = container.infoPanel
			INT_armor:UpdateClothes()
		end
	}
end)

netstream.Hook('armor::SyncEdits', function()
		if INT_armor && INT_armor:IsValid() then
			INT_armor:UpdateClothes()
		end;
end);
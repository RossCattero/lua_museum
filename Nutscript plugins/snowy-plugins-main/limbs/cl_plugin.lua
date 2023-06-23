local PLUGIN = PLUGIN;

function PLUGIN:CreateMenuButtons(tabs)
		tabs["Limbs"] = function(panel)
				if PLUGIN.health && PLUGIN.health:IsValid() then
						PLUGIN.health:Close();
				end
				PLUGIN.health = vgui.Create("HealthPanel", panel)
				PLUGIN.health:Populate()
		end
end;
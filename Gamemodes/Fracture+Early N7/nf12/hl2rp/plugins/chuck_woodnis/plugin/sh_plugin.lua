--[[
	© 2016 Mr. Meow
	Like, feel free to do stuff with my code I guess?
--]]

function PLUGIN:ClockworkInitPostEntity()
	timer.Simple(1, function()
		if (!WoodDamageFilter) then
			WoodDamageFilter = ents.Create("filter_activator_name");
				WoodDamageFilter:SetKeyValue("targetname", "woodnorris");
				WoodDamageFilter:SetKeyValue("negated", "1");
			WoodDamageFilter:Spawn();
		end;

		for k, v in pairs(ents.GetAll()) do
			local model = v:GetModel();

			if (model) then model = model:lower(); end;

			if (!v:IsPlayer() and model and (model:find("wood") or model:find("table") or model:find("bench")
			or model:find("table") or model:find("chair") or model:find("box") or model:find("cardboard")
			or model:find("pallet") or model:find("models/props_wasteland/dockplank01b.mdl") or model:find(" models/props_c17/FurnitureDrawer003a.mdl"))) then
				v:Fire("setdamagefilter", "woodnorris", 0);
			end;
		end;
	end);
end;
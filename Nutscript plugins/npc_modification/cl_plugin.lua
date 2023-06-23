local PLUGIN = PLUGIN;

function PLUGIN:PlayerBindPress(client, bind, pressed)
	bind = bind:lower()

	if (pressed && client:IsAdmin() && (bind:find("use") or bind:find("attack"))) then
		local menu, callback = nut.menu.getActiveMenu()

		if (menu and nut.menu.onButtonPressed(menu, callback)) then
			return true

		elseif (bind:find("use") and pressed) then
			local data = {}
				data.start = client:GetShootPos()
				data.endpos = data.start + client:GetAimVector()*96
				data.filter = client
			local trace = util.TraceLine(data)

			local entity = trace.Entity
			if ( IsValid(entity) and entity.Base == "base_ross_npc" ) then
				nut.menu.list = {}

				local options = {};
				options["Open settings"] = function()
					if nut.rossnpcs.derma && nut.rossnpcs.derma:IsValid() then
						nut.rossnpcs.derma:Close()
					end

					nut.rossnpcs.derma = vgui.Create("NPCSettings")
					nut.rossnpcs.derma:Populate( entity:EntIndex(), entity:getNetVar("data") )
				end;
				if entity.optionsList then
					for k, v in pairs( entity.optionsList ) do
						options[ k ] = v;
					end;
				end;
				nut.menu.add(options, entity)					
			end
		end
	end;
end
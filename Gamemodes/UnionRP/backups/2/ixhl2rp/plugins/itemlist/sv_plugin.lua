netstream.Hook("MenuItemSpawn", function(client, data, class)
	if #data <= 0 then return end
	if (!client:IsAdmin()) then
		client:Notify("Вы не можете это делать!")
		return
	end
	if ix.item.list[data].base == "bags" then
		client:Notify("Рюкзак нельзя заспавнить в world!")
		return
	end

	local itemTable = ix.item.Get(data)
	if itemTable then
		client:Notify("Вы заспавнили "..itemTable.name..".")
		local vStart = client:GetShootPos()
		local vForward = client:GetAimVector()
		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + (vForward * 2048)
		trace.filter = client

		local tr = util.TraceLine(trace)
		local ang = client:EyeAngles()
		ang.yaw = ang.yaw + 180
		ang.roll = 0
		ang.pitch = 0
		
		local ent = ix.item.Spawn(data, tr.HitPos, nil, ang)
	end
end)

netstream.Hook("MenuItemGive", function(client, data, class)
	if #data <= 0 then return end
	if (!client:IsSuperAdmin()) then
		client:Notify("Вы не можете это делать!")
		return
	end

	local itemTable = ix.item.Get(data)
	if itemTable then
		--client:Notify("You have spawned a "..itemTable("name")..".")
		client:Notify("Вы выдали себе "..itemTable.name..".")
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		inventory:Add(data)
	end
end)
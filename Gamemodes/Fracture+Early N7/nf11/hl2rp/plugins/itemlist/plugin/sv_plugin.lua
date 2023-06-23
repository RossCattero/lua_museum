Clockwork.datastream:Hook("MenuItemSpawn", function(player, data)
	if #data <= 0 then return end
	if !Clockwork.player:HasFlags(player, "G") then
		return
	end
	local itemTable = Clockwork.item:FindByID(data)
	if itemTable then
		local vStart = player:GetShootPos()
		local vForward = player:GetAimVector()
		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + (vForward * 2048)
		trace.filter = player

		local tr = util.TraceLine(trace)
		local ang = player:EyeAngles()
		ang.yaw = ang.yaw + 180
		ang.roll = 0
		ang.pitch = 0
		local ent = Clockwork.entity:CreateItem(nil, data, tr.HitPos, ang)
		if !IsValid(ent) then 
			return 
		end

		Clockwork.player:Notify(player, "Вы создали "..itemTable("name")..".");
	end
end)
Clockwork.datastream:Hook("MenuItemGive", function(player, data)
	if #data <= 0 then return end
	if !Clockwork.player:HasFlags(player, "G") then
		return
	end

	local itemTable = Clockwork.item:FindByID(data)
	if itemTable then
		local item = Clockwork.item:CreateInstance(data);
		local bSuccess, fault = player:GiveItem(item, true);

		if !bSuccess then
			Clockwork.player:Notify(player, fault)
			return
		end

		Clockwork.player:Notify(player, "Вы выдали "..player:Name().."  "..itemTable("name")..".");
	end;
end)
Clockwork.datastream:Hook("MenuItemGivex5", function(player, data)
	if #data <= 0 then return end
	if !Clockwork.player:HasFlags(player, "G") then
		return
	end

	local itemTable = Clockwork.item:FindByID(data)
	for i = 1, 5 do
		if itemTable then
			local item = Clockwork.item:CreateInstance(data);
			local bSuccess, fault = player:GiveItem(item, true);

			if !bSuccess then
				Clockwork.player:Notify(player, fault)
				return
			end
		end;
	end;
	Clockwork.player:Notify(player, "Вы выдали "..player:Name().."  "..itemTable("name").." в количестве пяти штук.");
end)
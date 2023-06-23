netstream.Hook("nut.loyalty.sync", function(data)
	if !nut.loyalty.instances[data.charID] then
		nut.loyalty.Instance(data.charID, data)
	else
		for k, v in pairs(data) do
			if nut.loyalty.instances[data.charID][k] then
				nut.loyalty.instances[data.charID][k] = v;
			end;
		end;
	end;
end)

netstream.Hook("nut.loyalty.syncAll", function(data)
	nut.loyalty.instances = data;
end)

timer.Create("nut.loyalty.garbageCollect", 0, 300, function()
	for k, v in pairs(nut.loyalty.instances) do
		if !nut.char.loaded[k] then
			nut.loyalty.instances[k] = nil;
		end;
	end;
end)
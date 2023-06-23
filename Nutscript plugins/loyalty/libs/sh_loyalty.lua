nut.loyalty = nut.loyalty or {};
nut.loyalty.instances = nut.loyalty.instances or {};
nut.loyalty.tier = nut.loyalty.tier or {};
nut.loyalty.tier.list = nut.loyalty.tier.list or {};

function nut.loyalty.New(id, data)
	local loyalty = setmetatable({}, nut.meta.loyalty)
		loyalty.charID = id or 0
		if data then
			for k, v in pairs(data) do
				if v != nil then
					loyalty[k] = v;
				end;
			end;
		end;
	
	return loyalty
end

function nut.loyalty.Instance(id, data)
	if !data then data = {} end;
	data.points = data.points or 0;
	data.maxPoints = data.maxPoints or 1000;
	data.tier = data.tier or 0;
	
	nut.loyalty.instances[ id ] = nut.loyalty.New(id, data)
end;

function nut.loyalty.Remove( id )
	if nut.loyalty.instances[ id ] then
		nut.loyalty.instances[ id ] = nil;
	end;
end;

function nut.loyalty.Sync( client )
	if client && client.getChar() then
		netstream.Start(client, "nut.loyalty.syncAll", nut.loyalty.instances)
	end;
end;

function nut.loyalty.tier.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		nut.loyalty.tier.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function nut.loyalty.tier.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	tier = setmetatable({}, nut.meta.tier)

	if (path) then nut.util.include(path) end
	nut.loyalty.tier.list[ string.lower(uniqueID) ] = tier;

	tier = nil
end
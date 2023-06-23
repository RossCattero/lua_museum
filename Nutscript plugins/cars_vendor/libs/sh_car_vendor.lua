nut.car_vendor = nut.car_vendor or {}
nut.car_vendor.list = nut.car_vendor.list or {}
nut.car_vendor.ilist = nut.car_vendor.ilist or {}
nut.car_vendor.instances = nut.car_vendor.instances or {}

function nut.car_vendor.Load(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		nut.car_vendor.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function nut.car_vendor.Register(uniqueID, path)
	if (uniqueID) then
		car = nut.car_vendor.list[uniqueID] or setmetatable({}, nut.meta.car)
			car.id = car.id or (#nut.car_vendor.ilist + 1)
			car.uniqueID = uniqueID;
			car.name = car.name or "unknown";
			car.price = car.price or 100;
			car.baggageW = car.baggageW or 10;
			car.baggageH = car.baggageH or 10;
			
			if (path) then nut.util.include(path) end;

			nut.car_vendor.list[uniqueID] = car;
			nut.car_vendor.ilist[car.id] = uniqueID;
		car = nil;
	end;
end

function nut.car_vendor.New(uniqueID, charID)
	local instance = nut.car_vendor.instances[charID]
	if (instance and instance.uniqueID == uniqueID) then
		return instance
	end

	local Car = nut.car_vendor.list[uniqueID]
	if (Car) then
		local car = setmetatable({uniqueID = uniqueID, charID = charID}, {
			__index = Car,
			__eq = Car.__eq,
			__tostring = Car.__tostring
		})
		nut.car_vendor.instances[charID] = car;

		return car
	end
end

function nut.car_vendor.Get( id )
	local uniqueID = nut.car_vendor.ilist[id]
	return uniqueID && nut.car_vendor.list[ uniqueID ];
end;

function nut.car_vendor.Instance(charID, uniqueID, carEntity)
	local car = nut.car_vendor.New(uniqueID, charID)
	car.charID = charID;
	car.carEntity = carEntity;

	return car;
end;

function nut.car_vendor.CanAfford( uniqueID, amount )
	local vendor = nut.car_vendor.list[uniqueID];
	return vendor && vendor.price <= amount;
end;

function nut.car_vendor.FindFreeSpace(entity, mins, maxs)
	local space = {
		["right"] = {
			side = entity:GetRight(),
		},
		["left"] = {
			side = -entity:GetRight(),
		},
		["forward"] = {
			side = entity:GetForward(),
		},
		["back"] = {
			side = -entity:GetForward(),
		}
	}
	for k, v in pairs(space) do
		local position = entity:GetPos() + v.side * 144
		local trace = util.TraceHull({
			start = position,
			endpos = position,
			mins = mins,
			maxs = maxs,
			filter = {entity}
		})

		if !trace.Hit then
			return trace, k;
		end
	end;
end;
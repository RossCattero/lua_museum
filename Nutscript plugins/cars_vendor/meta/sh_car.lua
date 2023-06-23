local car = nut.meta.car or {}

car.__index = car

car.charID = 0;
car.uniqueID = "nil";

car.name = "unknown"
car.price = 100;
car.carEntity = NULL;
car.baggageW = 10;
car.baggageH = 10;

function car:__tostring()
	return Format("Car[%s]", self:UniqueID())
end

function car:UniqueID()
	return self.uniqueID
end;

function car:__eq( objectOther )
	return self:UniqueID() == objectOther:UniqueID()
end

function car:GetOwner()
	return nut.char.loaded[ tonumber(self.charID) ].player
end;

function car:Remove()
	if self.carEntity && self.carEntity:IsValid() then
		self.carEntity:Remove();
	end;

	nut.car_vendor.instances[ self.charID ] = nil;
	if self.baggageID != 0 then
		nut.inventory.deleteByID(self.baggageID)
	end;

	local owner = self:GetOwner();
	if owner && owner != NULL then
		netstream.Start(owner, "nut.car_vendor.remove", self.charID)
	end;
end;

if SERVER then
	function car:Sync()
		local owner = self:GetOwner()
		if owner && owner != NULL then
			netstream.Start(owner, "nut.car_vendor.sync", self)
		end;
	end;
end;

nut.meta.car = car
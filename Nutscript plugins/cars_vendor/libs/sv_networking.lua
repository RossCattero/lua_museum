netstream.Hook("nut.car_vendor.order", function(client, vehicleID)
	local charID = client:getChar():getID();
	local trace = client:GetEyeTraceNoCursor();
	local ent = trace.Entity

	if ent && ent:GetClass() == "cars_vendor" then
		local carUniqueID = nut.car_vendor.ilist[ vehicleID ];
		local hasCar = nut.car_vendor.instances[ charID ];
		local foundCar = nut.car_vendor.Get(vehicleID);

		if !nut.car_vendor.CanAfford(carUniqueID, client:getChar():getMoney()) then
			client:notify("You can't afford this car.")
			return;
		end;

		if !hasCar then
			if carUniqueID then
				local car = simfphys && simfphys.SpawnVehicleSimple( carUniqueID, Vector(0, 0, 0), Angle(0, 0, 0) )
				car.EntityOwner = client
				car:SetNoDraw(true)
				car:SetCollisionGroup(8)
				local validatePlace = nut.car_vendor.FindFreeSpace(ent, car:OBBMins(), car:OBBMaxs());			

				if validatePlace then
					client:notify("Your temporary car is spawned.")
					car:SetCollisionGroup(0)
					car:SetPos( validatePlace.HitPos );
					car:SetNoDraw(false)

					local data = nut.car_vendor.Instance(charID, carUniqueID, car)
					data:Sync()

					nut.inventory.instance("grid", {w = foundCar.baggageW, h = foundCar.baggageH})
					:next(function(inventory)
						inventory.id = inventory:getID();
						hook.Run("CarBaggage", inventory)
						nut.car_vendor.instances[ charID ].baggageID = inventory.id;
						inventory:sync( client )

						car.baggageID = inventory.id;
					end);
					
					client:getChar():takeMoney( foundCar && foundCar.price or 0 )
				else
					client:notify("Your vehicle can't be spawned here!")
					car:Remove();
				end;
			else
				client:notify("You can't order this car.")
			end;
		else
			client:notify("You already have a temporary car.")
		end;
	end;
end)
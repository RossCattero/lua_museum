local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedChar( client, character, prev )
	if prev then
		local prevID = prev:getID();
		local car = nut.car_vendor.instances[ prevID ];
		if car then			
			car:Remove();
		end;
	end;
end;

function PLUGIN:OnCharDisconnect(client, character)
	local charID = character:getID();
	local car = nut.car_vendor.instances[ charID ];
	if car then			
		car:Remove();
	end;
end;

function PLUGIN:simfphysOnDestroyed( target )
	if target && target.EntityOwner && target.EntityOwner:IsValid() then
		local character = target.EntityOwner:getChar();
		if character then
			local charID = character:getID();
			local car = nut.car_vendor.instances[ charID ]
			if car then
				car:Remove()
				target.EntityOwner:notify("You've lost your temporary car!")
			end;
		end;
	end;
end;

function PLUGIN:simfphysOnDelete( target )
	if target && target.EntityOwner && target.EntityOwner:IsValid() then
		local character = target.EntityOwner:getChar();
		if character then
			local charID = character:getID();
			local car = nut.car_vendor.instances[ charID ]
			if car then
				car:Remove()
				target.EntityOwner:notify("You've lost your temporary car!")
			end;
		end;
	end;
end;

function PLUGIN:simfphysUse( vehicle, client )
	if client:KeyDown(IN_SPEED) && vehicle.baggageID then
		local inventory = nut.inventory.instances[ vehicle.baggageID ];
		if inventory then
			inventory:sync( client )

			netstream.Start(client, "nut.car_vendor.openBaggage", vehicle.baggageID)
			return true;
		end;
	end
end;
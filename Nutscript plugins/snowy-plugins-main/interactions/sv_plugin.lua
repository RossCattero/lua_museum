local PLUGIN = PLUGIN;
TIE_TIME = 5;

function PLUGIN:CharacterPreSave(char)
		local client = char:getPlayer()
    if (IsValid(client)) then
				char:setData("cuffed", char:getData("cuffed", false))
				client:setLocalVar("cuffed", char:getData("cuffed"))
		end;
end;

function PLUGIN:PlayerLoadedChar(client, char)
		timer.Simple(0, function()
				char:setData("cuffed", char:getData("cuffed", false))
				client:setLocalVar("cuffed", char:getData("cuffed"))

				if char && char:getData("cuffed") then
						client:setRestricted(true)
				end
		end)
end;

function PLUGIN:PlayerTick(ply)
		if ply.grabEntity != NULL && IsEntity(ply.grabEntity) then
				local pos, ang = 
				ply:GetPos() + ply:GetForward() * 75, ply:GetAngles()
				ply.grabEntity:SetPos(pos);
				ply.grabEntity:SetAngles(ang)
				ply.grabEntity:SetSequence( ply.grabEntity:getNetVar("player"):GetSequence() )
				
				ply.grabEntity:getNetVar("player"):SetPos(ply.grabEntity:GetPos())
		end
end;

function PLUGIN:PlayerDeath(client, inflictor, attacker)
	if (!client:getChar()) then return end
	if (IsValid(client.grabEntity)) then
		client.grabEntity.nutIgnoreDelete = true
		client.grabEntity:Remove()
		local grabPerson = client:getLocalVar("grabbing")
		if grabPerson && grabPerson != NULL then
				grabPerson:setLocalVar("grabbing", nil)
		end
	end
	if client:getChar():getData("cuffed") then
			client:Cuff(false)
	end;
end

function PLUGIN:PlayerDisconnected(client)
	if (IsValid(client.grabEntity)) then
		client.grabEntity.nutNoReset = true
		client.grabEntity.nutIgnoreDelete = true
		client.grabEntity:Remove()
		local grabPerson = client:getLocalVar("grabbing")
		if grabPerson && grabPerson != NULL then
				grabPerson:setLocalVar("grabbing", nil)
		end
	end
end

function PLUGIN:KeyPress(client, key)
	if (key == IN_USE && client:getLocalVar("grabbing")) then
		client:setActionMoving("Stop dragging (HOLD USE BUTTON)", 5, 
		function(user) 
			local trace = user:Tracer(82)
			if user.grabEntity && util.IsInWorld(user.grabEntity:GetPos()) && !trace.Hit then
				user:StopGrab();
			end;
		end, 
		function(user)
				local trace = user:Tracer(82)
				return user:KeyDown(IN_USE) && user.grabEntity && util.IsInWorld(user.grabEntity:GetPos()) && !trace.Hit
		end)
	end
end

netstream.Hook('tie::tieChar', function(client, target)
		-- local look = client:IsTargetTurned(target)
		local hasZip = client:getChar():getInv():getFirstItemOfType("zip")
		
		if !target:IsPlayer() then return end; -- && !look

		local vel = client:GetVelocity();
		local char = target:getChar();
		if !char:getData('cuffed') then char:setData("cuffed", false) end;

		local cuffed = char:getData("cuffed")
		if !cuffed && !hasZip then return end;
		local act = cuffed && "untied" || "tied";
		local act2 = cuffed && "Untying: " || "Tying "

		target:setAction("You're being "..act.." up...", TIE_TIME)
		client:setActionMoving(act2 .. target:Name(), TIE_TIME, 
		function() 
			if IsValid(target) && target:IsPlayer() && target:Alive() then
				if !char:getData("cuffed") then
						hasZip:remove()
						target:setAction();
						target:Cuff(true)
						target:EmitSound("items/flashlight1.wav")
				else
						local zipItem = nut.item.list["zip"]
						local inv =  client:getChar():getInv();
						if zipItem then
								if inv:canItemFitInInventory(zipItem, zipItem.width, zipItem.height) then
									inv:add("zip")
									client:notify("*** I took a tie off target's hands and put it to my inventory")
								else
									nut.item.spawn("zip", client:GetPos())
									client:notify("*** I took a tie off target's hands, but I can't fit it in my inventory")
								end
						end;
						target:setAction();
						target:Cuff(false)
						target:EmitSound("items/flashlight1.wav")
				end;
			end;
		end, 
		function(user)				
				local tracer = user:Tracer(128)
				local cuffed = char:getData("cuffed");
				local hasZip = user:getChar():getInv():getFirstItemOfType("zip")
				
				if (user:GetVelocity() != vel || target != tracer.Entity || (!cuffed && !hasZip)) then
					target:setAction();
					return false;
				end;

				return true;
		end)
end);

netstream.Hook('inter::giveMoney', function(client, target, amount)
		if IsValid(target) && target:IsPlayer() then
				local char = client:getChar();
				local tChar = target:getChar()
				local notAm = nut.currency.get(amount);
				char:takeMoney(amount)
				client:notify("You've given the "..notAm)

				tChar:giveMoney(amount)
				target:notify("You received the " .. notAm .." from " .. client:Name())
		end
end);

netstream.Hook('search::searchChar', function(client, target)
		if IsValid(target) && target:IsPlayer() && target:getNetVar("cuffed") then
				PLUGIN:searchPlayer(client, target)
		end
end);

netstream.Hook('tie::grabChar', function(client, target)
		if IsValid(target) && target:IsPlayer() && target:getNetVar("cuffed") then
				target:createMovableCopy(client)
		end
end);
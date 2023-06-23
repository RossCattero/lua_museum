--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("DropWeapon");

COMMAND.tip = "Выбросить оружие.";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local weapon = player:GetActiveWeapon();
	local ammocount = player:GetAmmoCount( weapon.Primary.Ammo );

	if (IsValid(weapon)) then
		local class = weapon:GetClass();
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		
		if (!itemTable) then
			Clockwork.player:Notify(player, {"ThisNotValidWeapon"});
			return;
		end;
		
		if (Clockwork.plugin:Call("PlayerCanDropWeapon", player, itemTable, weapon)) then
			local trace = player:GetEyeTraceNoCursor();
			
			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					
					if itemTable:GetData("ClipOne") >= 0 && ammocount == 0 then
						itemTable:SetData("ClipOne", itemTable:GetData("ClipOne"));
						player:RemoveAmmo(itemTable:GetData("ClipOne"), weapon.Primary.Ammo);
					end;
					if ammocount >= 0 && itemTable:GetData("ClipOne") == 0 then
						itemTable:SetData("ClipOne", ammocount);
						player:RemoveAmmo(ammocount, weapon.Primary.Ammo);
					end;
					player:TakeItem(itemTable, true);
					player:StripWeapon(class);
					player:SelectWeapon("cw_hands");
					
					Clockwork.plugin:Call("PlayerDropWeapon", player, itemTable, entity, weapon);
				end;
			else
				Clockwork.player:Notify(player, {"CannotDropWeaponFar"});
			end;
		end;
	else
		Clockwork.player:Notify(player, {"ThisNotValidWeapon"});
	end;
end;

COMMAND:Register();
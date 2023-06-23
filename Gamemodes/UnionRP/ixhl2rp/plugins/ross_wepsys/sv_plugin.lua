function PLUGIN:PlayerSwitchWeapon(player, oldWeapon, weapon)
	local item = player:GetCharacter():GetInventory():HasItem(weapon:GetClass());
	
    if item && item:GetData('WepAttachments') then
        for k, v in pairs(item:GetData('WepAttachments')) do
            if weapon:CanAttach(v) && v != '' then
                weapon:Attach(v)
            end;
        end;
     end;
end;

function PLUGIN:KeyPress( player, key )
    local weapon = player:GetActiveWeapon();
    if key == IN_RELOAD then
        timer.Create("ixToggleRaise"..player:SteamID(), 1, 1, function()
            if (IsValid(player)) then
                if IsWeaponTFA(weapon) then
                    weapon:CycleSafety()
                    player:SetWepRaised(weapon:IsSafety(), weapon)
                end;
				player:ToggleWepRaised()
			end
		end)
    end;

    if IsWeaponTFA(weapon) && player:KeyDown(IN_SPEED) && player:KeyDown(IN_USE) && !player:KeyPressed(IN_RELOAD) then
        weapon:CycleSafety()
        player:SetWepRaised(!weapon:IsSafety(), weapon)
    end;
end;

function PLUGIN:KeyRelease(client, key)
    local weapon = client:GetActiveWeapon()
	if (key == IN_RELOAD) then
		timer.Remove("ixToggleRaise" .. client:SteamID())
	end
end

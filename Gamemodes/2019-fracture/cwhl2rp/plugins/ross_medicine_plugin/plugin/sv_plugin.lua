
local PLUGIN = PLUGIN;
local mc = math.Clamp

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["RegenMeHealth"]) then
		data["RegenMeHealth"] = data["RegenMeHealth"];
	else
		data["RegenMeHealth"] = {
            [1] = {
                healthadd = 0,
                timeregen = 0
            }
        };
    end;
end;
function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["RegenMeHealth"] ) then
		data["RegenMeHealth"] = {
            [1] = {
                healthadd = 0,
                timeregen = 0
            }
        };
    end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable) 
    local hRightLeg = Clockwork.limb:GetHealth(player, HITGROUP_RIGHTLEG);
    local hLeftLeg = Clockwork.limb:GetHealth(player, HITGROUP_LEFTLEG)
    local tbl = player:GetCharacterData("RegenMeHealth")

    if tbl[1]["healthadd"] > 0 && tbl[1]["timeregen"] > 0 then
        if (!player.RegenMyHealthPls or curTime >= player.RegenMyHealthPls) then

            if player:Health() ~= 100 && player:Alive() then
                player:SetHealth(mc(player:Health() + tbl[1]["healthadd"], 0, 100))
            end;

            tbl[1]["timeregen"] = math.Clamp(tbl[1]["timeregen"] - 1, 0, 100);
            if tbl[1]["timeregen"] == 0 then
                tbl[1]["healthadd"] = 0;
            end;

		    player.RegenMyHealthPls = curTime + 1;
        end;
    end;

	infoTable.crouchedSpeed = infoTable.crouchedSpeed - (200 - hRightLeg - hLeftLeg)*0.5
	infoTable.jumpPower = infoTable.jumpPower - (200 - hRightLeg - hLeftLeg)*0.5
	infoTable.runSpeed = infoTable.runSpeed - (200 - hRightLeg - hLeftLeg)*0.5

end;

function PLUGIN:PrePlayerTakeDamage(player, attacker, inflictor, hitGroup, damageInfo)
    local random = math.random(1, 100) - player:Health()*0.5;
    local weapon = player:GetActiveWeapon();

    if hitGroup == HITGROUP_LEFTLEG || hitGroup == HITGROUP_RIGHTLEG then
        if random > Clockwork.limb:GetHealth(player, hitGroup) then
            Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, math.random(1, 6), nil, Clockwrok.kernel:ConvertForce(damageInfo:GetDamageForce() * 32))
        end;
    end;
    if hitGroup == HITGROUP_LEFTHAND || hitGroup == HITGROUP_RIGHTHAND then
        if random > Clockwork.limb:GetHealth(player, hitGroup) then
        
            if (IsValid(weapon)) then
                local class = weapon:GetClass();
                local itemTable = Clockwork.item:GetByWeapon(weapon);
                
                if (!itemTable) then
                    return;
                end;
                
                if (Clockwork.plugin:Call("PlayerCanDropWeapon", player, itemTable, weapon)) then
                        local entity = Clockwork.entity:CreateItem(player, itemTable, player:GetPos());
                        
                        if (IsValid(entity)) then
                            
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
                    end;
                end;
            
        end;
    end;
end;

function PLUGIN:PlayerHealthSet(player, nH, oH)
    local limbData = player:GetCharacterData("LimbData");
    local modificator = 1;
    if nH > oH then
		
		if (limbData) then
            for k, v in pairs(limbData) do
                if Clockwork.limb:GetHealth(player, k) <= 25 then
                    modificator = 3;
                end;
				Clockwork.limb:HealDamage(player, k, (nH-oH) / modificator);
			end;
        end;
        
    end;

end;
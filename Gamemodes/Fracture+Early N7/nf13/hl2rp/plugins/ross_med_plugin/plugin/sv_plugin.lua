local PLUGIN = PLUGIN;
local p = FindMetaTable( "Player" );


function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["HealthBuffs"]) then
		data["HealthBuffs"] = data["HealthBuffs"];
	else
	    data["HealthBuffs"] = {
            time = 0,
            amount = 0
        };
    end;
    
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["HealthBuffs"] ) then
		data["HealthBuffs"] = {
            time = 0,
            amount = 0
        };
    end;
end;

function p:GetMedBuffs()

    return self:GetCharacterData('HealthBuffs');
end;

function p:AddBuff(time, num)
    local healthBuffsTable = self:GetCharacterData('HealthBuffs');

    healthBuffsTable["time"] = time;
    healthBuffsTable["amount"] = num;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
    local health = player:Health();
    local maxhealth = player:GetMaxHealth();
    local buffs = player:GetMedBuffs();
    local valid = player:IsValid();
    local alivce = player:Alive();
    local init = player:HasInitialized();

    if !player.medRegen || curTime >= player.medRegen then
        if tonumber(buffs['time']) != 0 then

            player:SetHealth( math.Clamp(health + tonumber(buffs['amount']), 0, maxhealth) );
            player:GetMedBuffs()['time'] = player:GetMedBuffs()['time'] - 1;
        end;

        player.medRegen = curTime + 1;
    end;

end;
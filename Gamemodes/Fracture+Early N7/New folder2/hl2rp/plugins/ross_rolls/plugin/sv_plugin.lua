
local PLUGIN = PLUGIN;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["NextDamageInfo"] ) then
		data["NextDamageInfo"] = {
            nextdamage = 0,
            limbus = '',
            victimName = '',
            vic = ''
        };
    end;

end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["NextDamageInfo"] ) then
		data["NextDamageInfo"] = data["NextDamageInfo"];
    elseif !data["NextDamageInfo"] then
        data["NextDamageInfo"] = {
            nextdamage = 0,
            limbus = '',
            victimName = '',
            vic = ''
        };
    end;

end;

function PLUGIN:PlayerThink(player, cur, info)

    if player.CoolDownTillExpire && CurTime() >= player.CoolDownTillExpire then
        local tbl = player:GetCharacterData('NextDamageInfo');
		Clockwork.hint:SendCenter(player, "Ваш бонус к роллу обнулен.", 5, Color(255, 50, 50), true, true);
		Clockwork.hint:SendCenter(tbl.vic, "Бонус к роллу у "..tbl.vic:GetName().." обнулен!", 5, Color(255, 50, 50), true, true);
        tbl.nextdamage = '';
		tbl.limbus = '';
		tbl.victimName = 0;
		tbl.vic = '';
        player.CoolDownTillExpire = nil;
    end;
    
end;

function PLUGIN:PlayerTraceAttack(player, damageInfo, direction, trace)
    local a = damageInfo:GetAttacker();
    local tbl = a:GetCharacterData('NextDamageInfo');
    local nametocheck = tbl.victimName;
    local limbtocheck = tbl.limbus;
    if nametocheck == '' || limbtocheck == '' then
        return;
    end;
    local vname = player:GetName() == nametocheck
    local vlimb = trace.HitGroup == limbtocheck

    if player.startedDamage && CurTime() < player.startedDamage then
        damageInfo:SetDamage( 0 )
        return;
    end;

    if vname && vlimb then
        damageInfo:SetDamage( tbl.nextdamage )
        tbl.victimName = '';
        tbl.limbus = '';
        tbl.nextdamage = 0;
        tbl.vic = ''

        player.startedDamage = CurTime() + 3;
    else
        damageInfo:SetDamage( 0 )
    end;

    if trace.HitWorld then
        tbl.victimName = '';
        tbl.limbus = '';
        tbl.nextdamage = 0;
        tbl.vic = ''

        player.startedDamage = CurTime() + 3;
    end;
    
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
    local tbl = player:GetCharacterData('NextDamageInfo');
    player:SetSharedVar("victimEnt", tbl.vic);
end;
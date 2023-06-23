
local PLUGIN = PLUGIN;
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

function PLUGIN:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
    if (!damageInfo:IsFallDamage() and !damageInfo:IsDamageType(DMG_CRUSH)) then
        if (hitGroup == HITGROUP_HEAD) then
            damageInfo:ScaleDamage(Clockwork.config:Get("scale_head_dmg"):Get());

        elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
            damageInfo:ScaleDamage(Clockwork.config:Get("scale_chest_dmg"):Get());

        elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM or hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_GEAR) then
            damageInfo:ScaleDamage(Clockwork.config:Get("scale_limb_dmg"):Get());
        end;
    end;
    
    Clockwork.plugin:Call("PlayerScaleDamageByHitGroup", player, attacker, hitGroup, damageInfo, baseDamage);
end;

local PLUGIN = PLUGIN;

function Schema:AddCombineDisplayLine(text, color, player, exclude)
	if (player) then
		Clockwork.datastream:Start(player, "CombineDisplayLine", {text, color});
	else
		local players = {};
		
		for k, v in ipairs(_player.GetAll()) do
			if (self:PlayerIsCombine(v) and v != exclude) then
				table.insert(players, v);
			end;
		end;
		
		Clockwork.datastream:Start(players, "CombineDisplayLine", {text, color});
	end;
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	local fac = player:GetFaction();

	if Schema:PlayerIsCombine(player) then
		if ( !data["GasMaskCheck"] ) then
			data["GasMaskCheck"] = false;
		end;
	end;

	if (!data["cid"]) then
		if !Schema:PlayerIsCombine(player) && fac != FACTION_ADMIN && fac != FACTION_REBEL && fac != FACTION_REFUGEE then
			data["cid"] = Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5);
		else
			data['cid'] = nil;
		end;
	end;
end;

function PLUGIN:Initialize()
    if Clockwork.kernel:GetSharedVar("CityStatus") == '' then
        Clockwork.kernel:SetSharedVar("CityStatus", 'ЗЕЛЕНЫЙ');
    end;
end;

function PLUGIN:PlayerSetSharedVars(player, curTime)
	if Schema:PlayerIsCombine(player) then
		player:SetSharedVar('GasMaskCheck', player:GetCharacterData('GasMaskCheck'))
	end;
	player:SetSharedVar("cid", player:GetCharacterData("cid"));
end;

function PLUGIN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	local health = player:Health()
	local combine = Schema:PlayerIsCombine(player);

	if combine then

		if !player.CmbTakingDamage || CurTime() >= player.CmbTakingDamage then
			Schema:AddCombineDisplayLine(player:Name()..' получил физическую травму!', Color(255, 50, 50) )
			player.CmbTakingDamage = CurTime() + 4
		end;
	end;
end;

function PLUGIN:PlayerButtonDown(player, button)

	if button == KEY_N && player:GasmaskInfo() > 0 then
		if !player.CombineKeyCooldown || CurTime() >= player.CombineKeyCooldown then
			Clockwork.player:PlaySound(player, 'buttons/combine_button1.wav')
			player:SetCharacterData('GasMaskCheck', !player:GetCharacterData('GasMaskCheck'))
			player.CombineKeyCooldown = CurTime() + 2
		end;
	end;

end;

function PLUGIN:PlayerDeath(player, inflictor, attacker, damageInfo)

	local health = player:Health()
	local combine = Schema:PlayerIsCombine(player);

	if combine then
		Schema:AddCombineDisplayLine(player:Name()..' получил критический урон! Производится отключение системы...', Color(255, 50, 50) )
		for k, v in pairs(cwPlayer.GetAll()) do
			if Schema:PlayerIsCombine(v) then
				cable.send(v, 'CreateWaypoint', player:GetPos(), player:Name(), 221, 'loss');
			end;
		end;
	end;

end

function PLUGIN:PlayerCharacterInitialized(player)
	local fac = player:GetFaction();

	if fac == FACTION_CITIZEN then
		Schema:AddCombineDisplayLine('Получено изменение численности граждан...', Color(100, 255, 100) )
	elseif fac == FACTION_CWU then
		Schema:AddCombineDisplayLine('Получено изменение численности гражданского союза рабочих...', Color(27, 184, 113) )
	elseif fac == FACTION_ADMIN then
		Schema:AddCombineDisplayLine('Получено изменение численности партии...', Color(255, 200, 100) )
	elseif fac == FACTION_VORTSLAVE then
		Schema:AddCombineDisplayLine('Получено изменение численности вортигонтов-рабов...', Color(100, 255, 100) )
	elseif fac == FACTION_MPF then
		Schema:AddCombineDisplayLine('Обнаружен юнит гражданской обороны.', Color(50, 100, 150) )
	end;

end;
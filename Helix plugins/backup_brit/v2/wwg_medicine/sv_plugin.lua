local PLUGIN = PLUGIN

function PLUGIN:EntityTakeDamage(target, damage)
	local attacker, dmg, index = damage:GetAttacker(), damage:GetDamage(), damage:GetDamageType()

	target = target:GetNetVar("player") || target;
	
	if dmg == 0 || !target:CanBeWounded() then return end;

	local trace = ix.medical.trace(attacker)

	if !trace then return end;

	local bone = ix.medical.limbs.Get( trace.HitGroup )
	if !bone then bone = "torso" end;

	if ix.medical.GetByIndex( index ) then
		local charID = target:GetCharacter():GetID();

		local wound = ix.medical.Create( index, charID, bone )

		math.randomseed( os.time() )
		if math.random(100) < ( dmg <= 20 && 10 || 50 ) && wound:CanBleed() && ix.medical.BleedAmount(charID, bone) < 2 then
			target:Notify("Your " .. ix.medical.limbs.name(bone):lower() .. " is bleeding!")
		end

		wound:Network( target )
	end;

	damage:ScaleDamage( ix.medical.Multiply( bone ) || 1 )
end;

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
	timer.Simple(.25, function()
		local id = character:GetID();

		if !ix.medical.FindBody(id) then
			ix.medical.CreateBody( id )
		else
			ix.medical.LoadBody( client, id )
		end;

		client:SetLocalVar("bleed", character:GetData("bleed", ix.medical.config.bleed));
	end)
end

function PLUGIN:CharacterPreSave(character)
    local client = character:GetPlayer()
    if (IsValid(client)) then
        character:SetData("bleed", client:GetLocalVar("bleed", ix.medical.config.bleed))
    end
end

function PLUGIN:PreCharacterDeleted(client, character)
	local id = character:GetID();

	if ix.medical.FindBody(id) then
		ix.medical.DeleteBody(id)
	end;
end;

-- PrintTable(ix.medical)

--[[
	АЛЕРТ
	Сделать отдельно injuries и wounds
	injuries - это виды урона, которые по итогу выдают wound.
	Регистрировать нужно и то и другое, но игроку вешать именно wound
	wound - это кровотечение, инфекция, перелом и тд.
	Это уменьшит нагрузку на базу данных
]]
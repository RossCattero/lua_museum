local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
	timer.Simple(.25, function()
		local id = character:GetID();

		// Load(cache) the body and all wound instances for character.
		if !ix.body.instances[id] then
			ix.body.Load( id )
		end;
	end);
end;

function PLUGIN:CharacterDeleted(client, id, current)
	// If character is deleted - uncache and erase his data from global table and database.
	if ix.body.instances[id] then
		ix.body.Remove( id, true )
	end;
end;

function PLUGIN:PlayerDisconnected(client)
	// If server is shutting down then don't do it.
	if ix.shuttingDown then
		return;
	end

	// "Uncache" the bodies and wounds.
	local s64 = client:SteamID64()
	local cache = ix.char.cache[s64]
	
	if cache then
		for _, id in ipairs(cache) do
			ix.body.Remove( id )
		end
	end
end;

function PLUGIN:EntityTakeDamage(target, damage)
	local attacker, dmg, index = damage:GetAttacker(), damage:GetDamage(), damage:GetDamageType()

	// For situations when target is ragdolled, for example.
	target = target:GetNetVar("player") || target;

	// To prevent double damage.
	if dmg == 0 then return end;

	// Trace coverup.
	local trace = ix.body.trace(attacker)
	if !trace then return end;

	// Search bone. If not found - we need a torso (exclusive situations).
	local bone = ix.body.list[trace.HitGroup]
	if !bone then bone = "torso" end;

	local injury = ix.injury.list[ index ]
	if injury then
		local rand = math.random(100)
		// If injury can cause bleed wound, amount < 2 and damage < 20 and random < 10% or damage >= 20 and random < 50%.
		if injury.bleeding && ix.wound.GetAmount( target:GetCharacter():GetID(), "bleed", bone ) < 2 
		&& (( dmg < 20 && rand < 10 ) || ( dmg >= 20 && rand < 50 )) then
			ix.wound.CreateBleed( target, bone )
		end

		// If injury can cause fracture wound and random < 5%.
		if injury.fracture then
			ix.wound.CreateFracture( target, bone, 5 )
		end;

		// If injury can cause a burn.
		if injury.burn then
			ix.wound.CreateBurn( target, bone, dmg )
		end
	end;

	// Damage scale. For reference see sh_plugin.lua;
	-- damage:ScaleDamage( ix.medical.multiply[bone] || 1 )
	damage:ScaleDamage( 0 )
end;

// Called on gamemode init.
function PLUGIN:LoadData()
	local query;

	// Create table if not exists;
	query = mysql:Create("ix_wounds")
		query:Create("id", "INT(11) UNSIGNED NOT NULL")
		query:Create("uniqueID", "VARCHAR(255) NOT NULL")
		query:Create("bone", "VARCHAR(255) NOT NULL")
		query:Create("time", "INT(11) UNSIGNED NOT NULL")
		query:Create("charID", "INT(11) UNSIGNED NOT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:PrimaryKey("id")
	query:Execute()
end;

// Called on server shutdowns, etc.
function PLUGIN:SaveData()
	local query;

	// Remove all wounds in database to save everything;
	query = mysql:Delete("ix_wounds")
	query:Execute()

	// Save everything in database;
	for k, v in pairs( ix.wound.instances ) do
		query = mysql:Insert("ix_wounds")
			query:Insert("id", v.id)
			query:Insert("uniqueID", v.uniqueID)
			query:Insert("bone", v.bone)
			query:Insert("time", v.time)
			query:Insert("charID", v.charID)
			query:Insert("data", util.TableToJSON(v.data))
		query:Execute()
	end

end;

function PLUGIN:GetFallDamage(client, speed)
	// Default helix fall damage
	local damage = (speed - 580) * (100 / 444);

	local leg = math.random(100) > 50 && "l_leg" || "r_leg"

	// If amount of fractures on provided leg is < 1.
	if ix.wound.GetAmount( client:GetCharacter():GetID(), "fracture", leg ) < 1 then
		ix.wound.CreateFracture( client, leg, math.min(damage * 2, 100) )
	end;

	return damage
end

/*
	TODO:
	1. Diseases
	2. Medicine
	3. Low HP
	4. Load wound problems
*/
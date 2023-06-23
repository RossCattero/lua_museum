local PLUGIN = PLUGIN
PLUGIN.name = "Injuries plugin"
PLUGIN.author = "Ross Cattero"
PLUGIN.desc = "Injuries and health"

// All limbs in this plugin is 1 - 8, where 1 is head and 8 is blood;
// You can write    FACTION.limbUnaffected = true    in factions file located, basically, in schema/factions/<name>.lua to make this faction unaffected by limbs and injuries;
// You can use command /clearInjuries <name> to set all limbs to 100 of player if he's on server.

// You can use command /checkInjuries <name> to check limbs from player if he's on server.
// I've used my props models: https://steamcommunity.com/sharedfiles/filedetails/?id=1920107570
PLUGIN.DEFAULT_LIMBS = {
		[1] = {
			name = "head",
			amount = 100,
		},
		[2] = {
			name = "chest",
			amount = 100,
		},
		[3] = {
			name = "right hand",
			amount = 100,
		},
		[4] = {
			name = "left hand",
			amount = 100,
		},
		[5] = {
			name = "left leg",
			amount = 100,
		},
		[6] = {
			name = "right leg",
			amount = 100,
		},
		[7] = {
			name = "blood",
			amount = 100
		}
}

HITBONE = {
	["head"] = 1,
	["spine"] = 2,
	["pelvis"] = 2,
	["hips"] = 2,
	["forearm"] = 4,
	["arm"] = 4,
	["upperarm"] = 4,
	["hand"] = 4,
	["thigh"] = 6,
	["leg"] = 6,
	["flapa"] = 6,
	["calf"] = 6,
	["foot"] = 6,
}

BLOOD_LOSE = {
	[0] = 0,
	[1] = 2.5,
	[2] = 3.6,
	[4] = 2.5,
	[64] = 6.6,
	[128] = 1.5,
	[1024] = 2
}

function DefaultLimb(num)
		local defLimb = PLUGIN.DEFAULT_LIMBS;
		local numCopy = num;

		if !defLimb[numCopy] then
				num = nil;
				for k, v in pairs(defLimb) do
						if numCopy == v.name then
								num = defLimb[k];
								break;
						end
				end
				numCopy = num;
				if !numCopy then
						return false;
				end
		else
				num = defLimb[numCopy]
		end

		return num && num.amount
end;

function PLUGIN:HitBone(trace)
	if trace.HitWorld then return 0; end;
	local ent, pbone = trace.Entity, trace.PhysicsBone
	if ent == NULL then return 0 end;

	local bone = ent:TranslatePhysBoneToBone( pbone )
	local bonename = ent:GetBoneName( bone );
	bonename = bonename:lower()
	for k, v in pairs(HITBONE) do
			if bonename:find(k) then
					return v
			end
	end
	return 0;
end;

nut.util.include("cl_plugin.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("sv_meta.lua")
nut.util.include("sh_meta.lua")
nut.util.include("sh_hooks.lua")
nut.util.include("sv_plugin.lua")

nut.command.add("clearInjuries", {
	adminOnly = true,
	syntax = "<string name>",
	onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])

			if (IsValid(target)) then
					target:ResetLimbs()
					if target:getChar():getData("bleeding") then
							target:StopBleeding();
							target:notify("You're not bleeding anymore.")
					end;
					target:notify("Your limbs have been reseted.")
			end;
	end
})

nut.command.add("checkInjuries", {
	syntax = "<string name>",
	adminOnly = true,
	onRun = function(client, arguments)
			local target = nut.command.findPlayer(client, arguments[1])

			if (IsValid(target)) then
					netstream.Start(client, 'limbs::openHealth', target:GetLimbs(), "owner")
			end;
	end
})

nut.command.add("seeInjuries", {
	onRun = function(client)
			local trace = client:Tracer(128);
			local target = trace.Entity;

			if target != Entity(0) && target != NULL && target:IsPlayer() && target:getChar() then
					netstream.Start(client, 'limbs::openHealth', target:GetLimbs(), "user")
			else
					client:notify("*** I don't see anyone here or I need to come closer.")
			end
	end
})

function PLUGIN:CanPlayerUseChar(client, char)
		if client:getLocalVar("unconscious") then
				return false, "You're unconsious!"
		end;
end;
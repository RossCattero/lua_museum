include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

PrecacheParticleSystem( "vortigaunt_charge_token" )

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl");
	self:DrawShadow(false);
	self:SetSolid(SOLID_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);

	self:SetLevel(math.random(1, 4))
	self:SetCollisionGroup(1)

	self.lootLevel = {
		[1] = {
			["fireball"] = 25,
			["nighstar"] = 35,
			["jellyfish"] = 40,
			["sparkler"] = 55,
			["stoneblood"] = 56
		},
		[2] = {
			["wrenched"] = 25,
			["meatchunk"] = 30,
			["crystall"] = 35,
			["shell"] = 35,
			["stoneflower"] = 40
		},
		[3] = {
			["eye"] = 5,
			["goldfish"] = 6,
			["soul"] = 7,
			["callobok"] = 10
		},
		[4] = {
			["snowflake"] = 4,
			["mamabeads"] = 5,
			["bubble"] = 10,
			["flame"] = 10,
			["gravi"] = 10,
			["battery"] = 15
		}
	}

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == "models/hunter/blocks/cube025x025x025.mdl") then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);

			return;
		end;
	end;
end;

function ENT:Use(activator, caller)
	local char = activator:GetCharacter() local inv = char:GetInventory()
	local lvl = self:GetLevel()
	local callout = inv:HasItem("detector_callout");
	local bear = inv:HasItem("detector_bear");
	local veles = inv:HasItem("detector_veles")
	local svarog = inv:HasItem("detector_svarog")

	local CanSeeLvL = (callout && callout:GetData('toggled') && callout.level) or 
	( bear && bear:GetData('toggled') && bear.level) or 
	(veles && veles:GetData('toggled') && veles.level) or 
	(svarog && svarog:GetData('toggled') && svarog.level) or 0;

	if CanSeeLvL < lvl then
		return;
	end;

	for k, v in pairs(self.lootLevel[lvl]) do
		if !self.click then
			self.click = true;
			timer.Simple(0.5, function()
				if math.random(100) <= v then
					ix.item.Spawn(k, self:GetPos(), function(item, entity)
						ParticleEffectAttach( 'vortigaunt_charge_token', PATTACH_POINT_FOLLOW, entity, -1 ); 
						self:EmitSound("anomaly/bfuzz_hit.mp3") self:Remove();
						timer.Simple(1.5, function()
							if IsValid(entity) then entity:StopParticles() end;
						end);
					end, self:GetAngles())
				else
					self:Remove();
				end;
				return;
			end);
		end;
	end;
end;
include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props/cs_office/tv_plasma.mdl"

		self:SetModel(model);
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		
		local tespos = self:GetPos() + Vector(100, 0, 0)
		self.light = ents.Create("light_dynamic")
		self.light:Spawn()
		self.light:Activate()
		self.light:SetPos( tespos )
		self.light:SetKeyValue("distance", 400)
		self.light:SetKeyValue("brightness", 2)
		self.light:SetKeyValue("_light", "66 176 244 255")
		self.light:Fire("TurnOn")
		self.light:SetParent( self )
		
		self:SetHealth(100)
		self:SetNumberDone(Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5))

		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:Think()
	local curTime = CurTime();

	if self:Health() < 50 then
	if (!self.zappp || CurTime() >= self.zappp) then
		if IsValid(self) then
			local effect = EffectData()
			effect:SetOrigin( self:GetPos() + Vector( -5, math.random(-25, 10), 25) )
			effect:SetStart( self:GetPos() )
			effect:SetNormal(self:GetPos())
			effect:SetMagnitude( 3 )
			
			util.Effect( "ElectricSpark", effect )
		end;
        self.zappp = curTime + self:Health() + 1;
	end; end;

	if self:GetTimeLeft() > 0 then 
		self:SetTimeLeft(mc(self:GetTimeLeft() - 1, 0, 100))
	end;
end;

function ENT:StartTouch( ent )
	if ent:GetClass() == "cw_item" && git(ent, "uniqueID") == "citizen_civ_card" && self:GetTimeLeft() == 0 then 
		self:SetTimeLeft(124)
		for k, v in pairs(cwPlayer.GetAll()) do
			if Schema:PlayerIsCombine(v) then
				cable.send(v, 'CreateWaypoint', self:GetPos(), 'Монитор: '..self:GetNumberDone(), 70, 'backup');
			end;
		end;
	end;
end;

function ENT:OnTakeDamage( dmginfo )

	if self:Health() == 0 && self.boolingan == false then 
		self:SetModel("models/props/cs_office/tv_plasma_p1.mdl")
		
		for k, v in pairs(cwPlayer.GetAll()) do
			if Schema:PlayerIsCombine(v) then
				cable.send(v, 'CreateWaypoint', self:GetPos(), 'Монитор: '..self:GetNumberDone(), 70, 'backup');
			end;
		end;

			local effect = EffectData()
			effect:SetOrigin( self:GetPos() + Vector(-5, 0, 25) )
			effect:SetStart( self:GetPos() )
			effect:SetNormal(self:GetPos())
			effect:SetMagnitude( 15 )
				
			util.Effect( "ElectricSpark", effect )
			self.light:Remove()
		self.boolingan = true;
		return;
	end;

	if IsValid(self) then
		local effect = EffectData()
		effect:SetOrigin( dmginfo:GetAttacker():GetEyeTraceNoCursor().HitPos )
		effect:SetStart( self:GetPos() )
		effect:SetNormal(self:GetPos())
		effect:SetMagnitude( 2 )
		
		util.Effect( "ElectricSpark", effect )
	end

	self:SetHealth( mc(self:Health() - dmginfo:GetDamage(), 0, 100))
end
local PLUGIN = PLUGIN;
include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");
PrecacheParticleSystem( "WaterSurfaceExplosion" )

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/firehydrant.mdl")
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetUseType(SIMPLE_USE);

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then physObj:EnableMotion(true); physObj:Wake(); end;

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);
			return;
		end;
	end;
end;

function ENT:WaterSplash(scale)
		local pos = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		effectdata:SetScale( scale )
		effectdata:SetFlags( 0 )
		util.Effect( "WaterSplash", effectdata, true, true )
end;

function ENT:Broke(bool)
		self:SetIsBroken(bool)

		if self:GetIsBroken() && !timer.Exists(self:EntIndex() .. " - is broken") then
			self:EmitSound("physics/metal/metal_barrel_impact_hard7.wav")

			timer.Simple(2, function()
					self:WaterSplash( 1024 )

					local uniqueID = self:EntIndex() .. " - is broken"
					timer.Create(uniqueID, 1, 0, function()					
							if !timer.Exists(uniqueID) || !self:IsValid() || !self:GetIsBroken() then timer.Remove(uniqueID) return; end;
							self:WaterSplash( 16 )
					end)
			end)
		end
end;

function ENT:SetWorkPos(uniqueID, id)
		self.workPos = id;
		self.workName = uniqueID
end;

function ENT:OnRemove()
		local list = PLUGIN.jobPoses;
		local id, uniqueID = self.workPos, self.workName

		if id && uniqueID && list && list[uniqueID] && list[uniqueID][id] then
				PLUGIN.jobPoses[uniqueID][id] = nil;
				PLUGIN:ListRefresh(uniqueID);
		end
end;
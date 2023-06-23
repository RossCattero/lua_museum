include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel(self:GetModel() or self:GetDefaultModel())
	self:DrawShadow(true);
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self.defaultModel = self:GetModel()
	self.info = self.info or {
			soil = "",
			seeds = "",
			water = "",
			result = {}
	}

	self:setNetVar("info", self.info)
	self:setNetVar("grown", false)

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

function ENT:UpdateInfo(name, info)
	self.info[name] = info;
	if type(self.info[name]) != "table" then
		self:setNetVar("info", self.info)
	end;
end;

function ENT:GetInfo(name)
	return self:getNetVar("info")[name] or self.info[name]
end;

function ENT:StartTouch(entity)
		if entity.getItemTable then
				local item = entity:getItemTable()
				local base = item.base && item.base:match("base_([%w]+)") or item.uniqueID;
				if base && self:GetInfo(base) && self:GetInfo(base) == "" then
						if base == "soil" && self:GetInfo("seeds") == "" then
								// ! Default for all models. It will change to default model with sand in it.
								self:SetModel("models/nater/weedplant_pot_dirt.mdl")
								self:EmitSound("player/footsteps/sand1.wav")
								self:UpdateInfo(base, item.uniqueID)
								entity:Remove()
						end
						if base == "seeds" && self:GetInfo("soil") != "" then
								// ! Default for all models. It will change to default model with sand and plant in it.
								self:SetModel("models/nater/weedplant_pot_planted.mdl")
								self:EmitSound("player/footsteps/sand2.wav")
								self:UpdateInfo(base, item.uniqueID)
								self:UpdateInfo("result", item.seedResult or {})
								entity:Remove()
						end
						if base == "water" && self:GetInfo("soil") != "" && self:GetInfo("seeds") != "" then
								local seedUniqueID = "Seeds: growing in "..self:EntIndex();
								local seedTbl = nut.item.list[self:GetInfo("seeds")]
								local soilTbl = nut.item.list[self:GetInfo("soil")]
								local getTime = math.max(seedTbl.plantTime or 0 - soilTbl.reduceGrowing or 0, 1)
								local _sec = math.max(1 * soilTbl.multiplyGrowing or 1, 0.1) or 1
								timer.Create(seedUniqueID, _sec, getTime, function()
									if !timer.Exists(seedUniqueID) or !self:IsValid() or self:GetInfo("soil") == "" then 
										timer.Remove(seedUniqueID) 
										return; 
									end;
									local repsLeft = getTime - timer.RepsLeft( seedUniqueID )
									local percent = tostring(((repsLeft/getTime) * 100))
									self:SetModel(seedTbl.seedGrow[percent] or self:GetModel())
									if percent == "100" then
										self:setNetVar("grown", true)	
									end
								end);					
								self:EmitSound("ambient/water/water_spray1.wav")
								self:UpdateInfo(base, item.uniqueID)
								entity:Remove()
						end
				end
		end
end;

function ENT:Use(act)
	local char = act:getChar() 

	if act:KeyDown(IN_SPEED) && self:GetInfo("soil") != "" then
			if self:getNetVar("grown") then
				for k, v in pairs(self.info["result"]) do
					if nut.item.list[k] then
						for i = 1, v do
							char:getInv():add(k)
						end;
					end;
				end
				self:EmitSound("player/footsteps/grass4.wav")
				self:setNetVar("grown", false)		
			else
				for k, v in pairs(self.info) do
					if type(v) == "string" && nut.item.list[v] then
						char:getInv():add(v, 1)
						self:UpdateInfo(k, "")
					end;
				end
				self:SetModel(self.defaultModel)
				self:EmitSound("player/footsteps/sand1.wav")

				return;
			end			
			self:SetModel(self.defaultModel)
			self:EmitSound("player/footsteps/sand1.wav")
			for k, v in pairs(self.info) do
					self:UpdateInfo(k, "")
			end
	elseif act:KeyDown(IN_SPEED) && self:GetInfo("soil") == "" then
		char:getInv():add(self._id, 1)
		self:Remove()
	end;

end;
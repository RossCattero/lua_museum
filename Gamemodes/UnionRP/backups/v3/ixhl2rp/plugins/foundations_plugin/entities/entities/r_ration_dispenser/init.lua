include("shared.lua"); AddCSLuaFile("cl_init.lua"); AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_lab/binderblue.mdl"

		self:SetModel(model);
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:SetLevel(1)
		self:SetTurned(false)

		self.dispenser = ents.Create("prop_dynamic");
		self.dispenser:SetModel("models/props_combine/combine_dispenser.mdl");
		self.dispenser:SetPos(self:GetPos());
		self.dispenser:SetAngles(self:GetAngles() + Angle(0,90,0));
		self.dispenser:SetCollisionGroup( 20 );
		self.dispenser:SetParent(self)
		self.dispenser:Spawn();

		self.ration = ents.Create("prop_physics")
		self.ration:SetModel("models/weapons/w_package.mdl");
		self.ration:SetPos(self:GetPos())
		self.ration:SetAngles(self:GetAngles())
		self.ration:SetMoveType(MOVETYPE_NONE)
		self.ration:SetNotSolid(true)
		self.ration:SetNoDraw(true)
		self.ration:SetParent(self.dispenser, 1)
		self.ration:Spawn()
		self.ration:Activate()
		self:DeleteOnRemove(self.ration)

		self.rationNext = ""

		self.RationLoaded = {
			[1] = {},
			[2] = {},
			[3] = {}
		}

	for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
		if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
			self:SetPos(v:GetPos());
			self:SetAngles(v:GetAngles());
			SafeRemoveEntity(v);

			return;
		end;
	end;
end;

function ENT:StartTouch(ent)
		
	if ent:GetClass() == 'factory_ration' && !self:GetTurned() && ent:GetPacketUp() then
		local id = ent.uniqueLevel
		local lvl = ent.level
		local tCount = #self.RationLoaded[lvl]

		if tCount < 10 then
			self.RationLoaded[lvl][tCount + 1] = ent.FoodInside
			ent:Remove();
		end;
	end;
end;

function ENT:OnOptionSelected(player, option, data)
	local char = player:GetCharacter();
	local inv = char:GetInventory()
	if !inv:HasItem('factory_card') then return end;

	local lvl = self:GetLevel();

	if (option == "Сменить уровень") then
		self:SetLevel(mc(lvl + 1, 0, 3))
		self:EmitSound('buttons/button5.wav')
		if lvl == 3 then self:SetLevel(1) end;
	elseif (option == 'Отключить раздатчик' or option == 'Включить раздатчик') then
		self:SetTurned(!self:GetTurned())
		self:EmitSound('buttons/button6.wav')
	end;
end;

function ENT:Use(activator, caller)
	local d = self.dispenser;
	local lvl = self:GetLevel();
	local turned = self:GetTurned()
	local char = activator:GetCharacter();
	local inv = char:GetInventory()
	local cid = inv:HasItem("part_ticket")

	if self.used then return end;
	if inv:HasItem('factory_card') or !cid then 
		return 
	end;

	if !turned then
		self:EmitSound('buttons/button10.wav')
		return;
	end;

	self.used = true;

	self:EmitSound('ambient/machines/combine_terminal_idle1.wav')

	timer.Create(self:EntIndex()..' - ration dispense.', 1, 1, function()

		if !IsValid(self) then timer.Remove(self:EntIndex()..' - ration dispense.') return end;

		if !cid or cid:GetData("nextRationTime", 0) > os.time() then
			self:EmitSound('buttons/button2.wav')
			return;
		end;

		if #self.RationLoaded[lvl] == 0 then
			self:EmitSound('buttons/button2.wav')
		elseif #self.RationLoaded[lvl] > 0 then
			self.ration:SetNoDraw(false)
			if lvl == 1 then
				self.rationNext = 'first_grade_ration'
				self.ration:SetModel('models/weapons/w_packatc.mdl')
			elseif lvl == 2 then
				self.rationNext = 'second_grade_ration'
				self.ration:SetModel('models/weapons/w_packatl.mdl')
			elseif lvl == 3 then
				self.rationNext = 'third_grade_ration'
				self.ration:SetModel('models/weapons/w_packatp.mdl')
			end;
			self.ration:Fire("SetParentAttachment", "package_attachment", 0);
			d:EmitSound("ambient/machines/combine_terminal_idle2.wav");
		end;

		d:Fire("SetAnimation", "dispense_package", 0);

		timer.Simple(2, function()

			if self.rationNext != "" then
				ix.item.Spawn(self.rationNext, self.ration:GetPos(), function(item, entity)
					self.ration:SetNoDraw(true)
					timer.Simple(1, function()
						for k, v in pairs(self.RationLoaded[lvl][#self.RationLoaded[lvl]]) do
							ix.item.inventories[item:GetData('id')]:Add(k, v)
						end;							
						self.RationLoaded[lvl][#self.RationLoaded[lvl]] = nil;
						self.rationNext = ""
					end)
				end, self.ration:GetAngles())
				cid:SetData("nextRationTime", os.time() + 640)
			end;

			self.used = false;
		end);
	end)


end;
include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
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

		self.rationsInside = {
			["1lvl"] = {
				ration_default = 10
			},
			["2lvl"] = {
				ration_second_better = 10
			},
			["3lvl"] = {
				ration_loyal_tier = 10
			}
		}

		self.dispenser = ents.Create("prop_dynamic");
		self.dispenser:SetModel("models/props_combine/combine_dispenser.mdl");
		self.dispenser:SetPos(self:GetPos());
		self.dispenser:SetAngles(self:GetAngles() + Angle(0,90,0));
		self.dispenser:SetCollisionGroup( 20 );
		self.dispenser:SetParent(self)
		self.dispenser:Spawn();

		self.IsUsed = false;

		for k, v in pairs(ents.FindInBox(self:LocalToWorld(self:OBBMins()), self:LocalToWorld(self:OBBMaxs()))) do
			if (string.find(v:GetClass(), "prop") and v:GetModel() == model) then
				self:SetPos(v:GetPos());
				self:SetAngles(v:GetAngles());
				SafeRemoveEntity(v);

				return;
			end;
		end;
	end;

function ENT:Ration()
	local forward = self:GetForward() * 15;
	local right = self:GetRight() * 0;
	local up = self:GetUp() * -8;
		
	local entity = ents.Create("prop_physics");
	entity:SetAngles( self:GetAngles() );
	entity:SetModel("models/weapons/w_package.mdl");
	entity:SetPos(self:GetPos() + forward + right + up);
	entity:Spawn();
		
	return entity;
end;

function ENT:StartTouch(ent)
	if ent:GetClass() == "cw_item" && git(ent, "baseItem") == "ration_base" && !self:GetRegimeTurned() then
		if table.Count(git(ent, "rationContains")["items"]) != 2 then
			return;
		end;
		for k, v in pairs(self.rationsInside) do
			if table.HasValue(v, git(ent, "uniqueID")) then
				v[git(ent, "uniqueID")] = v[git(ent, "uniqueID")] + 1
			end;
		end;
		self:EmitSound("items/ammocrate_open.wav")
		ent:Remove();
	end;
end;

function ENT:Use(activator, caller)
	local d = self.dispenser;

	if activator:KeyDown( IN_SPEED ) && Schema:PlayerIsCombine(activator) then
		if self:GetRegimeTurned() then
			self:SetRegimeTurned(false)
		elseif !self:GetRegimeTurned() then
			self:SetRegimeTurned(true)
		end;
		return;
	end;

	local card = activator:FindItemByID("citizen_civ_card");
	if !card || !self:GetRegimeTurned() || card:GetData("CardInformation")["CooldownRations"] > 0 || activator:GetItemCountByID("citizen_civ_card") > 1 then
		self:EmitSound("buttons/combine_button_locked.wav")
		return;
	end;
	local cardinfo = card:GetData("CardInformation");	
	local tblToCheck;
	if cardinfo.OL >= 0 then
		tblToCheck = self.rationsInside["1lvl"]
	elseif cardinfo.OL >= 10 then
		tblToCheck = self.rationsInside["2lvl"]
	elseif cardinfo.OL >= 20 then
		tblToCheck = self.rationsInside["3lvl"]
	end;	
	for k, v in pairs(tblToCheck) do
		if v == 0 then
			self:EmitSound("buttons/combine_button_locked.wav")
			return;
		end;
	end;

	if !self.IsUsed then
		local ration = self:Ration();
		self.IsUsed = true;
		ration:SetNotSolid(true);
		ration:SetParent(d);
		ration:Fire("SetParentAttachment", "package_attachment", 0);

		d:EmitSound("ambient/machines/combine_terminal_idle2.wav");
		d:Fire("SetAnimation", "dispense_package", 0);
		timer.Simple(1.5, function()
			if activator:Alive() then
				for k, v in pairs(tblToCheck) do
					if v > 0 then
						local itemTable = Clockwork.item:CreateInstance(k);
						Clockwork.entity:CreateItem(activator, itemTable, ration:GetPos(), ration:GetAngles());
						tblToCheck[k] = tblToCheck[k] - 1
					end;
				end;
			end;
			ration:SetNoDraw(true)
			ration:Remove();

			card:GetData("CardInformation")["CooldownRations"] = 2600
			card:GetData("CardInformation")["Rations"] = card:GetData("CardInformation")["Rations"] + 1
		end)
		timer.Create(self:EntIndex()..math.random(0, 999999), 3, 1, function()
			self.IsUsed = false;
		end)
	end;
end;
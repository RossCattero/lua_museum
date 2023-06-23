include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = ""

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		
		

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
			physObj:Sleep();
		end;


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
	local enttbl = self.blueprintToDo;
	local bptbl = self.blueprint;

	if table.Count(bptbl["items"]) != 0 then
		if ent:GetClass() == "cw_item" && bptbl["items"][git(ent, "uniqueID")] && enttbl["items"][git(ent, "uniqueID")] == nil && git(ent, 'isInsrument') == nil then
			enttbl["items"][git(ent, "uniqueID")] = 1;
			ent:Remove();
			return;
		end;
		if ent:GetClass() == "cw_item" && enttbl["items"][git(ent, "uniqueID")] != nil && (enttbl["items"][git(ent, "uniqueID")] < bptbl["items"][git(ent, "uniqueID")]) && git(ent, 'isInsrument') == nil then
			enttbl["items"][git(ent, "uniqueID")] = math.Clamp(enttbl["items"][git(ent, "uniqueID")] + 1, 0, bptbl["items"][git(ent, "uniqueID")]);
			ent:Remove();
		end;
	end;

	if table.Count(bptbl["instruments"]) != 0 then
		if ent:GetClass() == "cw_item" && bptbl["instruments"][git(ent, "uniqueID")] && enttbl["instruments"][git(ent, "uniqueID")] == nil && git(ent, 'isInsrument') != nil then
			enttbl["instruments"][git(ent, "uniqueID")] = 1;
			ent:Remove();
			return;
		end;
		if ent:GetClass() == "cw_item" && enttbl["instruments"][git(ent, "uniqueID")] != nil && (enttbl["instruments"][git(ent, "uniqueID")] < bptbl["instruments"][git(ent, "uniqueID")]) && git(ent, 'isInsrument') != nil then
			enttbl["instruments"][git(ent, "uniqueID")] = math.Clamp(enttbl["instruments"][git(ent, "uniqueID")] + 1, 0, bptbl["instruments"][git(ent, "uniqueID")]);
			ent:Remove();
		end;
	end;
end;

function ENT:Use(activator, caller)
end;
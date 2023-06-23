include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/props_combine/breenconsole.mdl"

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

function ENT:Think()
end;

function ENT:Use(activator, caller)
	local items = Clockwork.inventory:GetAsItemsList(activator:GetInventory());
	local cards = {}
	for k, v in ipairs(items) do
		if v("uniqueID") == "citizen_civ_card" then
			cards[v.itemID] = {
				OwnerName = v:GetData("CardInformation").OwnerName;
				CID = v:GetData("CardInformation").OwnerCID;
				Rations = v:GetData("CardInformation").Rations;
				CooldownRations = v:GetData("CardInformation").CooldownRations;
				OL = v:GetData("CardInformation").OL;
				ON = v:GetData("CardInformation").ON;
			}
		end;
	end;
	cable.send(activator, 'OpenCitizenInfo', cards);
end;
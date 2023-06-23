include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = self:PlaceModelHere()

		self:SetModel(model);
		
		self:DrawShadow(true);
	    self:SetSolid(SOLID_BBOX);
	    self:PhysicsInit(SOLID_BBOX);
	    self:SetMoveType(MOVETYPE_NONE);
		self:SetUseType(SIMPLE_USE);
		
		self.dialogueNPC = {
			questions = {
				["startIndex"] = {
					info = "Это пример вопроса.",
					sound = ""
				}
			},
			anwsers = {
				["quit"] = {
					info = "Пока.",
					sound = ""
				}
			}
		};

		self.reconizedCharacters = {}
		self.entInfo = {
			factionsAllowed = {},
			TalkOnNear = {};
		};

		self.ItemsInStock = {
			[1] = {
				name = "",
				price = 0
			},
			[2] = {
				name = "",
				price = 0
			},
			[3] = {
				name = "",
				price = 0
			},
			[4] = {
				name = "",
				price = 0
			},
			[5] = {
				name = "",
				price = 0
			},
			[6] = {
				name = "",
				price = 0
			},
			[7] = {
				name = "",
				price = 0
			},
			[8] = {
				name = "",
				price = 0
			}
		}
		
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
end;
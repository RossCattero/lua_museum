include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/frp/citizen_male_01.mdl"
		
		self:DrawShadow(true);
		self:SetSolid(SOLID_BBOX);
		self:PhysicsInit(SOLID_BBOX);
		self:SetMoveType(MOVETYPE_NONE);
		self:SetUseType(SIMPLE_USE);

		if !self.ItemsInStock then
			self.ItemsInStock = {};
		end;
		if !self.CwuInventory then
			self.CwuInventory = {};
		end;
		if !self.reconizedCharacters then
			self.reconizedCharacters = {};
		end;

		if !self.bodygroups then
			self.bodygroups = {};
		end

		if !self.dialogueNPC then
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
						sound = "",
						isUsed = false
					}
				}
			};
		end;

		if !self.itemInventory then
			self.itemInventory = {};
		end;

		if !self.sellerData then
			self.sellerData = {
				name = "John Doe",
				id = os.time() + self:EntIndex(),
				isCwu = false
			};
		end;
		if !self.entInfo then
			self.entInfo = {
				factionsAllowed = {},
				TalkOnNear = {
					"",
					"",
					""
				},
				sequence = 4,
				sellerMdl = model
			};
		end;
		self:SetModel( self.entInfo["sellerMdl"] )
		self:SetSequence( self.entInfo["sequence"] )
		self:SetInfoName( self.sellerData["name"] )
		
		for i = 1, 8 do
			if !self.ItemsInStock[i] then
				self.ItemsInStock[i] = {
					uniqueID = "",
					price = 0,
					model = "",
					skin = 0,
					count = 0
				}
			end
		end;

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

function ENT:StartTouch(ent)
	if self.sellerData["isCwu"] && ent:IsValid() && ent:GetClass() == "cw_item" && table.Count(self.CwuInventory) < 10 && git(ent, "uniqueID") == "notepad_basic" && !self:GetIsDisabled() then
		table.insert(self.CwuInventory, {
			title = git(ent, "data")["NotepadTableForMe"]["title"],
			owner = git(ent, "data")["NotepadTableForMe"]["owner"],
			pickup = git(ent, "data")["NotepadTableForMe"]["pickup"],
			information = git(ent, "data")["NotepadTableForMe"]["information"],
			pages = git(ent, "data")["NotepadTableForMe"]["pages"],
			additionalInfo = {
				uniqueID = git(ent, "uniqueID"),
				ItemID = git(ent, "itemID")
			}
		})
		self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 5)..".wav")
		ent:Remove();
	end;
end;

function ENT:Use(activator, caller)
end;
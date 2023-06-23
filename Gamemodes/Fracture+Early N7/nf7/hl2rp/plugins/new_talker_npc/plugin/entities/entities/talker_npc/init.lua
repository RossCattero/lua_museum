include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		
		self:DrawShadow(true);
		self:SetSolid(SOLID_BBOX);
		self:PhysicsInit(SOLID_BBOX);
		self:SetMoveType(MOVETYPE_NONE);
		self:SetUseType(SIMPLE_USE);
		
		if !self.sellerInformation then
			self.sellerInformation = {
				name = 'John',
				model = 'models/frp/citizen_male_01.mdl',
				sequence = 4,
				factionsAllowed = {},
				disallow = '',
				allowtosell = true,
				allowbuy = true,
				allowsell = true
			}
		end;

		self:SetModel(self.sellerInformation['model']);
		self:ResetSequence( self.sellerInformation['sequence'] );

		if !self.identificator then
			self.identificator = os.time() + math.random(1, 12);
		end;
		if !RossTalkers.talktable[self.identificator] then
			RossTalkers.talktable[self.identificator] = {
				['starttalking'] = {
					text = 'Это пример вопроса.',
					CallOnAppear = {'endtalking'},
					default = true,
					sound = '',
					isAnwser = true	
				},
				['endtalking'] = {
					text = 'Понял.',
					CallAnwser = {},
					RemoveOnAppear = {},
					CallQuestions = {},
					default = true,
					isQuestion = true
				}
			};
		end;
		if !self.sellerInventory then
			self.sellerInventory = {};
		end;
		if !self.bodygroups then
			self.bodygroups = {};
		end;

		self:SetDefaultName( self.sellerInformation['name'] )
		self:SetAllowSell(self.sellerInformation['allowtosell'])

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

function ENT:HasItemInInv(id, itemid)
	for k, v in pairs(self.sellerInventory) do
		if v.uniqueID == id && v.itemID == itemid then
			return true;
		end;
	end;

	return false;
end;

function ENT:TakeItemFromInv(id, itemid)

	for k, v in pairs(self.sellerInventory) do
		if v.uniqueID == id && v.itemID == itemid then
			self.sellerInventory[k] = nil;
			return;
		end;
	end;

end;

function ENT:StartTouch(ent)
end;

function ENT:Use(activator, caller)
	cable.send(player, 'OpenTalkerTalking', {})
end;

function ENT:OnRemove()

	RossTalkers.talktable[self.identificator] = nil;

end;
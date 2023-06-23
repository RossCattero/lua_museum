include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

local PLUGIN = PLUGIN;

function ENT:Initialize()
		
		self:DrawShadow(true);
		self:SetSolid(SOLID_BBOX);
		self:PhysicsInit(SOLID_BBOX);
		self:SetMoveType(MOVETYPE_NONE);
		self:SetUseType(SIMPLE_USE);

		if !self.sellerInformation then
			self.sellerInformation = {
				name = 'John',
				model = 'models/stalker_roleplay/lone/male_09.mdl',
				sequence = 4,
				factionsAllowed = {},
				disallow = '',
				allowtosell = true,
				allowbuy = true,
				allowsell = true
			}
		end;
		if !self.identificator then
			self.identificator = os.time() + math.random(1, 12);
		end;
		self:SetModel(self.sellerInformation['model']);
		self:ResetSequence( self.sellerInformation['sequence'] );
		if !self.bodygroups then
			self.bodygroups = {};
		end;
		self:SetDefaultName( self.sellerInformation['name'] )
		self:SetAllowSell(self.sellerInformation['allowtosell'])
		
		local talkTbl = ix.data.Get("TalkerMessages")
		if !talkTbl[self.identificator] then
			talkTbl[self.identificator] = {
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

		ix.data.Set("TalkerMessages", talkTbl)

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

function ENT:OnOptionSelected(player, option, data)
	local id, info = self.identificator, self.sellerInformation
	local Pfaction = team.GetName(player:GetCharacter():GetFaction())

	local factionallowed = info['factionsAllowed'];
	local allowed = (next(factionallowed) == nil || factionallowed[Pfaction] == true);
	if ( option == "Поговорить" ) then
		if allowed then
			netstream.Start(player, "OpenTalkerTalking", ix.data.Get("TalkerMessages")[self.identificator], self.identificator, self.sellerInformation)
		else
			player:Notify(info['disallow'])
		end;
	elseif option == "Настроить" then
		if player:IsAdmin() or player:IsSuperAdmin() then
			netstream.Start(player, 'OpenTalkerSettings', ix.data.Get("TalkerMessages")[self.identificator], self.identificator, self.sellerInformation, self)
		end;
	end;
end;
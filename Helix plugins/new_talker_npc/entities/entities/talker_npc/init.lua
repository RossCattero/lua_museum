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
		if !PLUGIN.talktable[self.identificator] then
			PLUGIN.talktable[self.identificator] = {
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

function ENT:OnOptionSelected(player, option, data)
	local char = player:GetCharacter()
	local inventory, Pfaction = {}, char:GetFaction();
	local factionallowed = self.sellerInformation['factionsAllowed'];
	local allowed = (table.Count(factionallowed) == 0 || factionallowed[Pfaction] == true);
    local inv, steamid, name = char:GetInventory():GetItems(), player:SteamID(), player:Name()
    local npc = char:GetData('NPCskilled');
    if ( option == "Поговорить" && allowed ) then
		netstream.Start(player, "OpenTalkerTalking", PLUGIN.talktable, self.identificator, self.sellerInformation, PLUGIN.questsTable[ steamid ][ name ], npc)
	elseif (option == 'Настроить' && (player:IsAdmin() || player:IsSuperAdmin())) then
		netstream.Start(player, 'OpenTalkerSettings', PLUGIN.talktable, self.identificator, self.sellerInformation, self)
    elseif (arguments == 'Торговать') then
        if allowed && self.sellerInformation['allowtosell'] then 
            for k, v in ipairs( inv ) do
                table.insert(inventory, {
                    uniqueID = v.uniqueID,
                    name = v.name,
                    model = v.model,
                    skin = v.skin,
                    priceSales =  0,
                    quality = 0
                })
			end;
			netstream.Start(player, 'OpenTalkerVendor', inventory, self.sellerInventory, self, self.sellerInformation)
        end;
    end;
end;

function ENT:OnRemove()
	PLUGIN.talktable[self.identificator] = nil;
end;
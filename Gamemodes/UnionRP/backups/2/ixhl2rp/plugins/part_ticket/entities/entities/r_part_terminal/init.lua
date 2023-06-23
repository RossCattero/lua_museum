include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local math = math;
local mc = math.Clamp;

function ENT:Initialize()
		local model = "models/union/props/terminal.mdl"

		self:SetModel(model);
		
		-- Для нестатичного.
		self:DrawShadow(true);
	    self:SetSolid(SOLID_VPHYSICS);
	    self:PhysicsInit(SOLID_VPHYSICS);
	    self:SetMoveType(MOVETYPE_VPHYSICS);
	    self:SetUseType(SIMPLE_USE);
		
		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(true);
			physObj:Wake()
		end;

		self.cardInside = {
			['name'] = '',
			['age'] = 0,
			['liveplace'] = '',
			['town'] = '',
			['status'] = 'ALPHA',
			['partyID'] = '000000',
			['HasCard'] = false
		}

		timer.Create(self:EntIndex()..' - TERMINAL', 15, 0, function()
			if !IsValid(self) then timer.Remove(self:EntIndex()..' - TERMINAL') return; end;
			self:SetSkin(math.random(1, 2))
		end)

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

	local hasCard = self.cardInside['HasCard'];
	if option == 'Открыть интерфейс' then
		local f = player:IsCombine()

		if !f && !player:IsAdmin() then
			self:EmitSound('buttons/button11.wav')
			return;
		end;

		netstream.Start(player, 'OpenTerminalInterface', self.cardInside)
	elseif option == 'Достать карточку' && hasCard then

		local char = player:GetCharacter();
		local inv = char:GetInventory();

		inv:Add('part_ticket', 1, {
			owner_name = self.cardInside['name'],
			age = self.cardInside['age'],
			liveplace = self.cardInside['liveplace'],
			town = self.cardInside['town'],
			status = self.cardInside['status'],
			partyID = self.cardInside['partyID'],
		})

		self.cardInside['name'] = ''
		self.cardInside['age'] = 0
		self.cardInside['liveplace'] = ''
		self.cardInside['town'] = ''
		self.cardInside['status'] = 'ALPHA'
		self.cardInside['partyID'] = '000000'

		self.cardInside['HasCard'] = false;
		self:SetTerminalCard(self.cardInside['HasCard']);

		player:EmitSound('physics/body/body_medium_impact_soft3.wav')
	end;

end;

function ENT:StartTouch(entity)
	local hasCard = self.cardInside['HasCard'];

	if entity:GetClass() == 'ix_item' && !hasCard then
		self.cardInside['name'] = entity:GetNetVar('data')['owner_name']
		self.cardInside['age'] = entity:GetNetVar('data')['age']
		self.cardInside['liveplace'] = entity:GetNetVar('data')['liveplace']
		self.cardInside['town'] = entity:GetNetVar('data')['town']
		self.cardInside['status'] = entity:GetNetVar('data')['status']
		self.cardInside['partyID'] = entity:GetNetVar('data')['partyID']

		self.cardInside['HasCard'] = true
		entity:Remove();
		self:SetTerminalCard(self.cardInside['HasCard']);

		entity:EmitSound('buttons/button4.wav')
	end;

end;
local PLUGIN = PLUGIN;

function PLUGIN:PlayerLoadedChar(client, character, prev)
		timer.Simple(0.25, function()
				character:setData("GPoints", character:getData("GPoints", 0))
				client:setLocalVar("GPoints", character:getData("GPoints", 0))

				character:setData("GermanTier", character:getData("GermanTier", 0))
				client:setLocalVar("GermanTier", character:getData("GermanTier", 0))
				client:setNetVar("GermanTier", character:getData("GermanTier", 0))
		end);
end;

function PLUGIN:CharacterPreSave(character)
		local client = character:getPlayer()
    if (IsValid(client)) then
 				character:setData("GPoints", character:getData("GPoints", 0))
		end;
end;

local client = FindMetaTable("Player")

function client:AddGPoints(point)
		local char = self:getChar();
		local points = char:getData("GPoints", 0)

		points = math.Clamp(points + point, MIN_POINTS, MAX_POINTS);

		char:setData("GPoints", points);
		self:setLocalVar("GPoints", points);

		self:UpdateGTier( points )
end;

function client:UpdateGTier( points )
		local loyalty = PLUGIN.loyaltyList;

		for k, v in ipairs( loyalty ) do
				if points >= v.min && (!v.max || points <= v.max) then
						self:SetGermanTier(k)
						return;
				end 
		end

		self:SetGermanTier(0)
end;

function client:SetGermanTier(tier)
		local char = self:getChar();

		char:setData("GermanTier", tier)
		self:setLocalVar("GermanTier", tier)
		self:setNetVar("GermanTier", tier)
end;

function PLUGIN:GetSalaryAmount( ply, faction )
    local tier = ply:getChar():getData("GermanTier", 0)

    return tier > 0 && self.loyaltyList[tier] && self.loyaltyList[tier].benefit;
end;
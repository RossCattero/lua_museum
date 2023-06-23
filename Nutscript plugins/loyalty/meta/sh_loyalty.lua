local loyalty = nut.meta.loyalty or {}

loyalty.__index = loyalty

loyalty.charID = 0;
loyalty.points = 0;
loyalty.maxPoints = 1000;
loyalty.tier = 0;

function loyalty:__tostring()
	return "Loyalty status["..self:GetID().."]"
end

function loyalty:GetID() 
	return self.charID
end;

function loyalty:__eq( objectOther )
	return self:GetID() == objectOther:GetID()
end

function loyalty:AddPoints(points)
	self.points = math.Clamp(self.points + points, 0, self.maxPoints);

	for k, v in pairs(nut.loyalty.tier.list) do
		if self.points >= v.min && (!v.max || v.max == 0 || self.points < v.max) then
			self.tier = string.lower(k);
			self:Sync();
			return;
		end;
	end;
end;

function loyalty:GetTier()
	return nut.loyalty.tier.list[ self.tier ];
end;

function loyalty:Sync( client )
	netstream.Start(player.GetAll(), "nut.loyalty.sync", self)
end;

nut.meta.loyalty = loyalty
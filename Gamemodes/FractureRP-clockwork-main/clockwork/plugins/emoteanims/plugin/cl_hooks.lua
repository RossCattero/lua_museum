-- Called when the local player should be drawn.
function cwEmoteAnims:ShouldDrawLocalPlayer()
	if (self:IsPlayerInStance(Clockwork.Client)) then
		return true;
	end;
end;

-- Called when a player's animation is updated.
function cwEmoteAnims:UpdateAnimation(player)
	if (self:IsPlayerInStance(player)) then
		player:SetRenderAngles(player:GetSharedVar("StanceAng"));
	end;
end;

-- Called when the calc view table should be adjusted.
function cwEmoteAnims:CalcViewAdjustTable(view)
	if (self:IsPlayerInStance(Clockwork.Client)) then
		local ent = GetViewEntity()
		
		if ent != LocalPlayer() then return end
		
		-- local idleStance = Clockwork.Client:GetSharedVar("StanceIdle");
		local position = Clockwork.Client:EyePos();
		local angles = Clockwork.Client:GetSharedVar("StanceAng"):Forward();
		
		local tr = util.TraceLine({
			start = position,
			endpos = position - (angles * 64);
			filter = Clockwork.Client
		});
		
		if (position:DistToSqr(tr.HitPos) < 400) then
			tr = util.TraceLine({
				start = position,
				endpos = position + (angles * 64);
				filter = Clockwork.Client
			});
		end
		
		view.origin = tr.HitPos + (angles * 4);
	end;
end;
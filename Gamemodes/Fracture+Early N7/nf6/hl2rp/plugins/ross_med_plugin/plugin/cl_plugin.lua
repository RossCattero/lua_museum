local PLUGIN = PLUGIN;

PLUGIN.healEffects = {};
PLUGIN.healPaint = {};

cable.receive('HealEffectOn', function(num)
	PLUGIN:AddHealEffect(num)
end);

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "UseMedkit") then
			return {text = "Использование аптечки...", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

function PLUGIN:HUDPaintForeground()
	local curTime = CurTime();
	
	if (Clockwork.Client:Alive()) then
		if (self.healPaint) then
			for k, v in pairs(self.healPaint) do
				local alpha = math.Clamp((255 / v[2]) * (v[1] - curTime), 0, 50);
				
				if (alpha != 0) then
					draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(100, 255, 100, alpha));
				else
					table.remove(self.healPaint, k);
				end;
			end;
		end;
	end;
end;

function PLUGIN:AddHealEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	table.insert(self.healEffects, {curTime + duration, duration});
	table.insert(self.healPaint, {curTime + (duration * 2), duration * 2, true});
end;
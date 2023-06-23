local COMMAND = Clockwork.command:New("AnimCp");
COMMAND.tip = "For F1 menu.";
COMMAND.text = "<string Anim>";
COMMAND.arguments = 1;
COMMAND.animTable = {
	["stopwomanpre"] = 0,
	["adoorknock"] = 0,
	["idleonfire"] = 0,
	["arrestpreidle"] = 0,
	
	["harassfront2"] = 2,
	["motionleft"] = 2,
	["motionright"] = 2,
	["plazathreat1"] = 5,
	["plazathreat2"] = 5,
	["shootflare"] = 2,
	["Spreadwall"] = 4,
};
COMMAND.animTableWall = {
	["Idle_Baton"] = 0,
};

if (CLIENT) then
	--Clockwork.quickmenu:AddCommand("Встать", "Анимации ГО (CP models)", COMMAND.name, {
		--{"Напряженно", "stopwomanpre"},
		--{"Стучать", "adoorknock"},
		--{"Танцевать", "idleonfire"},
		--{"Доминировать", "arrestpreidle"},
	--});
	Clockwork.quickmenu:AddCommand("Возле стены", "Анимации ГО (CP/Male models)", COMMAND.name, {
		{"Облокотиться назад", "Idle_Baton"},
	});
	Clockwork.quickmenu:AddCommand("Другое", "Анимации ГО (CP/Male models)", COMMAND.name, {
		{"Запретить", "harassfront2"},
		{"Направить влево", "motionleft"},
		{"Направить вправо", "motionright"},
		{"Потереть дубинку", "plazathreat1"},
		{"Постучать дубинкой", "plazathreat2"},
		--{"Выстрел в воздух", "shootflare"},
		--{"Обыскать", "Spreadwall"},
	});
end;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();

	if (player:Alive() and !player:IsRagdolled() and !player:IsNoClipping()) then
		if (!player.cwNextStance or curTime >= player.cwNextStance) then
			player.cwNextStance = curTime + 2;

			local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

			if (modelClass == "civilProtection") then
				local forcedAnimation = player:GetForcedAnimation();
				
				if (forcedAnimation) then
					cwEmoteAnims:MakePlayerExitStance(player);
				else
					local anim = arguments[1];
					local forward = player:GetForward();
					
					if (COMMAND.animTable[anim]) then
						player:SetSharedVar("StancePos", player:GetPos());
						player:SetSharedVar("StanceAng", player:GetAngles());
						
						player:SetForcedAnimation(anim, COMMAND.animTable[anim]);
					elseif (COMMAND.animTableWall[anim]) then
						local tr = util.TraceLine({
							start = player:EyePos(),
							endpos = player:EyePos() + forward*-20,
							filter = player
						});
						
						if (tr.Hit) then
							player:SetEyeAngles(tr.HitNormal:Angle() + Angle(0, 180, 0));
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						else
							Clockwork.player:Notify(player, "Вы должны стоять лицом к стене!");
						end;
					else
						Clockwork.player:Notify(player, "Такой анимации нет!");
					end;
				end;
			else
				Clockwork.player:Notify(player, "Ваша модель не поддерживает эту анимацию!");
			end;
		else
			Clockwork.player:Notify(player, "Вы не можете выполнить еще одну анимацию!");
		end;
	else
		Clockwork.player:Notify(player, "Вы не можете сделать это сейчас!");
	end;
end;

COMMAND:Register();
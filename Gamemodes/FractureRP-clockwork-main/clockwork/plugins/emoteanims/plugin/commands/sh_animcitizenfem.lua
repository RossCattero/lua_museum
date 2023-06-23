local COMMAND = Clockwork.command:New("AnimCitizenFem");
COMMAND.tip = "For F1 menu.";
COMMAND.text = "<string Anim>";
COMMAND.arguments = 1;
COMMAND.animTable = {
	["LineIdle01"] = 0,
	["LineIdle02"] = 0,
	["LineIdle03"] = 0,
	["canals_arlene_pourgas"] = 0,
	["d2_coast03_PostBattle_Idle02"] = 0,
	["cower_Idle"] = 0,

	["base_cit_medic_postanim"] = 0,
	["canals_mary_postidle"] = 0,
	["canals_mary_preidle"] = 0,
	["checkmalepost"] = 0,
	["d1_town05_Jacobs_Heal"] = 0,
	["Sit_Ground"] = 0,
	["plazaidle4"] = 0,

	["cheer1"] = 2,
	["Wave_close"] = 3,
	["Wave"] = 3,
	["stopwomanpre"] = 0,
	["d1_t01_Clutch_Chainlink_Idle"] = 0,
};
COMMAND.animTableTrace = {
	["Lying_Down"] = 0,
	["d1_town05_Wounded_Idle_1"] = 0,
};
COMMAND.animTableWall = {
	["d2_coast03_PostBattle_Idle01"] = 0,
	["d1_t03_Tenements_Look_Out_Window_Idle"] = 0,
	["Lean_Left"] = 2,
	["Lean_Back"] = 1,
	["plazaidle1"] = 1,
};

if (CLIENT) then
	Clockwork.quickmenu:AddCommand("Встать", "Женские анимации (female models)", COMMAND.name, {
		{"Скрестить руки", "LineIdle01"},
		{"Взяться за другую руку", "LineIdle02"},
		{"Держать подбородок", "LineIdle03"},
		--{"Напряженно", "canals_arlene_pourgas"},
		{"Одышка", "d2_coast03_PostBattle_Idle02"},
		--{"Прятать голову", "cower_Idle"},
	});
	Clockwork.quickmenu:AddCommand("Возле стены", "Женские анимации (female models)", COMMAND.name, {
		{"Одышка, лицом к стене", "d2_coast03_PostBattle_Idle01"},
		--{"Смотреть в окно", "d1_t03_Tenements_Look_Out_Window_Idle"},
		{"Облокотиться влево", "Lean_Left"},
		{"Облокотиться назад", "Lean_Back"},
		--{"Облокотиться назад, руки за спину", "plazaidle1"},
	});
	Clockwork.quickmenu:AddCommand("Присесть", "Женские анимации (female models)", COMMAND.name, {
		--{"На колено", "base_cit_medic_postanim"},
		{"На колени", "canals_mary_postidle"},
		{"На колени (2)", "canals_mary_preidle"},
		--{"Осматривать предмет", "checkmalepost"},
		--{"Изучать пол", "d1_town05_Jacobs_Heal"},
		{"На пол", "Sit_Ground"},
		{"На корты", "plazaidle4"},
	});
	Clockwork.quickmenu:AddCommand("Лечь", "Женские анимации (female models)", COMMAND.name, {
		{"На спину, спокойно", "Lying_Down"},
		{"На бок, корчиться", "d1_town05_Wounded_Idle_1"},
	});
	Clockwork.quickmenu:AddCommand("Другое", "Женские анимации (female models)", COMMAND.name, {
		{"Прыгать от радости", "cheer1"},
		{"Позвать к себе", "Wave_close"},
		{"Позвать к себе, махать рукой", "Wave"},
		{"Прикрываться руками", "stopwomanpre"},
		--{"Поднять руки перед собой", "d1_t01_Clutch_Chainlink_Idle"},
	});
end;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local curTime = CurTime();

	if (player:Alive() and !player:IsRagdolled() and !player:IsNoClipping()) then
		if (!player.cwNextStance or curTime >= player.cwNextStance) then
			player.cwNextStance = curTime + 2;

			local modelClass = Clockwork.animation:GetModelClass(player:GetModel());

			if (modelClass == "femaleHuman") or (modelClass == "civilProtectionfemale") then
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
					elseif (COMMAND.animTableTrace[anim]) then
						local tr = util.TraceLine({
							start = player:GetPos() + Vector(0, 0, 16) + forward*35,
							endpos = player:GetPos() + Vector(0, 0, 16) - forward*35,
							filter = player
						});
						
						if (tr.Hit) then
							Clockwork.player:Notify(player, "Вам не хватает места!");
						else
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						end;
					elseif (COMMAND.animTableWall[anim]) then
						local trendpos = forward*20;
						
						if (COMMAND.animTableWall[anim] == 1) then
							trendpos = forward*-20;
						elseif (COMMAND.animTableWall[anim] == 2) then
							trendpos = player:GetRight()*-20;
						end
						
						local tr = util.TraceLine({
							start = player:EyePos(),
							endpos = player:EyePos() + trendpos,
							filter = player
						});
						
						if (tr.Hit) then
							player:SetEyeAngles(tr.HitNormal:Angle() + Angle(0, 180, 0));
							player:SetSharedVar("StancePos", player:GetPos());
							player:SetSharedVar("StanceAng", player:GetAngles());
							
							player:SetForcedAnimation(anim, 0);
						else
							if (COMMAND.animTableWall[anim] == 1) then
								Clockwork.player:Notify(player, "Вы должны стоять спиной к стене!");
							elseif (COMMAND.animTableWall[anim] == 2) then
								Clockwork.player:Notify(player, "Вы должны стоять левым боком к стене!");
							else
								Clockwork.player:Notify(player, "Вы должны стоять лицом к стене!");
							end
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